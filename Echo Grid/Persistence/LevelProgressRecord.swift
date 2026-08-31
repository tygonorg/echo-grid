//
//  LevelProgressRecord.swift
//  Echo Grid
//

import Foundation

public struct LevelProgressRecord: Identifiable, Codable, Hashable, Sendable {
    public var id: Int { levelId }
    public let levelId: Int
    public var isUnlocked: Bool
    public var isCompleted: Bool
    public var bestMoves: Int
    public var bestTimeSec: Double
    public var starsEarned: Int
    public var lastPlayedAt: Date?

    public init(
        levelId: Int,
        isUnlocked: Bool = false,
        isCompleted: Bool = false,
        bestMoves: Int = 0,
        bestTimeSec: Double = 0.0,
        starsEarned: Int = 0,
        lastPlayedAt: Date? = nil
    ) {
        self.levelId = levelId
        self.isUnlocked = isUnlocked
        self.isCompleted = isCompleted
        self.bestMoves = bestMoves
        self.bestTimeSec = bestTimeSec
        self.starsEarned = starsEarned
        self.lastPlayedAt = lastPlayedAt
    }
}
