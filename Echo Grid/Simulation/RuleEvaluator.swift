//
//  RuleEvaluator.swift
//  Echo Grid
//

import Foundation

public struct RuleEvaluation: Sendable {
    public let ruleId: String
    public let score: Double         // 0.0 to 1.0
    public let isSatisfied: Bool     // true if score >= 0.999
    public let detailNotes: String

    public init(ruleId: String, score: Double, isSatisfied: Bool, detailNotes: String = "") {
        self.ruleId = ruleId
        self.score = min(max(score, 0.0), 1.0)
        self.isSatisfied = isSatisfied
        self.detailNotes = detailNotes
    }
}

public protocol RuleEvaluator: Sendable {
    var id: String { get }
    var weight: Double { get }
    func evaluate(board: BoardState) -> RuleEvaluation
}
