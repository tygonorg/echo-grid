//
//  CellPosition.swift
//  Echo Grid
//

import Foundation

public struct CellPosition: Hashable, Codable, Sendable {
    public let row: Int
    public let col: Int

    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }

    /// Manhattan distance between two cells
    public func manhattanDistance(to other: CellPosition) -> Int {
        abs(row - other.row) + abs(col - other.col)
    }

    /// Euclidean distance between two cells
    public func euclideanDistance(to other: CellPosition) -> Double {
        let dr = Double(row - other.row)
        let dc = Double(col - other.col)
        return sqrt(dr * dr + dc * dc)
    }

    /// Calculates mirror position across vertical axis for a given board width
    public func verticallyMirrored(boardWidth: Int = 5) -> CellPosition {
        CellPosition(row: row, col: (boardWidth - 1) - col)
    }

    public var isCenterColumn: Bool {
        col == 2
    }
}
