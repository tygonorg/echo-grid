//
//  SplashLoadingView.swift
//  Echo Grid
//

import SwiftUI

public struct SplashLoadingView: View {
    let onLoaded: () -> Void

    @State private var pulseScale: CGFloat = 0.85
    @State private var ringOpacity: Double = 0.3
    @State private var statusText: String = "INITIALIZING SENSORY MATRIX..."
    @State private var progressValue: Double = 0.0

    public init(onLoaded: @escaping () -> Void) {
        self.onLoaded = onLoaded
    }

    public var body: some View {
        ZStack {
            Color(white: 0.06)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 32) {
                Spacer()

                // Pulsing Resonance Rings & Center Glyph
                ZStack {
                    // Outer Expanding Glow Ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.cyan.opacity(0.4), Color.purple.opacity(0.2), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(pulseScale)
                        .opacity(ringOpacity)

                    // Inner Harmonic Ring
                    Circle()
                        .stroke(Color.cyan.opacity(0.6), lineWidth: 1.5)
                        .frame(width: 100, height: 100)
                        .scaleEffect(pulseScale * 0.95)

                    // Center 3x3 Dot Matrix
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Circle().fill(Color.white).frame(width: 8, height: 8)
                            Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                            Circle().fill(Color.cyan).frame(width: 8, height: 8)
                        }
                        HStack(spacing: 8) {
                            Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                            Circle().fill(Color.cyan).frame(width: 8, height: 8)
                            Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                        }
                        HStack(spacing: 8) {
                            Circle().fill(Color.cyan).frame(width: 8, height: 8)
                            Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                            Circle().fill(Color.white).frame(width: 8, height: 8)
                        }
                    }
                }

                // Brand Title
                VStack(spacing: 6) {
                    Text("ECHO GRID")
                        .font(.system(size: 26, weight: .black, design: .monospaced))
                        .tracking(6)
                        .foregroundColor(.white)

                    Text("SENSORY DEDUCTION")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(.cyan.opacity(0.8))
                }

                Spacer()

                // Progress Bar & Status
                VStack(spacing: 12) {
                    // Minimalist Progress Bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 180, height: 4)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.cyan, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(8, 180 * progressValue), height: 4)
                            .animation(.easeOut(duration: 0.3), value: progressValue)
                    }

                    Text(statusText)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            startWarmupSequence()
        }
    }

    private func startWarmupSequence() {
        // Ambient animation
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
            ringOpacity = 0.8
        }

        // Step 1: Progress start
        withAnimation { progressValue = 0.3 }

        // Step 2: Warm up audio and systems asynchronously
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s

            await MainActor.run {
                statusText = "CALIBRATING HAPTIC HARMONICS..."
                withAnimation { progressValue = 0.65 }
                _ = HapticFeedbackOrchestrator.shared
                _ = AudioSynthesizerOrchestrator.shared
                _ = ProgressManager.shared
                _ = DailyChallengeManager.shared
            }

            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s

            await MainActor.run {
                statusText = "ALIGNING RESONANCE MATRIX..."
                withAnimation { progressValue = 1.0 }
                HapticFeedbackOrchestrator.shared.playSnap()
            }

            try? await Task.sleep(nanoseconds: 250_000_000) // 0.25s

            await MainActor.run {
                onLoaded()
            }
        }
    }
}
