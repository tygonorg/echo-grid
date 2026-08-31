//
//  DailyChallengeRecord.swift
//  Echo Grid
//

import Foundation

public struct DailyChallengeRecord: Identifiable, Codable, Hashable, Sendable {
    public var id: String { dateKey }
    public let dateKey: String        // "YYYY-MM-DD"
    public var isCompleted: Bool
    public var movesCount: Int
    public var timeElapsedSec: Double
    public var stars: Int
    public var completedAt: Date?

    public init(
        dateKey: String,
        isCompleted: Bool = false,
        movesCount: Int = 0,
        timeElapsedSec: Double = 0.0,
        stars: Int = 0,
        completedAt: Date? = nil
    ) {
        self.dateKey = dateKey
        self.isCompleted = isCompleted
        self.movesCount = movesCount
        self.timeElapsedSec = timeElapsedSec
        self.stars = stars
        self.completedAt = completedAt
    }
}
