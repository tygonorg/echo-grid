//
//  DailyChallengeManager.swift
//  Echo Grid
//

import Foundation
import SwiftUI
import Combine

@MainActor
public final class DailyChallengeManager: ObservableObject {
    public static let shared = DailyChallengeManager()
    public static let appGroupSuiteName = "group.tygon.org.echogrid"

    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: Self.appGroupSuiteName) ?? UserDefaults.standard
    }

    private let storageKey = "echo_grid_daily_history_v1"
    private let streakKey = "echo_grid_daily_streak_v1"
    private let maxStreakKey = "echo_grid_daily_max_streak_v1"

    @Published public private(set) var history: [String: DailyChallengeRecord] = [:]
    @Published public private(set) var currentStreak: Int = 0
    @Published public private(set) var maxStreak: Int = 0

    public static var utcCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC") ?? TimeZone(secondsFromGMT: 0)!
        return cal
    }

    public static var utcDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC") ?? TimeZone(secondsFromGMT: 0)!
        return formatter
    }

    private init() {
        self.history = Self.loadHistory(key: storageKey, sharedDefaults: UserDefaults(suiteName: Self.appGroupSuiteName) ?? .standard)
        self.currentStreak = (UserDefaults(suiteName: Self.appGroupSuiteName) ?? .standard).integer(forKey: streakKey)
        self.maxStreak = (UserDefaults(suiteName: Self.appGroupSuiteName) ?? .standard).integer(forKey: maxStreakKey)
        recalculateStreak()
    }

    public var todayDateKey: String {
        Self.utcDateFormatter.string(from: Date())
    }

    public var isTodayCompleted: Bool {
        history[todayDateKey]?.isCompleted ?? false
    }

    public var todayRecord: DailyChallengeRecord {
        if let rec = history[todayDateKey] {
            return rec
        }
        return DailyChallengeRecord(dateKey: todayDateKey)
    }

    public func getTodayLevel() -> LevelDefinition {
        LevelGenerator.shared.generateDailyPuzzle(for: todayDateKey)
    }

    public func recordTodayCompletion(moves: Int, timeSec: Double, parMoves: Int) -> DailyChallengeRecord {
        let key = todayDateKey
        var record = todayRecord

        let stars: Int
        if moves <= parMoves {
            stars = 3
        } else if moves <= parMoves + 2 {
            stars = 2
        } else {
            stars = 1
        }

        record.isCompleted = true
        record.movesCount = moves
        record.timeElapsedSec = timeSec
        record.stars = max(record.stars, stars)
        record.completedAt = Date()

        history[key] = record
        saveHistory()

        // Update Streak
        recalculateStreak()

        return record
    }

    private func recalculateStreak() {
        let calendar = Self.utcCalendar
        let formatter = Self.utcDateFormatter

        let now = Date()
        let todayStr = formatter.string(from: now)
        var streak = 0

        var checkDate: Date
        if history[todayStr]?.isCompleted == true {
            streak += 1
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else {
                updateStreakValues(streak: streak)
                return
            }
            checkDate = yesterday
        } else {
            // Today is not completed yet; check if yesterday was completed to keep the streak alive
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else {
                updateStreakValues(streak: streak)
                return
            }
            checkDate = yesterday
        }

        // Loop backwards for consecutive completed days
        while true {
            let dateStr = formatter.string(from: checkDate)
            if history[dateStr]?.isCompleted == true {
                streak += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = prev
            } else {
                break
            }
        }

        updateStreakValues(streak: streak)
    }

    private func updateStreakValues(streak: Int) {
        self.currentStreak = streak
        if streak > maxStreak {
            self.maxStreak = streak
            sharedDefaults.set(maxStreak, forKey: maxStreakKey)
            UserDefaults.standard.set(maxStreak, forKey: maxStreakKey)
        }
        sharedDefaults.set(currentStreak, forKey: streakKey)
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
    }

    public var totalDailyCompleted: Int {
        history.values.filter { $0.isCompleted }.count
    }

    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            sharedDefaults.set(data, forKey: storageKey)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save daily history: \(error)")
        }
    }

    private static func loadHistory(key: String, sharedDefaults: UserDefaults) -> [String: DailyChallengeRecord] {
        let data = sharedDefaults.data(forKey: key) ?? UserDefaults.standard.data(forKey: key)
        guard let data = data else {
            return [:]
        }
        do {
            return try JSONDecoder().decode([String: DailyChallengeRecord].self, from: data)
        } catch {
            return [:]
        }
    }
}
