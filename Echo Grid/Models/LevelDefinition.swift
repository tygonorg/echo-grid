//
//  LevelDefinition.swift
//  Echo Grid
//

import Foundation

public struct LevelDefinition: Identifiable, Sendable {
    public let id: Int
    public let chapter: Int
    public let chapterTitle: String
    public let title: String
    public let subtitle: String
    public let parMoves: Int
    public let parTimeSec: Double
    public let initialBoard: BoardState
    public let ruleEvaluators: [any RuleEvaluator]

    public init(
        id: Int,
        chapter: Int,
        chapterTitle: String,
        title: String,
        subtitle: String,
        parMoves: Int,
        parTimeSec: Double,
        initialBoard: BoardState,
        ruleEvaluators: [any RuleEvaluator]
    ) {
        self.id = id
        self.chapter = chapter
        self.chapterTitle = chapterTitle
        self.title = title
        self.subtitle = subtitle
        self.parMoves = parMoves
        self.parTimeSec = parTimeSec
        self.initialBoard = initialBoard
        self.ruleEvaluators = ruleEvaluators
    }
}
