//
//  BoardState.swift
//  Echo Grid
//

import Foundation

public struct BoardState: Hashable, Codable, Sendable {
    public let size: Int
    public var nodes: [NodeState]

    public init(size: Int = 5, nodes: [NodeState] = []) {
        self.size = size
        self.nodes = nodes
    }

    /// Checks if a position is within the bounds of the grid
    public func isValidPosition(_ position: CellPosition) -> Bool {
        position.row >= 0 && position.row < size && position.col >= 0 && position.col < size
    }

    /// Finds node located at a specific grid cell
    public func node(at position: CellPosition) -> NodeState? {
        nodes.first(where: { $0.position == position })
    }

    /// Checks if a cell is currently occupied by any node (source, receiver, or blocker)
    public func isOccupied(at position: CellPosition) -> Bool {
        nodes.contains(where: { $0.position == position })
    }

    /// Returns all source (fixed anchor) nodes
    public var sourceNodes: [NodeState] {
        nodes.filter { $0.type == .source }
    }

    /// Returns all movable (receiver) nodes
    public var movableNodes: [NodeState] {
        nodes.filter { $0.type == .receiver }
    }

    /// Returns all blocker (obstacle) nodes
    public var blockerNodes: [NodeState] {
        nodes.filter { $0.type == .blocker }
    }

    /// Factory for the Phase 0 standard validation layout
    public static func makePhase0ValidationOpening() -> BoardState {
        let sources = [
            NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 0), isLocked: true),
            NodeState(id: "S2", type: .source, position: CellPosition(row: 2, col: 1), isLocked: true),
            NodeState(id: "S3", type: .source, position: CellPosition(row: 4, col: 0), isLocked: true)
        ]
        let movables = [
            NodeState(id: "M1", type: .receiver, position: CellPosition(row: 1, col: 3), isLocked: false),
            NodeState(id: "M2", type: .receiver, position: CellPosition(row: 3, col: 4), isLocked: false),
            NodeState(id: "M3", type: .receiver, position: CellPosition(row: 4, col: 2), isLocked: false)
        ]
        return BoardState(size: 5, nodes: sources + movables)
    }
}
