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

    private let storageKey = "echo_grid_daily_history_v1"
    private let streakKey = "echo_grid_daily_streak_v1"
    private let maxStreakKey = "echo_grid_daily_max_streak_v1"

    @Published public private(set) var history: [String: DailyChallengeRecord] = [:]
    @Published public private(set) var currentStreak: Int = 0
    @Published public private(set) var maxStreak: Int = 0

    private init() {
        self.history = Self.loadHistory(key: storageKey)
        self.currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        self.maxStreak = UserDefaults.standard.integer(forKey: maxStreakKey)
        recalculateStreak()
    }

    public var todayDateKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
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
        let calendar = Calendar.current
        var checkDate = Date()
        var streak = 0

        // If today is completed, start streak at 1 and look backwards
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let todayStr = formatter.string(from: checkDate)
        if history[todayStr]?.isCompleted == true {
            streak += 1
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) {
                checkDate = yesterday
            }
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

        self.currentStreak = streak
        if streak > maxStreak {
            self.maxStreak = streak
            UserDefaults.standard.set(maxStreak, forKey: maxStreakKey)
        }
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
    }

    public var totalDailyCompleted: Int {
        history.values.filter { $0.isCompleted }.count
    }

    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save daily history: \(error)")
        }
    }

    private static func loadHistory(key: String) -> [String: DailyChallengeRecord] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return [:]
        }
        do {
            return try JSONDecoder().decode([String: DailyChallengeRecord].self, from: data)
        } catch {
            return [:]
        }
    }
}
