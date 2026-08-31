//
//  LevelGenerator.swift
//  Echo Grid
//

import Foundation

public struct SeededRandomGenerator: Sendable {
    private var state: UInt64

    public init(seed: UInt64) {
        self.state = seed != 0 ? seed : 0x853c49e6748fea9b
    }

    public mutating func nextUInt64() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }

    public mutating func nextInt(in range: ClosedRange<Int>) -> Int {
        let span = UInt64(range.upperBound - range.lowerBound + 1)
        let randVal = nextUInt64() % span
        return range.lowerBound + Int(randVal)
    }
}

public struct LevelGenerator: Sendable {
    public static let shared = LevelGenerator()

    public init() {}

    /// Generates a deterministic LevelDefinition from a date string (e.g. "2026-08-31") or custom integer seed
    public func generateDailyPuzzle(for dateString: String) -> LevelDefinition {
        let seedValue = hashStringToUInt64(dateString)
        return generateLevel(seed: seedValue, title: "Daily Echo (\(dateString))", id: 9999)
    }

    public func generateLevel(seed: UInt64, title: String, id: Int = 9999) -> LevelDefinition {
        var rng = SeededRandomGenerator(seed: seed)

        // Select Rule Family based on seed: 0 = Vertical, 1 = Horizontal, 2 = Collinear, 3 = Vertical + Collinear
        let ruleChoice = rng.nextInt(in: 0...3)
        let gridSize = 5

        var sources: [NodeState] = []
        var movables: [NodeState] = []
        var blockers: [NodeState] = []
        var rules: [any RuleEvaluator] = []
        var parMoves: Int = 5
        var subtitle: String = "Align the harmonic resonance"

        switch ruleChoice {
        case 0:
            // Vertical Symmetry
            rules = [VerticalSymmetryRule()]
            subtitle = "Restore reflection across the vertical axis"
            let sourceCount = rng.nextInt(in: 2...3)
            var usedRows = Set<Int>()

            for i in 0..<sourceCount {
                var row = rng.nextInt(in: 0...4)
                while usedRows.contains(row) {
                    row = (row + 1) % 5
                }
                usedRows.insert(row)
                let col = rng.nextInt(in: 0...1) // Left side of axis (col 0 or 1)
                sources.append(NodeState(id: "S\(i + 1)", type: .source, position: CellPosition(row: row, col: col)))
            }

            // Scramble movables
            for (i, _) in sources.enumerated() {
                var sRow = rng.nextInt(in: 0...4)
                var sCol = rng.nextInt(in: 0...4)
                while sources.contains(where: { $0.position.row == sRow && $0.position.col == sCol }) ||
                      movables.contains(where: { $0.position.row == sRow && $0.position.col == sCol }) {
                    sCol = (sCol + 1) % 5
                    if sCol == 0 { sRow = (sRow + 1) % 5 }
                }
                movables.append(NodeState(id: "M\(i + 1)", type: .receiver, position: CellPosition(row: sRow, col: sCol)))
            }
            parMoves = sourceCount * 2

        case 1:
            // Horizontal Symmetry
            rules = [HorizontalSymmetryRule()]
            subtitle = "Balance resonance across the horizon"
            let sourceCount = rng.nextInt(in: 2...3)
            var usedCols = Set<Int>()

            for i in 0..<sourceCount {
                var col = rng.nextInt(in: 0...4)
                while usedCols.contains(col) {
                    col = (col + 1) % 5
                }
                usedCols.insert(col)
                let row = rng.nextInt(in: 0...1) // Top side of axis (row 0 or 1)
                sources.append(NodeState(id: "S\(i + 1)", type: .source, position: CellPosition(row: row, col: col)))
            }

            // Scramble movables
            for (i, _) in sources.enumerated() {
                var sRow = rng.nextInt(in: 0...4)
                var sCol = rng.nextInt(in: 0...4)
                while sources.contains(where: { $0.position.row == sRow && $0.position.col == sCol }) ||
                      movables.contains(where: { $0.position.row == sRow && $0.position.col == sCol }) {
                    sCol = (sCol + 1) % 5
                    if sCol == 0 { sRow = (sRow + 1) % 5 }
                }
                movables.append(NodeState(id: "M\(i + 1)", type: .receiver, position: CellPosition(row: sRow, col: sCol)))
            }
            parMoves = sourceCount * 2

        case 2:
            // Collinear Alignment
            rules = [CollinearAlignmentRule()]
            subtitle = "Cast all points into a single beam of light"
            let nodeCount = 3
            for i in 0..<nodeCount {
                var r = (i * 2 + 1) % 5
                var c = (i * 2 + 3) % 5
                movables.append(NodeState(id: "M\(i + 1)", type: .receiver, position: CellPosition(row: r, col: c)))
            }
            parMoves = 4

        default:
            // Blocker + Symmetry
            rules = [VerticalSymmetryRule()]
            subtitle = "Navigate the harmonic obstacle"
            blockers.append(NodeState(id: "B1", type: .blocker, position: CellPosition(row: 2, col: 2)))

            sources.append(NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 1)))
            sources.append(NodeState(id: "S2", type: .source, position: CellPosition(row: 4, col: 0)))
            movables.append(NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 4)))
            movables.append(NodeState(id: "M2", type: .receiver, position: CellPosition(row: 3, col: 1)))
            parMoves = 5
        }

        let board = BoardState(size: gridSize, nodes: sources + movables + blockers)

        return LevelDefinition(
            id: id,
            chapter: 0,
            chapterTitle: "Daily Challenge",
            title: title,
            subtitle: subtitle,
            parMoves: parMoves,
            parTimeSec: 60.0,
            initialBoard: board,
            ruleEvaluators: rules
        )
    }

    private func hashStringToUInt64(_ string: String) -> UInt64 {
        var hash: UInt64 = 5381
        for byte in string.utf8 {
            hash = ((hash << 5) &+ hash) &+ UInt64(byte)
        }
        return hash
    }
}
