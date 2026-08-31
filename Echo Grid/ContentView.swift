//
//  ContentView.swift
//  Echo Grid
//

import SwiftUI
import Combine

public enum AppScreen: Equatable {
    case menu
    case tutorial
    case dailyChallenge
    case levelSelect
    case gameplay(level: LevelDefinition)
    case stats
    case calibration
    case settings

    public static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.menu, .menu), (.tutorial, .tutorial), (.dailyChallenge, .dailyChallenge), (.levelSelect, .levelSelect),
             (.stats, .stats), (.calibration, .calibration), (.settings, .settings):
            return true
        case (.gameplay(let l1), .gameplay(let l2)):
            return l1.id == l2.id
        default:
            return false
        }
    }
}

struct ContentView: View {
    @State private var isAppReady: Bool = false
    @State private var currentScreen: AppScreen = .menu
    @ObservedObject private var progressManager = ProgressManager.shared
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if !isAppReady {
                SplashLoadingView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isAppReady = true
                        if !progressManager.hasCompletedOnboarding {
                            currentScreen = .tutorial
                        } else {
                            currentScreen = .menu
                        }
                    }
                }
                .transition(.opacity)
            } else {
                switch currentScreen {
                case .menu:
                    MainMenuView(
                        onContinue: {
                            let levelId = progressManager.highestUnlockedLevelId
                            if let level = LevelRepository.shared.level(byId: levelId) {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentScreen = .gameplay(level: level)
                                }
                            }
                        },
                        onOpenDaily: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .dailyChallenge
                            }
                        },
                        onSelectLevels: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .levelSelect
                            }
                        },
                        onOpenTutorial: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .tutorial
                            }
                        },
                        onOpenStats: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .stats
                            }
                        },
                        onOpenCalibration: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .calibration
                            }
                        },
                        onOpenSettings: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .settings
                            }
                        }
                    )
                    .transition(.opacity)

                case .tutorial:
                    TutorialOnboardingView(
                        onFinish: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .menu
                            }
                        }
                    )
                    .transition(.opacity)

                case .dailyChallenge:
                    DailyChallengeView(
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .menu
                            }
                        }
                    )
                    .transition(.opacity)

                case .levelSelect:
                    LevelSelectView(
                        onSelectLevel: { level in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .gameplay(level: level)
                            }
                        },
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .menu
                            }
                        }
                    )
                    .transition(.opacity)

                case .gameplay(let level):
                    GameplayView(
                        level: level,
                        onBackToMenu: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .levelSelect
                            }
                        }
                    )
                    .transition(.opacity)

                case .stats:
                    PlayerStatsView(
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .menu
                            }
                        }
                    )
                    .transition(.opacity)

                case .calibration:
                    HapticCalibrationView(
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .menu
                            }
                        }
                    )
                    .transition(.opacity)

                case .settings:
                    SettingsView(
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentScreen = .menu
                            }
                        }
                    )
                    .transition(.opacity)
                }
            }
        }
        .preferredColorScheme(progressManager.settings.highContrastEnabled ? .light : .dark)
        .onOpenURL { url in
            // Handle Widget / System Deep Links (e.g. echogrid://daily)
            if url.scheme == "echogrid" && url.host == "daily" {
                if isAppReady {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentScreen = .dailyChallenge
                    }
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                AudioSynthesizerOrchestrator.shared.restartEngineIfNeeded()
                _ = ThermalBatteryGuard.shared
            }
        }
    }
}

#Preview {
    ContentView()
}
