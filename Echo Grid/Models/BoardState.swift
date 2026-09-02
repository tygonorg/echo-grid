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
}
