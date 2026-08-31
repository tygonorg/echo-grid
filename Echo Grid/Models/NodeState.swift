//
//  NodeState.swift
//  Echo Grid
//

import Foundation

public enum NodeType: String, Codable, Sendable {
    case source    // Fixed anchor node
    case receiver  // Draggable / movable node
    case blocker   // Fixed impassable obstacle
}

public struct NodeState: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let type: NodeType
    public var position: CellPosition
    public var isLocked: Bool

    public init(
        id: String = UUID().uuidString,
        type: NodeType = .receiver,
        position: CellPosition,
        isLocked: Bool = false
    ) {
        self.id = id
        self.type = type
        self.position = position
        self.isLocked = (type == .source || type == .blocker) ? true : isLocked
    }
}
