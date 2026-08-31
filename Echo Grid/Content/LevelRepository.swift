//
//  LevelRepository.swift
//  Echo Grid
//

import Foundation

public struct LevelRepository: Sendable {
    public static let shared = LevelRepository()

    public let allLevels: [LevelDefinition]

    public init() {
        self.allLevels = Self.buildCuratedLevels()
    }

    public func level(byId id: Int) -> LevelDefinition? {
        allLevels.first(where: { $0.id == id })
    }

    public func levels(forChapter chapter: Int) -> [LevelDefinition] {
        allLevels.filter { $0.chapter == chapter }
    }

    private static func buildCuratedLevels() -> [LevelDefinition] {
        var levels: [LevelDefinition] = []

        // ==========================================
        // CHAPTER 1: THE MIRROR (Levels 1 - 5)
        // ==========================================
        let ch1 = "Chapter 1: The Mirror"

        // Level 1: First Echo
        levels.append(LevelDefinition(
            id: 1,
            chapter: 1,
            chapterTitle: ch1,
            title: "First Echo",
            subtitle: "Discover the mirror axis",
            parMoves: 2,
            parTimeSec: 30.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "S1", type: .source, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 2, col: 2))
            ]),
            ruleEvaluators: [VerticalSymmetryRule()]
        ))

        // Level 2: Dual Reflections
        levels.append(LevelDefinition(
            id: 2,
            chapter: 1,
            chapterTitle: ch1,
            title: "Dual Reflections",
            subtitle: "Two points in harmony",
            parMoves: 3,
            parTimeSec: 45.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "S1", type: .source, position: CellPosition(row: 1, col: 0)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 3, col: 1)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 3)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 4, col: 3))
            ]),
            ruleEvaluators: [VerticalSymmetryRule()]
        ))

        // Level 3: Crossed Horizons
        levels.append(LevelDefinition(
            id: 3,
            chapter: 1,
            chapterTitle: ch1,
            title: "Crossed Horizons",
            subtitle: "Horizontal balance across the plane",
            parMoves: 4,
            parTimeSec: 50.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 1)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 1, col: 3)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 3, col: 2)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 2, col: 4))
            ]),
            ruleEvaluators: [HorizontalSymmetryRule()]
        ))

        // Level 4: Tricolor Mirror
        levels.append(LevelDefinition(
            id: 4,
            chapter: 1,
            chapterTitle: ch1,
            title: "Tricolor Mirror",
            subtitle: "Three anchors of vertical reflection",
            parMoves: 6,
            parTimeSec: 60.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 0)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 2, col: 1)),
                NodeState(id: "S3", type: .source, position: CellPosition(row: 4, col: 0)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 3)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 3, col: 4)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 4, col: 2))
            ]),
            ruleEvaluators: [VerticalSymmetryRule()]
        ))

        // Level 5: The Central Void
        levels.append(LevelDefinition(
            id: 5,
            chapter: 1,
            chapterTitle: ch1,
            title: "The Central Void",
            subtitle: "Balance above and below",
            parMoves: 5,
            parTimeSec: 60.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 2)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 1, col: 0)),
                NodeState(id: "S3", type: .source, position: CellPosition(row: 1, col: 4)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 3, col: 1)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 4, col: 3)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 2, col: 3))
            ]),
            ruleEvaluators: [HorizontalSymmetryRule()]
        ))

        // ==========================================
        // CHAPTER 2: HARMONICS & ALIGNMENT (Levels 6 - 10)
        // ==========================================
        let ch2 = "Chapter 2: Harmonics & Alignment"

        // Level 6: The Straight Path
        levels.append(LevelDefinition(
            id: 6,
            chapter: 2,
            chapterTitle: ch2,
            title: "The Straight Path",
            subtitle: "Unite all points in a single line",
            parMoves: 3,
            parTimeSec: 40.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 2)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 2, col: 1)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 4, col: 3))
            ]),
            ruleEvaluators: [CollinearAlignmentRule()]
        ))

        // Level 7: Diagonal Ray
        levels.append(LevelDefinition(
            id: 7,
            chapter: 2,
            chapterTitle: ch2,
            title: "Diagonal Ray",
            subtitle: "Cast a resonance beam corner to corner",
            parMoves: 4,
            parTimeSec: 50.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 1)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 2, col: 4)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 3, col: 0))
            ]),
            ruleEvaluators: [CollinearAlignmentRule()]
        ))

        // Level 8: The Blocked Axis
        levels.append(LevelDefinition(
            id: 8,
            chapter: 2,
            chapterTitle: ch2,
            title: "The Blocked Axis",
            subtitle: "Navigate around immovable barrier",
            parMoves: 4,
            parTimeSec: 50.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "B1", type: .blocker, position: CellPosition(row: 2, col: 2)),
                NodeState(id: "S1", type: .source, position: CellPosition(row: 1, col: 0)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 3, col: 0)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 3)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 4, col: 3))
            ]),
            ruleEvaluators: [VerticalSymmetryRule()]
        ))

        // Level 9: Even Harmonics
        levels.append(LevelDefinition(
            id: 9,
            chapter: 2,
            chapterTitle: ch2,
            title: "Even Harmonics",
            subtitle: "Equally spaced intervals",
            parMoves: 4,
            parTimeSec: 50.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 2, col: 1)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 2, col: 4))
            ]),
            ruleEvaluators: [EquidistantSpacingRule()]
        ))

        // Level 10: Maze of Resonance
        levels.append(LevelDefinition(
            id: 10,
            chapter: 2,
            chapterTitle: ch2,
            title: "Maze of Resonance",
            subtitle: "Overcome multiple obstacles",
            parMoves: 5,
            parTimeSec: 60.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "B1", type: .blocker, position: CellPosition(row: 1, col: 2)),
                NodeState(id: "B2", type: .blocker, position: CellPosition(row: 3, col: 2)),
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 1)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 0, col: 3)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 4, col: 4))
            ]),
            ruleEvaluators: [HorizontalSymmetryRule()]
        ))

        // ==========================================
        // CHAPTER 3: RESONANCE SYNTHESIS (Levels 11 - 15)
        // ==========================================
        let ch3 = "Chapter 3: Resonance Synthesis"

        // Level 11: Symmetry in Alignment
        levels.append(LevelDefinition(
            id: 11,
            chapter: 3,
            chapterTitle: ch3,
            title: "Symmetry in Alignment",
            subtitle: "Dual rule: Straight line and reflection",
            parMoves: 5,
            parTimeSec: 60.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "S1", type: .source, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 2)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 4, col: 2))
            ]),
            ruleEvaluators: [VerticalSymmetryRule(), CollinearAlignmentRule()]
        ))

        // Level 12: The Grid Matrix
        levels.append(LevelDefinition(
            id: 12,
            chapter: 3,
            chapterTitle: ch3,
            title: "The Grid Matrix",
            subtitle: "Coordinate 4 movable resonance points",
            parMoves: 6,
            parTimeSec: 70.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "B1", type: .blocker, position: CellPosition(row: 0, col: 0)),
                NodeState(id: "B2", type: .blocker, position: CellPosition(row: 4, col: 4)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 2)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 2, col: 4)),
                NodeState(id: "M4", type: .receiver, position: CellPosition(row: 3, col: 2))
            ]),
            ruleEvaluators: [VerticalSymmetryRule(), HorizontalSymmetryRule()]
        ))

        // Level 13: Echo Chamber
        levels.append(LevelDefinition(
            id: 13,
            chapter: 3,
            chapterTitle: ch3,
            title: "Echo Chamber",
            subtitle: "3-point symmetric lock around defenses",
            parMoves: 6,
            parTimeSec: 75.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "B1", type: .blocker, position: CellPosition(row: 2, col: 1)),
                NodeState(id: "B2", type: .blocker, position: CellPosition(row: 2, col: 3)),
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 1)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 4, col: 1)),
                NodeState(id: "S3", type: .source, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 4)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 3, col: 4)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 4, col: 3))
            ]),
            ruleEvaluators: [VerticalSymmetryRule()]
        ))

        // Level 14: The Harmonic Cross
        levels.append(LevelDefinition(
            id: 14,
            chapter: 3,
            chapterTitle: ch3,
            title: "The Harmonic Cross",
            subtitle: "Full quadrant resonance",
            parMoves: 7,
            parTimeSec: 85.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "B1", type: .blocker, position: CellPosition(row: 2, col: 2)),
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 2)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 2, col: 0)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 4)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 3, col: 2)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 4, col: 1)),
                NodeState(id: "M4", type: .receiver, position: CellPosition(row: 0, col: 4))
            ]),
            ruleEvaluators: [VerticalSymmetryRule(), HorizontalSymmetryRule()]
        ))

        // Level 15: Zenith of Resonance
        levels.append(LevelDefinition(
            id: 15,
            chapter: 3,
            chapterTitle: ch3,
            title: "Zenith of Resonance",
            subtitle: "Master the symphony of tactile deduction",
            parMoves: 8,
            parTimeSec: 90.0,
            initialBoard: BoardState(size: 5, nodes: [
                NodeState(id: "B1", type: .blocker, position: CellPosition(row: 0, col: 4)),
                NodeState(id: "B2", type: .blocker, position: CellPosition(row: 4, col: 0)),
                NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 0)),
                NodeState(id: "S2", type: .source, position: CellPosition(row: 2, col: 1)),
                NodeState(id: "S3", type: .source, position: CellPosition(row: 4, col: 4)),
                NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 3)),
                NodeState(id: "M2", type: .receiver, position: CellPosition(row: 3, col: 3)),
                NodeState(id: "M3", type: .receiver, position: CellPosition(row: 2, col: 4))
            ]),
            ruleEvaluators: [VerticalSymmetryRule(), CollinearAlignmentRule()]
        ))

        return levels
    }
}
