//
//  VerticalSymmetryRule.swift
//  Echo Grid
//

import Foundation

public struct VerticalSymmetryRule: RuleEvaluator, Sendable {
    public let id: String
    public let weight: Double

    public init(weight: Double = 1.0) {
        self.id = "rule.vertical_symmetry"
        self.weight = weight
    }

    public func evaluate(board: BoardState) -> RuleEvaluation {
        let sources = board.sourceNodes
        let movables = board.movableNodes

        guard !sources.isEmpty else {
            return RuleEvaluation(ruleId: id, score: 1.0, isSatisfied: true, detailNotes: "No source nodes")
        }

        // Expected mirrored target positions for each source node
        let targetPositions = sources.map { $0.position.verticallyMirrored(boardWidth: board.size) }

        // Maximum possible Manhattan distance across a 5x5 grid is (5-1) + (5-1) = 8
        let maxDistance: Double = Double((board.size - 1) * 2)

        // Find optimal assignment of movable nodes to target positions
        // For 3 nodes, evaluate best matching permutations
        var totalScoreSum: Double = 0.0
        var matchedCount = 0

        var remainingTargets = targetPositions
        for movable in movables {
            guard !remainingTargets.isEmpty else { break }

            // Find closest target
            var minDistance = Int.max
            var bestTargetIndex = 0

            for (index, target) in remainingTargets.enumerated() {
                let dist = movable.position.manhattanDistance(to: target)
                if dist < minDistance {
                    minDistance = dist
                    bestTargetIndex = index
                }
            }

            if minDistance == 0 {
                matchedCount += 1
                totalScoreSum += 1.0
            } else {
                let proximity = max(0.0, 1.0 - (Double(minDistance) / maxDistance))
                totalScoreSum += proximity
            }

            remainingTargets.remove(at: bestTargetIndex)
        }

        let normalizedScore = totalScoreSum / Double(sources.count)
        let isSolved = (matchedCount == sources.count)

        return RuleEvaluation(
            ruleId: id,
            score: isSolved ? 1.0 : normalizedScore,
            isSatisfied: isSolved,
            detailNotes: "\(matchedCount)/\(sources.count) nodes symmetrically aligned"
        )
    }
}
