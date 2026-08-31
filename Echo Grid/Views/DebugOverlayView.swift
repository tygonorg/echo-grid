//
//  DebugOverlayView.swift
//  Echo Grid
//

import SwiftUI

public struct DebugOverlayView: View {
    @ObservedObject var controller: GameplaySessionController

    public init(controller: GameplaySessionController) {
        self.controller = controller
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(controller.isSolved ? Color.green : Color.orange)
                    .frame(width: 8, height: 8)
                Text("TELEMETRY HUD")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                Text(controller.feedbackMode.shortTitle)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(4)
                    .foregroundColor(.white)
            }

            Divider()
                .background(Color.white.opacity(0.2))

            // Resonance Progress
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Resonance:")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(format: "%.1f%%", controller.latestResonanceScore * 100))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(controller.isSolved ? .green : .cyan)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(controller.isSolved ? Color.green : Color.cyan)
                            .frame(width: geo.size.width * CGFloat(controller.latestResonanceScore), height: 6)
                    }
                }
                .frame(height: 6)
            }

            // Metrics Grid
            HStack(spacing: 12) {
                MetricItem(
                    label: "Moves",
                    value: "\(controller.logger.currentRecord.totalMoves)"
                )
                MetricItem(
                    label: "Invalid",
                    value: "\(controller.logger.currentRecord.invalidMoves)"
                )
                MetricItem(
                    label: "Oscillations",
                    value: "\(controller.logger.currentRecord.oscillationCount)"
                )
                MetricItem(
                    label: "Time",
                    value: String(format: "%.1fs", controller.logger.currentRecord.durationSeconds)
                )
            }
            .padding(.top, 2)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
}

private struct MetricItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label)
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}
