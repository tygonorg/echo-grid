//
//  EquidistantSpacingRule.swift
//  Echo Grid
//

import Foundation

public struct EquidistantSpacingRule: RuleEvaluator, Sendable {
    public let id: String
    public let weight: Double

    public init(weight: Double = 1.0) {
        self.id = "rule.equidistant_spacing"
        self.weight = weight
    }

    public func evaluate(board: BoardState) -> RuleEvaluation {
        let nodes = board.movableNodes
        guard nodes.count >= 3 else {
            return RuleEvaluation(ruleId: id, score: 1.0, isSatisfied: true, detailNotes: "Trivially spaced")
        }

        // Sort by row, then by col
        let sorted = nodes.map { $0.position }.sorted {
            if $0.row == $1.row { return $0.col < $1.col }
            return $0.row < $1.row
        }

        // Calculate distances between consecutive pairs
        var distances: [Int] = []
        for i in 0..<(sorted.count - 1) {
            distances.append(sorted[i].manhattanDistance(to: sorted[i + 1]))
        }

        guard !distances.isEmpty else {
            return RuleEvaluation(ruleId: id, score: 1.0, isSatisfied: true)
        }

        let firstDist = distances[0]
        let matchCount = distances.filter { $0 == firstDist && $0 > 0 }.count
        let score = Double(matchCount) / Double(distances.count)
        let isSolved = score >= 0.999

        return RuleEvaluation(
            ruleId: id,
            score: isSolved ? 1.0 : score,
            isSatisfied: isSolved,
            detailNotes: "Spacing consistency: \(Int(score * 100))%"
        )
    }
}
