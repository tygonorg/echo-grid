//
//  HintEngine.swift
//  Echo Grid
//

import Foundation

public struct HintResult: Sendable {
    public let message: String
    public let suggestedNodeId: String?
    public let focusAxis: String? // "col:2", "row:2", etc.

    public init(message: String, suggestedNodeId: String? = nil, focusAxis: String? = nil) {
        self.message = message
        self.suggestedNodeId = suggestedNodeId
        self.focusAxis = focusAxis
    }
}

public struct HintEngine: Sendable {
    public static let shared = HintEngine()

    public init() {}

    /// Analyzes the board against the active rules to offer a helpful, non-spoiling hint
    public func generateHint(for board: BoardState, rules: [any RuleEvaluator]) -> HintResult {
        let movables = board.movableNodes
        guard !movables.isEmpty else {
            return HintResult(message: "All nodes are aligned.")
        }

        // Check if there is a vertical symmetry rule
        if rules.contains(where: { $0.id == "rule.vertical_symmetry" }) {
            let sources = board.sourceNodes
            let targets = sources.map { $0.position.verticallyMirrored(boardWidth: board.size) }

            // Find movable node with highest distance to any unmatched target
            var worstMovableId = movables.first?.id
            var maxDistance = -1

            for movable in movables {
                let distToClosestTarget = targets.map { movable.position.manhattanDistance(to: $0) }.min() ?? 0
                if distToClosestTarget > maxDistance {
                    maxDistance = distToClosestTarget
                    worstMovableId = movable.id
                }
            }

            if maxDistance > 0 {
                return HintResult(
                    message: "Focus on the node furthest from the central vertical reflection.",
                    suggestedNodeId: worstMovableId,
                    focusAxis: "col:2"
                )
            }
        }

        // Check if there is a horizontal symmetry rule
        if rules.contains(where: { $0.id == "rule.horizontal_symmetry" }) {
            return HintResult(
                message: "Observe the balance between the upper and lower halves of the grid.",
                focusAxis: "row:2"
            )
        }

        // Check if collinear alignment rule
        if rules.contains(where: { $0.id == "rule.collinear_alignment" }) {
            return HintResult(
                message: "Align all movable resonance points onto a single row, column, or diagonal line."
            )
        }

        return HintResult(message: "Listen closely to the haptic resonance as you drag each point.")
    }
}
