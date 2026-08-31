//
//  HapticFeedbackOrchestrator.swift
//  Echo Grid
//

import UIKit
import CoreHaptics

@MainActor
public final class HapticFeedbackOrchestrator {
    public static let shared = HapticFeedbackOrchestrator()

    private var hapticEngine: CHHapticEngine?
    private var supportsCoreHaptics: Bool = false

    // Feedback generators for fallback
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactRigid = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationGenerator = UINotificationFeedbackGenerator()

    public var hapticScale: Float = 1.0 // Scale factor (0.5 to 1.5)

    private init() {
        setupCoreHaptics()
        prepareFallbackGenerators()
    }

    private func setupCoreHaptics() {
        supportsCoreHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        guard supportsCoreHaptics else { return }

        do {
            hapticEngine = try CHHapticEngine()
            hapticEngine?.resetHandler = { [weak self] in
                Task { @MainActor in
                    do {
                        try self?.hapticEngine?.start()
                    } catch {
                        print("Failed to restart Core Haptics engine: \(error)")
                    }
                }
            }
            try hapticEngine?.start()
        } catch {
            print("Core Haptics not available on this device: \(error)")
            supportsCoreHaptics = false
        }
    }

    private func prepareFallbackGenerators() {
        impactLight.prepare()
        impactMedium.prepare()
        impactRigid.prepare()
        notificationGenerator.prepare()
    }

    /// Snap haptic when dropping a node into a valid cell
    public func playSnap() {
        guard supportsCoreHaptics, let engine = hapticEngine else {
            impactLight.impactOccurred(intensity: CGFloat(0.5 * hapticScale))
            return
        }

        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4 * hapticScale)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            impactLight.impactOccurred()
        }
    }

    /// Far / Low Resonance Feedback: Soft, thudding, low frequency
    public func playFar() {
        guard supportsCoreHaptics, let engine = hapticEngine else {
            impactLight.impactOccurred(intensity: CGFloat(0.3 * hapticScale))
            return
        }

        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3 * hapticScale)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.15)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            impactLight.impactOccurred()
        }
    }

    /// Progress / Close Feedback: Crisply defined double-pulse resonance
    public func playProgress() {
        guard supportsCoreHaptics, let engine = hapticEngine else {
            impactMedium.impactOccurred(intensity: CGFloat(0.7 * hapticScale))
            return
        }

        do {
            let intensity1 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5 * hapticScale)
            let sharpness1 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
            let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity1, sharpness1], relativeTime: 0.0)

            let intensity2 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.75 * hapticScale)
            let sharpness2 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity2, sharpness2], relativeTime: 0.08)

            let pattern = try CHHapticPattern(events: [event1, event2], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            impactMedium.impactOccurred()
        }
    }

    /// Solved Feedback: Harmonious chord sequence burst
    public func playSolved() {
        guard supportsCoreHaptics, let engine = hapticEngine else {
            notificationGenerator.notificationOccurred(.success)
            return
        }

        do {
            var events: [CHHapticEvent] = []
            let timings: [Double] = [0.0, 0.09, 0.18, 0.28]
            let intensities: [Float] = [0.4, 0.6, 0.85, 1.0]
            let sharpnesses: [Float] = [0.4, 0.6, 0.8, 0.95]

            for i in 0..<timings.count {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensities[i] * hapticScale)
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnesses[i])
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: timings[i])
                events.append(event)
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            notificationGenerator.notificationOccurred(.success)
        }
    }

    /// Test vibration at a specific scale for calibration
    public func testHapticLevel(scale: Float) {
        guard supportsCoreHaptics, let engine = hapticEngine else {
            impactMedium.impactOccurred(intensity: CGFloat(scale))
            return
        }

        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: scale)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            impactMedium.impactOccurred(intensity: CGFloat(scale))
        }
    }
}
