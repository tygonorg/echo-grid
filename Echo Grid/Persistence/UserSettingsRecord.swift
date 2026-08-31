//
//  UserSettingsRecord.swift
//  Echo Grid
//

import Foundation

public struct UserSettingsRecord: Codable, Hashable, Sendable {
    public var hapticScale: Float
    public var soundEnabled: Bool
    public var hapticsEnabled: Bool
    public var highContrastEnabled: Bool
    public var preferredMode: FeedbackMode

    public init(
        hapticScale: Float = 1.0,
        soundEnabled: Bool = true,
        hapticsEnabled: Bool = true,
        highContrastEnabled: Bool = false,
        preferredMode: FeedbackMode = .fullSensory
    ) {
        self.hapticScale = hapticScale
        self.soundEnabled = soundEnabled
        self.hapticsEnabled = hapticsEnabled
        self.highContrastEnabled = highContrastEnabled
        self.preferredMode = preferredMode
    }
}
