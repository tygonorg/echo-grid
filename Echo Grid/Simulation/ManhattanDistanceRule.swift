//
//  ManhattanDistanceRule.swift
//  Echo Grid
//

import Foundation

public struct ManhattanDistanceRule: RuleEvaluator, Sendable {
    public let id: String
    public let weight: Double
    public let targetDistance: Int

    public init(targetDistance: Int = 2, weight: Double = 1.0) {
        self.id = "rule.manhattan_distance_\(targetDistance)"
        self.weight = weight
        self.targetDistance = targetDistance
    }

    public func evaluate(board: BoardState) -> RuleEvaluation {
        let sources = board.sourceNodes
        let movables = board.movableNodes

        guard !sources.isEmpty, !movables.isEmpty else {
            return RuleEvaluation(ruleId: id, score: 1.0, isSatisfied: true, detailNotes: "Trivially satisfied")
        }

        var matchedCount = 0
        var totalProximity = 0.0
        let maxDelta = Double((board.size - 1) * 2)

        for movable in movables {
            // Find distance to closest source
            var minDistanceToSource = Int.max
            for source in sources {
                let dist = movable.position.manhattanDistance(to: source.position)
                if dist < minDistanceToSource {
                    minDistanceToSource = dist
                }
            }

            let delta = abs(minDistanceToSource - targetDistance)
            if delta == 0 {
                matchedCount += 1
                totalProximity += 1.0
            } else {
                let prox = max(0.0, 1.0 - (Double(delta) / maxDelta))
                totalProximity += prox
            }
        }

        let normalizedScore = totalProximity / Double(movables.count)
        let isSolved = (matchedCount == movables.count)

        return RuleEvaluation(
            ruleId: id,
            score: isSolved ? 1.0 : normalizedScore,
            isSatisfied: isSolved,
            detailNotes: "\(matchedCount)/\(movables.count) nodes at harmonic distance \(targetDistance)"
        )
    }
}
