//
//  BoardGridView.swift
//  Echo Grid
//

import SwiftUI
import Combine

public struct BoardGridView: View {
    @ObservedObject var controller: GameplaySessionController
    private let gridSize: Int = 5

    public init(controller: GameplaySessionController) {
        self.controller = controller
    }

    public var body: some View {
        GeometryReader { geometry in
            let sideLength = min(geometry.size.width, geometry.size.height) - 32
            let cellSize = sideLength / CGFloat(gridSize)

            ZStack {
                // Background Board Card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(white: 0.12))
                    .frame(width: sideLength, height: sideLength)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(white: 0.22), lineWidth: 1.5)
                    )

                // Visual Enhancement: Vertical Symmetry Axis Glow (Full Sensory mode only)
                if controller.feedbackMode.hasVisualEnhancements {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.cyan.opacity(0.0),
                                    Color.cyan.opacity(0.12 + 0.2 * controller.latestResonanceScore),
                                    Color.cyan.opacity(0.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: cellSize * 0.35, height: sideLength - 16)
                        .position(x: sideLength / 2, y: sideLength / 2)
                        .blur(radius: 3)
                }

                // Grid Cells
                VStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize, id: \.self) { col in
                                CellBackgroundView(
                                    row: row,
                                    col: col,
                                    cellSize: cellSize,
                                    isCenterCol: col == 2,
                                    isFullSensory: controller.feedbackMode.hasVisualEnhancements
                                )
                            }
                        }
                    }
                }
                .frame(width: sideLength, height: sideLength)

                // Visual Enhancement: Symmetrical connection lines (Full Sensory mode only)
                if controller.feedbackMode.hasVisualEnhancements {
                    SymmetryLinesOverlay(
                        board: controller.board,
                        cellSize: cellSize,
                        resonanceScore: controller.latestResonanceScore
                    )
                    .frame(width: sideLength, height: sideLength)
                    .allowsHitTesting(false)
                }

                // Nodes with individual gesture handling
                ForEach(controller.board.nodes) { node in
                    DraggableNodeView(
                        node: node,
                        gridSize: gridSize,
                        cellSize: cellSize,
                        controller: controller
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .padding()
    }
}

// MARK: - Draggable Node Component

private struct DraggableNodeView: View {
    let node: NodeState
    let gridSize: Int
    let cellSize: CGFloat
    @ObservedObject var controller: GameplaySessionController

    @GestureState private var dragTranslation: CGSize = .zero

    var body: some View {
        let baseCenter = CGPoint(
            x: (CGFloat(node.position.col) + 0.5) * cellSize,
            y: (CGFloat(node.position.row) + 0.5) * cellSize
        )
        let isDragging = dragTranslation != .zero

        NodeItemView(
            node: node,
            cellSize: cellSize,
            isDragging: isDragging,
            isFullSensory: controller.feedbackMode.hasVisualEnhancements,
            resonanceScore: controller.latestResonanceScore
        )
        .position(x: baseCenter.x + dragTranslation.width, y: baseCenter.y + dragTranslation.height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityNodeLabel(for: node))
        .accessibilityHint(node.type == .receiver ? "Drag to move this resonance point" : "Fixed position")
        .gesture(
            node.isLocked ? nil : DragGesture()
                .updating($dragTranslation) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    let finalPosition = CGPoint(
                        x: baseCenter.x + value.translation.width,
                        y: baseCenter.y + value.translation.height
                    )
                    let targetCol = max(0, min(gridSize - 1, Int(finalPosition.x / cellSize)))
                    let targetRow = max(0, min(gridSize - 1, Int(finalPosition.y / cellSize)))
                    let targetCell = CellPosition(row: targetRow, col: targetCol)

                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        controller.moveNode(nodeId: node.id, to: targetCell)
                    }
                }
        )
    }

    private func accessibilityNodeLabel(for node: NodeState) -> String {
        switch node.type {
        case .source:
            return "Fixed Anchor Node at Row \(node.position.row + 1), Column \(node.position.col + 1)"
        case .blocker:
            return "Obstacle at Row \(node.position.row + 1), Column \(node.position.col + 1)"
        case .receiver:
            return "Movable Resonance Point at Row \(node.position.row + 1), Column \(node.position.col + 1)"
        }
    }
}

