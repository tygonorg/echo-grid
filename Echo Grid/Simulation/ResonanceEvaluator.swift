//
//  ResonanceEvaluator.swift
//  Echo Grid
//

import Foundation

public struct GlobalEvaluationResult: Sendable {
    public let resonanceScore: Double
    public let isSolved: Bool
    public let ruleEvaluations: [RuleEvaluation]

    public init(resonanceScore: Double, isSolved: Bool, ruleEvaluations: [RuleEvaluation]) {
        self.resonanceScore = resonanceScore
        self.isSolved = isSolved
        self.ruleEvaluations = ruleEvaluations
    }
}

public struct ResonanceEvaluator: Sendable {
    private let evaluators: [any RuleEvaluator]

    public init(evaluators: [any RuleEvaluator] = [VerticalSymmetryRule()]) {
        self.evaluators = evaluators
    }

    public func evaluate(board: BoardState) -> GlobalEvaluationResult {
        guard !evaluators.isEmpty else {
            return GlobalEvaluationResult(resonanceScore: 1.0, isSolved: true, ruleEvaluations: [])
        }

        var totalWeightedScore = 0.0
        var totalWeight = 0.0
        var allRulesSatisfied = true
        var results: [RuleEvaluation] = []

        for evaluator in evaluators {
            let result = evaluator.evaluate(board: board)
            results.append(result)
            totalWeightedScore += result.score * evaluator.weight
            totalWeight += evaluator.weight
            if !result.isSatisfied {
                allRulesSatisfied = false
            }
        }

        let finalScore = totalWeight > 0 ? (totalWeightedScore / totalWeight) : 0.0
        let isSolved = allRulesSatisfied || finalScore >= 0.999

        return GlobalEvaluationResult(
            resonanceScore: isSolved ? 1.0 : finalScore,
            isSolved: isSolved,
            ruleEvaluations: results
        )
    }
}
