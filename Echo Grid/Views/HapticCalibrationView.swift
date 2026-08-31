//
//  HapticCalibrationView.swift
//  Echo Grid
//

import SwiftUI

public struct HapticCalibrationView: View {
    @ObservedObject private var progressManager = ProgressManager.shared
    @ObservedObject private var l10n = LocalizationManager.shared
    let onBack: () -> Void

    @State private var currentScale: Float = 1.0

    private var presetSteps: [(scale: Float, name: String, desc: String)] {
        [
            (0.5, l10n.text(.calDelicate), "Minimal sensation"),
            (0.75, l10n.text(.calGentle), "Subtle tactile feedback"),
            (1.0, l10n.text(.calStandard), "Balanced resonance (Default)"),
            (1.25, l10n.text(.calFirm), "Enhanced punch through slim cases"),
            (1.5, l10n.text(.calIntense), "Maximum power for thick protective cases")
        ]
    }

    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                // Header
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

                    Text(l10n.text(.calTitle))
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // Info Banner
                VStack(spacing: 6) {
                    Image(systemName: "waveform.badge.magnifyingglass")
                        .font(.system(size: 38))
                        .foregroundColor(.cyan)
                    Text(l10n.text(.calSubtitle))
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(l10n.text(.calDesc))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                // Preset Buttons
                VStack(spacing: 10) {
                    ForEach(presetSteps, id: \.scale) { step in
                        Button {
                            currentScale = step.scale
                            testCurrentHaptic()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(step.name)
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                    Text(step.desc)
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text(String(format: "%.2fx", step.scale))
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(currentScale == step.scale ? .cyan : .gray)

                                Image(systemName: currentScale == step.scale ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(currentScale == step.scale ? .cyan : Color(white: 0.3))
                                    .font(.title3)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(currentScale == step.scale ? Color.cyan.opacity(0.12) : Color(white: 0.13))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(currentScale == step.scale ? Color.cyan : Color.white.opacity(0.1), lineWidth: 1.5)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                // Bottom Action Buttons
                VStack(spacing: 12) {
                    Button {
                        testCurrentHaptic()
                    } label: {
                        Label(l10n.text(.calTestPulse), systemImage: "waveform")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.22))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button {
                        progressManager.updateHapticScale(currentScale)
                        onBack()
                    } label: {
                        Text(l10n.text(.calSaveApply))
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            self.currentScale = progressManager.settings.hapticScale
        }
    }

    private func testCurrentHaptic() {
        HapticFeedbackOrchestrator.shared.testHapticLevel(scale: currentScale)
    }
}