// MARK: - Subviews

private struct CellBackgroundView: View {
    let row: Int
    let col: Int
    let cellSize: CGFloat
    let isCenterCol: Bool
    let isFullSensory: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(white: isCenterCol && isFullSensory ? 0.16 : 0.13))
                .overlay(
                    Rectangle()
                        .stroke(Color(white: 0.2), lineWidth: 0.5)
                )

            if isCenterCol {
                Circle()
                    .fill(Color(white: 0.3))
                    .frame(width: 3, height: 3)
            }
        }
        .frame(width: cellSize, height: cellSize)
        .accessibilityLabel("Cell Row \(row + 1), Column \(col + 1)")
    }
}

private struct NodeItemView: View {
    let node: NodeState
    let cellSize: CGFloat
    let isDragging: Bool
    let isFullSensory: Bool
    let resonanceScore: Double

    var body: some View {
        let nodeRadius = cellSize * 0.36

        ZStack {
            switch node.type {
            case .source:
                Circle()
                    .fill(Color(white: 0.35))
                    .frame(width: nodeRadius * 2, height: nodeRadius * 2)
                    .overlay(
                        Circle()
                            .stroke(Color(white: 0.7), lineWidth: 2)
                    )
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                    )

            case .blocker:
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(white: 0.2))
                    .frame(width: nodeRadius * 1.8, height: nodeRadius * 1.8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(white: 0.4), lineWidth: 1.5)
                    )
                    .overlay(
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(white: 0.5))
                    )

            case .receiver:
                if isFullSensory {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.cyan.opacity(0.8),
                                    Color.cyan.opacity(0.3 + 0.3 * resonanceScore),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 2,
                                endRadius: nodeRadius * 1.4
                            )
                        )
                        .frame(width: nodeRadius * 2.8, height: nodeRadius * 2.8)
                        .blur(radius: 1)
                }

                Circle()
                    .fill(isFullSensory ? Color.cyan : Color.white)
                    .frame(width: nodeRadius * 2, height: nodeRadius * 2)
                    .shadow(
                        color: isDragging ? Color.cyan.opacity(0.5) : Color.black.opacity(0.3),
                        radius: isDragging ? 8 : 2,
                        x: 0,
                        y: isDragging ? 3 : 1
                    )
                    .scaleEffect(isDragging ? 1.15 : 1.0)
            }
        }
    }
}

private struct SymmetryLinesOverlay: View {
    let board: BoardState
    let cellSize: CGFloat
    let resonanceScore: Double

    var body: some View {
        Canvas { context, size in
            let sources = board.sourceNodes
            let movables = board.movableNodes

            for source in sources {
                let targetPos = source.position.verticallyMirrored(boardWidth: board.size)
                guard let matchingMovable = movables.first(where: { $0.position == targetPos }) else {
                    continue
                }

                let p1 = CGPoint(
                    x: (CGFloat(source.position.col) + 0.5) * cellSize,
                    y: (CGFloat(source.position.row) + 0.5) * cellSize
                )
                let p2 = CGPoint(
                    x: (CGFloat(matchingMovable.position.col) + 0.5) * cellSize,
                    y: (CGFloat(matchingMovable.position.row) + 0.5) * cellSize
                )

                var path = Path()
                path.move(to: p1)
                path.addLine(to: p2)

                context.stroke(
                    path,
                    with: .color(Color.cyan.opacity(0.5 + 0.5 * resonanceScore)),
                    lineWidth: 2
                )
            }
        }
    }
}
