//
//  CollinearAlignmentRule.swift
//  Echo Grid
//

import Foundation

public struct CollinearAlignmentRule: RuleEvaluator, Sendable {
    public let id: String
    public let weight: Double

    public init(weight: Double = 1.0) {
        self.id = "rule.collinear_alignment"
        self.weight = weight
    }

    public func evaluate(board: BoardState) -> RuleEvaluation {
        let activeNodes = board.movableNodes
        guard activeNodes.count >= 2 else {
            return RuleEvaluation(ruleId: id, score: 1.0, isSatisfied: true, detailNotes: "Trivially aligned")
        }

        let positions = activeNodes.map { $0.position }
        let count = Double(positions.count)

        // Check Row Alignment
        let rows = positions.map { $0.row }
        let mostFrequentRowCount = rows.reduce(into: [:]) { counts, r in counts[r, default: 0] += 1 }.values.max() ?? 0
        let rowScore = Double(mostFrequentRowCount) / count

        // Check Column Alignment
        let cols = positions.map { $0.col }
        let mostFrequentColCount = cols.reduce(into: [:]) { counts, c in counts[c, default: 0] += 1 }.values.max() ?? 0
        let colScore = Double(mostFrequentColCount) / count

        // Check Main Diagonal (row == col)
        let mainDiagMatches = positions.filter { $0.row == $0.col }.count
        let mainDiagScore = Double(mainDiagMatches) / count

        // Check Anti Diagonal (row + col == board.size - 1)
        let antiDiagMatches = positions.filter { $0.row + $0.col == (board.size - 1) }.count
        let antiDiagScore = Double(antiDiagMatches) / count

        let bestScore = max(rowScore, colScore, mainDiagScore, antiDiagScore)
        let isSolved = bestScore >= 0.999

        return RuleEvaluation(
            ruleId: id,
            score: isSolved ? 1.0 : bestScore,
            isSatisfied: isSolved,
            detailNotes: "Best alignment score: \(Int(bestScore * 100))%"
        )
    }
}
