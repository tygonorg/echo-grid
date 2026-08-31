//
//  MainMenuView.swift
//  Echo Grid
//

import SwiftUI

public struct MainMenuView: View {
    @ObservedObject private var progressManager = ProgressManager.shared
    @ObservedObject private var dailyManager = DailyChallengeManager.shared
    @ObservedObject private var l10n = LocalizationManager.shared

    let onContinue: () -> Void
    let onOpenDaily: () -> Void
    let onSelectLevels: () -> Void
    let onOpenTutorial: () -> Void
    let onOpenStats: () -> Void
    let onOpenCalibration: () -> Void
    let onOpenSettings: () -> Void

    @State private var pulseScale: CGFloat = 1.0

    public init(
        onContinue: @escaping () -> Void,
        onOpenDaily: @escaping () -> Void,
        onSelectLevels: @escaping () -> Void,
        onOpenTutorial: @escaping () -> Void,
        onOpenStats: @escaping () -> Void,
        onOpenCalibration: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self.onContinue = onContinue
        self.onOpenDaily = onOpenDaily
        self.onSelectLevels = onSelectLevels
        self.onOpenTutorial = onOpenTutorial
        self.onOpenStats = onOpenStats
        self.onOpenCalibration = onOpenCalibration
        self.onOpenSettings = onOpenSettings
    }

    public var body: some View {
        ZStack {
            Color(white: 0.07)
                .edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Hero Logo & Title
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(Color.cyan.opacity(0.15), lineWidth: 1.5)
                                .frame(width: 120, height: 120)
                                .scaleEffect(pulseScale)

                            Circle()
                                .stroke(Color.cyan.opacity(0.3), lineWidth: 2)
                                .frame(width: 80, height: 80)

                            VStack(spacing: 5) {
                                HStack(spacing: 5) {
                                    Circle().fill(Color.white).frame(width: 7, height: 7)
                                    Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
                                    Circle().fill(Color.cyan).frame(width: 7, height: 7)
                                }
                                HStack(spacing: 5) {
                                    Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
                                    Circle().fill(Color.cyan).frame(width: 7, height: 7)
                                    Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
                                }
                                HStack(spacing: 5) {
                                    Circle().fill(Color.cyan).frame(width: 7, height: 7)
                                    Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
                                    Circle().fill(Color.white).frame(width: 7, height: 7)
                                }
                            }
                        }
                        .padding(.top, 16)

                        VStack(spacing: 2) {
                            Text(l10n.text(.appTitle))
                                .font(.system(size: 28, weight: .black, design: .monospaced))
                                .tracking(5)
                                .foregroundColor(.white)

                            Text(l10n.text(.appTagline))
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .tracking(2)
                                .foregroundColor(.cyan.opacity(0.8))
                        }
                    }

                    // DAILY CHALLENGE HERO BANNER
                    Button {
                        onOpenDaily()
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(dailyManager.isTodayCompleted ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                    .frame(width: 48, height: 48)
                                Image(systemName: dailyManager.isTodayCompleted ? "checkmark.seal.fill" : "flame.fill")
                                    .font(.title2)
                                    .foregroundColor(dailyManager.isTodayCompleted ? .green : .orange)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(l10n.text(.menuDailyChallenge))
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                Text(dailyManager.isTodayCompleted ? l10n.text(.menuTodayCompleted) : l10n.text(.menuTodayReady))
                                    .font(.system(size: 11))
                                    .foregroundColor(dailyManager.isTodayCompleted ? .green : .gray)
                            }

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text("\(dailyManager.currentStreak)d")
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)

                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                        }
                        .padding(14)
                        .background(Color(white: 0.13))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(dailyManager.isTodayCompleted ? Color.green.opacity(0.3) : Color.orange.opacity(0.4), lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal, 20)

                    // Menu Buttons
                    VStack(spacing: 10) {
                        // CONTINUE BUTTON
                        Button {
                            onContinue()
                        } label: {
                            HStack {
                                Text("\(l10n.text(.menuContinue)) (LVL \(progressManager.highestUnlockedLevelId))")
                                Spacer()
                                Image(systemName: "play.fill")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }

                        // LEVEL SELECT
                        Button {
                            onSelectLevels()
                        } label: {
                            HStack {
                                Text(l10n.text(.menuSelectLevel))
                                Spacer()
                                Text("\(progressManager.completedLevelsCount)/15")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.gray)
                                Image(systemName: "square.grid.2x2.fill")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        // HOW TO PLAY / TUTORIAL
                        Button {
                            onOpenTutorial()
                        } label: {
                            HStack {
                                Text(l10n.text(.menuHowToPlay))
                                Spacer()
                                Image(systemName: "questionmark.circle.fill")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        // PLAYER STATS
                        Button {
                            onOpenStats()
                        } label: {
                            HStack {
                                Text(l10n.text(.menuStatistics))
                                Spacer()
                                Image(systemName: "chart.bar.xaxis")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        // HAPTIC CALIBRATION
                        Button {
                            onOpenCalibration()
                        } label: {
                            HStack {
                                Text(l10n.text(.menuHapticCalibration))
                                Spacer()
                                Image(systemName: "waveform")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        // SETTINGS
                        Button {
                            onOpenSettings()
                        } label: {
                            HStack {
                                Text(l10n.text(.menuSettings))
                                Spacer()
                                Image(systemName: "gearshape.fill")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.2
            }
        }
    }
}
