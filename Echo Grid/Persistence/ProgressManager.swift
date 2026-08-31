//
//  ProgressManager.swift
//  Echo Grid
//

import Foundation
import SwiftUI
import Combine

@MainActor
public final class ProgressManager: ObservableObject {
    public static let shared = ProgressManager()

    private let progressStorageKey = "echo_grid_level_progress_v1"
    private let settingsStorageKey = "echo_grid_user_settings_v1"
    private let onboardingKey = "echo_grid_has_completed_onboarding_v1"

    @Published public private(set) var progressMap: [Int: LevelProgressRecord] = [:]
    @Published public var settings: UserSettingsRecord
    @Published public var hasCompletedOnboarding: Bool

    private init() {
        self.settings = Self.loadSettings(key: settingsStorageKey)
        self.progressMap = Self.loadProgress(key: progressStorageKey)
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
        ensureFirstLevelUnlocked()
        applyHapticSettings()
    }

    private func ensureFirstLevelUnlocked() {
        if progressMap[1] == nil {
            progressMap[1] = LevelProgressRecord(levelId: 1, isUnlocked: true)
            saveProgress()
        }
    }

    public func completeOnboarding() {
        self.hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    public func progress(for levelId: Int) -> LevelProgressRecord {
        if let record = progressMap[levelId] {
            return record
        }
        let isUnlocked = (levelId == 1)
        let newRecord = LevelProgressRecord(levelId: levelId, isUnlocked: isUnlocked)
        progressMap[levelId] = newRecord
        return newRecord
    }

    public func recordLevelClear(
        levelId: Int,
        moves: Int,
        timeSec: Double,
        parMoves: Int
    ) -> (stars: Int, isNewBest: Bool) {
        var record = progress(for: levelId)

        // Calculate Stars
        let stars: Int
        if moves <= parMoves {
            stars = 3
        } else if moves <= parMoves + 2 {
            stars = 2
        } else {
            stars = 1
        }

        var isNewBest = false
        if !record.isCompleted || moves < record.bestMoves || record.bestMoves == 0 {
            record.bestMoves = moves
            isNewBest = true
        }

        if record.bestTimeSec == 0 || timeSec < record.bestTimeSec {
            record.bestTimeSec = timeSec
        }

        record.starsEarned = max(record.starsEarned, stars)
        record.isCompleted = true
        record.lastPlayedAt = Date()
        progressMap[levelId] = record

        // Unlock next level (up to level 15)
        let nextLevelId = levelId + 1
        if nextLevelId <= 15 {
            var nextRecord = progress(for: nextLevelId)
            nextRecord.isUnlocked = true
            progressMap[nextLevelId] = nextRecord
        }

        saveProgress()
        return (stars: stars, isNewBest: isNewBest)
    }

    public var totalStarsEarned: Int {
        progressMap.values.reduce(0) { $0 + $1.starsEarned }
    }

    public var completedLevelsCount: Int {
        progressMap.values.filter { $0.isCompleted }.count
    }

    public var highestUnlockedLevelId: Int {
        progressMap.values.filter { $0.isUnlocked }.map { $0.levelId }.max() ?? 1
    }

    public func updateHapticScale(_ scale: Float) {
        settings.hapticScale = min(max(scale, 0.5), 1.5)
        applyHapticSettings()
        saveSettings()
    }

    public func updateSettings(_ newSettings: UserSettingsRecord) {
        self.settings = newSettings
        applyHapticSettings()
        saveSettings()
    }

    private func applyHapticSettings() {
        HapticFeedbackOrchestrator.shared.hapticScale = settings.hapticsEnabled ? settings.hapticScale : 0.0
    }

    public func resetAllProgress() {
        progressMap.removeAll()
        progressMap[1] = LevelProgressRecord(levelId: 1, isUnlocked: true)
        saveProgress()
    }

    // MARK: - Persistence Helpers

    private func saveProgress() {
        do {
            let data = try JSONEncoder().encode(progressMap)
            UserDefaults.standard.set(data, forKey: progressStorageKey)
        } catch {
            print("Failed to save level progress: \(error)")
        }
    }

    private static func loadProgress(key: String) -> [Int: LevelProgressRecord] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return [1: LevelProgressRecord(levelId: 1, isUnlocked: true)]
        }
        do {
            return try JSONDecoder().decode([Int: LevelProgressRecord].self, from: data)
        } catch {
            return [1: LevelProgressRecord(levelId: 1, isUnlocked: true)]
        }
    }

    private func saveSettings() {
        do {
            let data = try JSONEncoder().encode(settings)
            UserDefaults.standard.set(data, forKey: settingsStorageKey)
        } catch {
            print("Failed to save user settings: \(error)")
        }
    }

    private static func loadSettings(key: String) -> UserSettingsRecord {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return UserSettingsRecord()
        }
        do {
            return try JSONDecoder().decode(UserSettingsRecord.self, from: data)
        } catch {
            return UserSettingsRecord()
        }
    }
}
