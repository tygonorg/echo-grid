//
//  LevelClearModalView.swift
//  Echo Grid
//

import SwiftUI

public struct LevelClearModalView: View {
    @ObservedObject var controller: GameplaySessionController
    @ObservedObject private var l10n = LocalizationManager.shared
    let onNextLevel: () -> Void
    let onReplay: () -> Void
    let onBackToMenu: () -> Void

    public init(
        controller: GameplaySessionController,
        onNextLevel: @escaping () -> Void,
        onReplay: @escaping () -> Void,
        onBackToMenu: @escaping () -> Void
    ) {
        self.controller = controller
        self.onNextLevel = onNextLevel
        self.onReplay = onReplay
        self.onBackToMenu = onBackToMenu
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                // Celebration Icon
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundColor(.cyan)

                    Text(l10n.text(.gameResonanceAligned))
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(.white)

                    Text(controller.currentLevel.title)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Stars Rating
                HStack(spacing: 12) {
                    ForEach(1...3, id: \.self) { star in
                        Image(systemName: star <= controller.starsEarned ? "star.fill" : "star")
                            .font(.system(size: 32))
                            .foregroundColor(star <= controller.starsEarned ? .yellow : Color(white: 0.3))
                            .scaleEffect(star <= controller.starsEarned ? 1.15 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5).delay(Double(star) * 0.15), value: controller.starsEarned)
                    }
                }
                .padding(.vertical, 8)

                // Stats Box
                VStack(spacing: 10) {
                    HStack {
                        Text(l10n.text(.gameMoves))
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(controller.movesCount) / \(l10n.text(.gamePar)) \(controller.currentLevel.parMoves)")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(controller.movesCount <= controller.currentLevel.parMoves ? .green : .white)
                    }

                    HStack {
                        Text(l10n.text(.gameTime))
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "%.1fs", controller.sessionElapsedSeconds))
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }

                    if controller.isNewRecord {
                        Text(l10n.text(.gameNewRecord))
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.yellow)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color(white: 0.14))
                .cornerRadius(12)

                // Action Buttons
                VStack(spacing: 12) {
                    if controller.currentLevel.id < 15 {
                        Button {
                            onNextLevel()
                        } label: {
                            HStack {
                                Text(l10n.text(.gameNextLevel))
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }
                    }

                    HStack(spacing: 12) {
                        Button {
                            onReplay()
                        } label: {
                            Label(l10n.text(.gameReplay), systemImage: "arrow.counterclockwise")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(white: 0.2))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button {
                            onBackToMenu()
                        } label: {
                            Label(l10n.text(.gameSelectLevelBtn), systemImage: "square.grid.2x2")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(white: 0.2))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(white: 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                    )
            )
            .padding(.horizontal, 24)
        }
    }
}
