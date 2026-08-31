//
//  SettingsView.swift
//  Echo Grid
//

import SwiftUI

public struct SettingsView: View {
    @ObservedObject private var progressManager = ProgressManager.shared
    @ObservedObject private var l10n = LocalizationManager.shared
    let onBack: () -> Void

    @State private var soundEnabled: Bool = true
    @State private var hapticsEnabled: Bool = true
    @State private var highContrastEnabled: Bool = false
    @State private var preferredMode: FeedbackMode = .fullSensory
    @State private var showResetAlert: Bool = false

    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header Bar
                HStack {
                    Button {
                        saveAndDismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(white: 0.18))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text(l10n.text(.setHeader))
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 20) {
                        // Section: Language Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text(l10n.text(.setLanguage))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)

                            VStack(spacing: 0) {
                                ForEach(AppLanguage.allCases) { lang in
                                    Button {
                                        withAnimation {
                                            l10n.currentLanguage = lang
                                        }
                                    } label: {
                                        HStack {
                                            Text(lang.flagEmoji)
                                                .font(.title3)
                                            Text(lang.displayName)
                                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                                .foregroundColor(.white)

                                            Spacer()

                                            if l10n.currentLanguage == lang {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.cyan)
                                                    .font(.headline)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                    }

                                    if lang != AppLanguage.allCases.last {
                                        Divider().background(Color.white.opacity(0.1))
                                    }
                                }
                            }
                            .background(Color(white: 0.13))
                            .cornerRadius(12)
                        }

                        // Section: Sensory Controls
                        VStack(alignment: .leading, spacing: 12) {
                            Text(l10n.text(.setSensory))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)

                            VStack(spacing: 0) {
                                Toggle(l10n.text(.setHaptics), isOn: $hapticsEnabled)
                                    .padding()
                                Divider().background(Color.white.opacity(0.1))
                                Toggle(l10n.text(.setAudio), isOn: $soundEnabled)
                                    .padding()
                                Divider().background(Color.white.opacity(0.1))
                                Toggle(l10n.text(.setHighContrast), isOn: $highContrastEnabled)
                                    .padding()
                            }
                            .background(Color(white: 0.13))
                            .cornerRadius(12)
                        }

                        // Section: Default Mode
                        VStack(alignment: .leading, spacing: 12) {
                            Text(l10n.text(.setMode))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)

                            Picker("Mode", selection: $preferredMode) {
                                ForEach(FeedbackMode.allCases) { mode in
                                    Text(mode.shortTitle).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        // Section: Data & Reset
                        VStack(alignment: .leading, spacing: 12) {
                            Text(l10n.text(.setProgressData))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)

                            Button {
                                showResetAlert = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text(l10n.text(.setResetAll))
                                    Spacer()
                                }
                                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                .foregroundColor(.red)
                                .padding()
                                .background(Color(white: 0.13))
                                .cornerRadius(12)
                            }
                        }

                        // Section: About
                        VStack(spacing: 4) {
                            Text("Echo Grid — iOS Global Release")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                            Text("v1.0 (Multi-Language Supported)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 24)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            self.soundEnabled = progressManager.settings.soundEnabled
            self.hapticsEnabled = progressManager.settings.hapticsEnabled
            self.highContrastEnabled = progressManager.settings.highContrastEnabled
            self.preferredMode = progressManager.settings.preferredMode
        }
        .alert(l10n.text(.setResetAlertTitle), isPresented: $showResetAlert) {
            Button(l10n.text(.setCancel), role: .cancel) {}
            Button(l10n.text(.setReset), role: .destructive) {
                progressManager.resetAllProgress()
            }
        } message: {
            Text(l10n.text(.setResetAlertMsg))
        }
    }

    private func saveAndDismiss() {
        let newSettings = UserSettingsRecord(
            hapticScale: progressManager.settings.hapticScale,
            soundEnabled: soundEnabled,
            hapticsEnabled: hapticsEnabled,
            highContrastEnabled: highContrastEnabled,
            preferredMode: preferredMode
        )
        progressManager.updateSettings(newSettings)
        onBack()
    }
}
