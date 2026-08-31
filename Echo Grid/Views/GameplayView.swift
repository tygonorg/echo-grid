//
//  GameplayView.swift
//  Echo Grid
//

import SwiftUI

public struct GameplayView: View {
    @StateObject private var controller: GameplaySessionController
    @ObservedObject private var l10n = LocalizationManager.shared
    let onBackToMenu: () -> Void

    public init(level: LevelDefinition, onBackToMenu: @escaping () -> Void) {
        _controller = StateObject(wrappedValue: GameplaySessionController(
            level: level,
            feedbackMode: ProgressManager.shared.settings.preferredMode
        ))
        self.onBackToMenu = onBackToMenu
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                // Top Header Bar
                HStack {
                    Button {
                        onBackToMenu()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(white: 0.18))
                            .clipShape(Circle())
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text("\(l10n.text(.gameLevel)) \(controller.currentLevel.id)")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .tracking(2)
                            .foregroundColor(.cyan)
                        Text(controller.currentLevel.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button {
                        controller.resetCurrentLevel()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(white: 0.18))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // Stats Bar (Moves / Par & Timer)
                HStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Text(l10n.text(.gameMoves))
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.gray)
                        Text("\(controller.movesCount)")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        Text("/ \(l10n.text(.gamePar)) \(controller.currentLevel.parMoves)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    HStack(spacing: 6) {
                        Image(systemName: "stopwatch")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        Text(String(format: "%.1fs", controller.sessionElapsedSeconds))
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color(white: 0.12))
                .cornerRadius(10)
                .padding(.horizontal, 20)

                Spacer(minLength: 0)

                // 5x5 Board
                BoardGridView(controller: controller)
                    .layoutPriority(1)

                Spacer(minLength: 0)

                // Subtitle Hint
                Text(controller.currentLevel.subtitle)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }

            // Level Clear Overlay
            if controller.isClearModalPresented {
                LevelClearModalView(
                    controller: controller,
                    onNextLevel: {
                        let nextId = controller.currentLevel.id + 1
                        if let nextLevel = LevelRepository.shared.level(byId: nextId) {
                            controller.loadLevel(nextLevel)
                        } else {
                            onBackToMenu()
                        }
                    },
                    onReplay: {
                        controller.resetCurrentLevel()
                    },
                    onBackToMenu: {
                        onBackToMenu()
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}
