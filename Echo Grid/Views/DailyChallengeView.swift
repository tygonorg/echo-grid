//
//  DailyChallengeView.swift
//  Echo Grid
//

import SwiftUI
import Combine

public struct DailyChallengeView: View {
    @ObservedObject private var dailyManager = DailyChallengeManager.shared
    @ObservedObject private var l10n = LocalizationManager.shared
    @StateObject private var controller: GameplaySessionController
    let onBack: () -> Void

    @State private var activeHintMessage: String?
    @State private var hintCooldownRemaining: Int = 0
    @State private var cooldownTimer: AnyCancellable?
    @State private var showShareSheet: Bool = false

    public init(onBack: @escaping () -> Void) {
        let level = DailyChallengeManager.shared.getTodayLevel()
        _controller = StateObject(wrappedValue: GameplaySessionController(
            level: level,
            feedbackMode: ProgressManager.shared.settings.preferredMode
        ))
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 14) {
                // Top Navigation & Date
                HStack {
                    Button {
                        onBack()
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
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                            Text("\(l10n.text(.dailyStreak)): \(dailyManager.currentStreak)")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.orange)
                        }
                        Text(l10n.text(.dailyTitle))
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

                // Date & Moves Stats Bar
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(.cyan)
                        Text(dailyManager.todayDateKey)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    HStack(spacing: 12) {
                        Text("\(l10n.text(.gameMoves)) \(controller.movesCount)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)

                        Text(String(format: "%.1fs", controller.sessionElapsedSeconds))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(white: 0.13))
                .cornerRadius(10)
                .padding(.horizontal, 20)

                // Hint Alert Banner (if requested)
                if let hint = activeHintMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text(hint)
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            withAnimation { activeHintMessage = nil }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(10)
                    .background(Color.yellow.opacity(0.15))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                Spacer(minLength: 0)

                // 5x5 Board
                BoardGridView(controller: controller)
                    .layoutPriority(1)

                Spacer(minLength: 0)

                // Bottom Hint & Actions
                HStack {
                    // Hint Button
                    Button {
                        requestHint()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb")
                            if hintCooldownRemaining > 0 {
                                Text("\(hintCooldownRemaining)s")
                            } else {
                                Text(l10n.text(.dailyHint))
                            }
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(hintCooldownRemaining > 0 ? Color(white: 0.15) : Color(white: 0.22))
                        .foregroundColor(hintCooldownRemaining > 0 ? .gray : .yellow)
                        .cornerRadius(10)
                    }
                    .disabled(hintCooldownRemaining > 0 || controller.isSolved)

                    Spacer()

                    // Subtitle
                    Text(controller.currentLevel.subtitle)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .onChange(of: controller.isSolved) { isSolved in
            if isSolved {
                // Record in Daily Challenge Manager
                _ = dailyManager.recordTodayCompletion(
                    moves: controller.movesCount,
                    timeSec: controller.sessionElapsedSeconds,
                    parMoves: controller.currentLevel.parMoves
                )

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showShareSheet = true
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareFingerprintSheetView(
                title: "Daily #\(dailyManager.todayDateKey)",
                moves: controller.movesCount,
                parMoves: controller.currentLevel.parMoves,
                stars: controller.starsEarned,
                timeSec: controller.sessionElapsedSeconds,
                onDismiss: {
                    showShareSheet = false
                    onBack()
                }
            )
        }
    }

    private func requestHint() {
        let hintResult = HintEngine.shared.generateHint(
            for: controller.board,
            rules: controller.currentLevel.ruleEvaluators
        )
        withAnimation {
            self.activeHintMessage = hintResult.message
        }

        // Start 30s Cooldown
        hintCooldownRemaining = 30
        cooldownTimer?.cancel()
        cooldownTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.hintCooldownRemaining > 0 {
                    self.hintCooldownRemaining -= 1
                } else {
                    self.cooldownTimer?.cancel()
                }
            }
    }
}
