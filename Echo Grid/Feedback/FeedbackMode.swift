//
//  FeedbackMode.swift
//  Echo Grid
//

import Foundation

public enum FeedbackMode: String, CaseIterable, Identifiable, Codable, Sendable {
    case hapticOnly = "Condition A: Haptic-Only"
    case fullSensory = "Condition B: Full Sensory"

    public var id: String { rawValue }

    public var shortTitle: String {
        switch self {
        case .hapticOnly:
            return "Haptic-Only"
        case .fullSensory:
            return "Full Sensory"
        }
    }

    public var hasVisualEnhancements: Bool {
        self == .fullSensory
    }

    public var hasAudio: Bool {
        self == .fullSensory
    }

    public var hasHaptic: Bool {
        true
    }
}
