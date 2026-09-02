//
//  RotationalSymmetryRule.swift
//  Echo Grid
//

import Foundation

public struct RotationalSymmetryRule: RuleEvaluator, Sendable {
    public let id: String
    public let weight: Double

    public init(weight: Double = 1.0) {
        self.id = "rule.rotational_symmetry"
        self.weight = weight
    }

    public func evaluate(board: BoardState) -> RuleEvaluation {
        let sources = board.sourceNodes
        let movables = board.movableNodes

        guard !sources.isEmpty else {
            return RuleEvaluation(ruleId: id, score: 1.0, isSatisfied: true, detailNotes: "No source nodes")
        }

        // Expected 180-degree rotational target positions: (r, c) -> (4 - r, 4 - c)
        let targetPositions = sources.map {
            CellPosition(row: (board.size - 1) - $0.position.row, col: (board.size - 1) - $0.position.col)
        }

        let maxDistance: Double = Double((board.size - 1) * 2)

        var totalScoreSum: Double = 0.0
        var matchedCount = 0
        var remainingMovables = movables

        for target in targetPositions {
            guard !remainingMovables.isEmpty else { break }

            var minDistance = Int.max
            var bestMovableIndex = 0

            for (index, movable) in remainingMovables.enumerated() {
                let dist = movable.position.manhattanDistance(to: target)
                if dist < minDistance {
                    minDistance = dist
                    bestMovableIndex = index
                }
            }

            if minDistance == 0 {
                matchedCount += 1
                totalScoreSum += 1.0
            } else {
                let proximity = max(0.0, 1.0 - (Double(minDistance) / maxDistance))
                totalScoreSum += proximity
            }

            remainingMovables.remove(at: bestMovableIndex)
        }

        let normalizedScore = totalScoreSum / Double(sources.count)
        let isSolved = (matchedCount == sources.count)

        return RuleEvaluation(
            ruleId: id,
            score: isSolved ? 1.0 : normalizedScore,
            isSatisfied: isSolved,
            detailNotes: "\(matchedCount)/\(sources.count) nodes rotationally balanced"
        )
    }
}
