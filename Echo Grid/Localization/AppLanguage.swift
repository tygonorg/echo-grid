//
//  AppLanguage.swift
//  Echo Grid
//

import Foundation

public enum AppLanguage: String, CaseIterable, Identifiable, Codable, Sendable {
    case english = "en"
    case vietnamese = "vi"
    case japanese = "ja"
    case korean = "ko"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case chineseSimplified = "zh-Hans"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .english: return "English"
        case .vietnamese: return "Tiếng Việt"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .chineseSimplified: return "简体中文"
        }
    }

    public var flagEmoji: String {
        switch self {
        case .english: return "🇺🇸"
        case .vietnamese: return "🇻🇳"
        case .japanese: return "🇯🇵"
        case .korean: return "🇰🇷"
        case .spanish: return "🇪🇸"
        case .french: return "🇫🇷"
        case .german: return "🇩🇪"
        case .chineseSimplified: return "🇨🇳"
        }
    }
}
