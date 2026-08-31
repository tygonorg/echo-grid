//
//  LocalizationManager.swift
//  Echo Grid
//

import SwiftUI
import Combine

public enum L10nKey: String, Sendable {
    // App Brand
    case appTitle
    case appTagline

    // Main Menu
    case menuContinue
    case menuDailyChallenge
    case menuSelectLevel
    case menuHowToPlay
    case menuStatistics
    case menuHapticCalibration
    case menuSettings
    case menuLevelsCleared
    case menuStarsCount
    case menuTodayReady
    case menuTodayCompleted

    // Tutorial
    case tutSkip
    case tutStep1Title
    case tutStep1Desc
    case tutStep1DragHere
    case tutStep1Target
    case tutStep2Title
    case tutStep2Desc
    case tutStep3Title
    case tutStep3Desc
    case tutTipAudio
    case tutExcellent
    case tutStepSuccessDesc
    case tutAllDoneDesc
    case tutNextStep
    case tutStartPlaying
    case tutResonanceBar

    // Gameplay
    case gameLevel
    case gameMoves
    case gamePar
    case gameTime
    case gameNewRecord
    case gameResonanceAligned
    case gameNextLevel
    case gameReplay
    case gameSelectLevelBtn

    // Daily & Share
    case dailyTitle
    case dailyStreak
    case dailyHint
    case dailyShareTitle
    case dailyShareBtn
    case dailyCopyTextBtn
    case dailyCopiedAlertTitle
    case dailyCopiedAlertMsg

    // Calibration
    case calTitle
    case calSubtitle
    case calDesc
    case calTestPulse
    case calSaveApply
    case calDelicate
    case calGentle
    case calStandard
    case calFirm
    case calIntense

    // Settings
    case setHeader
    case setLanguage
    case setSensory
    case setHaptics
    case setAudio
    case setHighContrast
    case setMode
    case setProgressData
    case setResetAll
    case setResetAlertTitle
    case setResetAlertMsg
    case setCancel
    case setReset

    // Stats
    case statsHeader
    case statsCurrentStreak
    case statsBestStreak
    case statsTotalStars
    case statsCuratedCleared
    case statsDailiesCleared
    case statsClearRate
    case statsDistribution
}

@MainActor
public final class LocalizationManager: ObservableObject {
    public static let shared = LocalizationManager()

    private let languageKey = "echo_grid_user_language_v1"

    @Published public var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }

    private init() {
        if let saved = UserDefaults.standard.string(forKey: languageKey),
           let lang = AppLanguage(rawValue: saved) {
            self.currentLanguage = lang
        } else {
            let preferred = Locale.preferredLanguages.first ?? "en"
            if preferred.hasPrefix("vi") {
                self.currentLanguage = .vietnamese
            } else if preferred.hasPrefix("ja") {
                self.currentLanguage = .japanese
            } else if preferred.hasPrefix("ko") {
                self.currentLanguage = .korean
            } else if preferred.hasPrefix("es") {
                self.currentLanguage = .spanish
            } else if preferred.hasPrefix("fr") {
                self.currentLanguage = .french
            } else if preferred.hasPrefix("de") {
                self.currentLanguage = .german
            } else if preferred.hasPrefix("zh") {
                self.currentLanguage = .chineseSimplified
            } else {
                self.currentLanguage = .english
            }
        }
    }

    public func text(_ key: L10nKey) -> String {
        Self.translations[currentLanguage]?[key] ??
        Self.translations[.english]?[key] ??
        key.rawValue
    }

    // MARK: - Translations Dictionary
    private static let translations: [AppLanguage: [L10nKey: String]] = [
        .english: [
            .appTitle: "ECHO GRID",
            .appTagline: "SENSORY DEDUCTION PUZZLE",
            .menuContinue: "CONTINUE",
            .menuDailyChallenge: "DAILY CHALLENGE",
            .menuSelectLevel: "SELECT LEVEL",
            .menuHowToPlay: "HOW TO PLAY",
            .menuStatistics: "STATISTICS",
            .menuHapticCalibration: "HAPTIC CALIBRATION",
            .menuSettings: "SETTINGS",
            .menuLevelsCleared: "Cleared",
            .menuStarsCount: "Stars",
            .menuTodayReady: "Today's Puzzle Ready",
            .menuTodayCompleted: "Completed Today",

            .tutSkip: "Skip",
            .tutStep1Title: "1. TOUCH & DRAG",
            .tutStep1Desc: "The white dot on the left is a Fixed Anchor. Drag the glowing cyan dot to the highlighted target box on the right.",
            .tutStep1DragHere: "Target Cell",
            .tutStep1Target: "TARGET",
            .tutStep2Title: "2. SENSORY RESONANCE",
            .tutStep2Desc: "Listen to the tone & feel the vibration. Closer to the goal = crisper double pulse and higher harmonic pitch!",
            .tutStep3Title: "3. DEDUCE HIDDEN RULES",
            .tutStep3Desc: "Every puzzle hides a rule (symmetry or linear alignment). Align all 3 cyan dots into a straight line.",
            .tutTipAudio: "Turn on audio & hold phone to feel haptics",
            .tutExcellent: "EXCELLENT!",
            .tutStepSuccessDesc: "You felt the resonance feedback. Ready for the next step!",
            .tutAllDoneDesc: "You have mastered the mechanics of Echo Grid! Begin your deduction journey.",
            .tutNextStep: "NEXT STEP",
            .tutStartPlaying: "START PLAYING",
            .tutResonanceBar: "Resonance Alignment",

            .gameLevel: "LEVEL",
            .gameMoves: "MOVES:",
            .gamePar: "Par",
            .gameTime: "Time:",
            .gameNewRecord: "✨ NEW BEST RECORD! ✨",
            .gameResonanceAligned: "RESONANCE ALIGNED",
            .gameNextLevel: "NEXT LEVEL",
            .gameReplay: "Replay",
            .gameSelectLevelBtn: "Levels",

            .dailyTitle: "DAILY CHALLENGE",
            .dailyStreak: "STREAK",
            .dailyHint: "HINT",
            .dailyShareTitle: "RESONANCE FINGERPRINT",
            .dailyShareBtn: "Share with Friends",
            .dailyCopyTextBtn: "Copy Result Text",
            .dailyCopiedAlertTitle: "Copied to Clipboard",
            .dailyCopiedAlertMsg: "Summary copied. Paste it into your favorite chat app.",

            .calTitle: "HAPTIC CALIBRATION",
            .calSubtitle: "Tune Tactile Sensitivity",
            .calDesc: "Calibrate pulse intensity to match your device and phone case.",
            .calTestPulse: "Test Pulse Now",
            .calSaveApply: "SAVE & APPLY",
            .calDelicate: "Delicate (0.5x)",
            .calGentle: "Gentle (0.75x)",
            .calStandard: "Standard (1.0x)",
            .calFirm: "Firm (1.25x)",
            .calIntense: "Intense (1.5x)",

            .setHeader: "SETTINGS",
            .setLanguage: "LANGUAGE",
            .setSensory: "SENSORY PREFERENCES",
            .setHaptics: "Haptic Feedback",
            .setAudio: "Harmonic Audio Tones",
            .setHighContrast: "High Contrast Mode",
            .setMode: "DEFAULT EXPERIENCE MODE",
            .setProgressData: "PROGRESS DATA",
            .setResetAll: "Reset All Level Progress",
            .setResetAlertTitle: "Reset All Progress?",
            .setResetAlertMsg: "This will lock all levels except Level 1 and erase best moves & stars.",
            .setCancel: "Cancel",
            .setReset: "Reset",

            .statsHeader: "PLAYER STATISTICS",
            .statsCurrentStreak: "CURRENT DAILY STREAK",
            .statsBestStreak: "Best Streak Record:",
            .statsTotalStars: "Total Stars",
            .statsCuratedCleared: "Curated Cleared",
            .statsDailiesCleared: "Dailies Cleared",
            .statsClearRate: "Clear Rate",
            .statsDistribution: "STAR DISTRIBUTION"
        ],

        .vietnamese: [
            .appTitle: "ECHO GRID",
            .appTagline: "SUY LUẬN BẰNG XÚC GIÁC & ÂM THANH",
            .menuContinue: "TIẾP TỤC",
            .menuDailyChallenge: "THỬ THÁCH MỖI NGÀY",
            .menuSelectLevel: "CHỌN MÀN CHƠI",
            .menuHowToPlay: "HƯỚNG DẪN CHƠI",
            .menuStatistics: "BẢNG THỐNG KÊ",
            .menuHapticCalibration: "CÂN CHỈNH ĐỘ RUNG",
            .menuSettings: "CÀI ĐẶT",
            .menuLevelsCleared: "Đã vượt",
            .menuStarsCount: "Sao",
            .menuTodayReady: "Câu đố hôm nay đã sẵn sàng",
            .menuTodayCompleted: "Đã hoàn thành hôm nay",

            .tutSkip: "Bỏ qua",
            .tutStep1Title: "1. CHẠM & KÉO THẢ",
            .tutStep1Desc: "Chấm trắng bên trái là Mỏ Neo cố định. Hãy kéo điểm màu Xanh vào đúng ô mục tiêu phát sáng bên phải.",
            .tutStep1DragHere: "Ô Mục Tiêu",
            .tutStep1Target: "MỤC TIÊU",
            .tutStep2Title: "2. CẢM NHẬN HÒA ÂM",
            .tutStep2Desc: "Lắng nghe âm thanh & cảm nhận độ rung. Càng kéo gần đáp án = rung 2 nhịp sắc nét và âm thanh càng thanh thoát!",
            .tutStep3Title: "3. SUY LUẬN QUY LUẬT",
            .tutStep3Desc: "Mỗi câu đố có quy luật ẩn (đối xứng hoặc thẳng hàng). Hãy xếp 3 điểm màu xanh thẳng một hàng!",
            .tutTipAudio: "Bật âm thanh & cầm chắc máy để cảm nhận độ rung",
            .tutExcellent: "XUẤT SẮC!",
            .tutStepSuccessDesc: "Bạn đã cảm nhận được phản hồi cộng hưởng. Tiếp tục sang bước tiếp theo!",
            .tutAllDoneDesc: "Bạn đã nắm vững toàn bộ cách chơi Echo Grid! Hãy bắt đầu hành trình giải đố.",
            .tutNextStep: "BƯỚC TIẾP THEO",
            .tutStartPlaying: "BẮT ĐẦU CHƠI",
            .tutResonanceBar: "Mức độ Cộng Hưởng",

            .gameLevel: "MÀN",
            .gameMoves: "BƯỚC ĐI:",
            .gamePar: "Mục tiêu",
            .gameTime: "Thời gian:",
            .gameNewRecord: "✨ KỶ LỤC MỚI! ✨",
            .gameResonanceAligned: "CỘNG HƯỞNG HOÀN TẤT",
            .gameNextLevel: "MÀN TIẾP THEO",
            .gameReplay: "Chơi lại",
            .gameSelectLevelBtn: "Danh sách",

            .dailyTitle: "THỬ THÁCH MỖI NGÀY",
            .dailyStreak: "CHUỖI NGÀY",
            .dailyHint: "GỢI Ý",
            .dailyShareTitle: "DẤU ẤN CỘNG HƯỞNG",
            .dailyShareBtn: "Chia sẻ với Bạn bè",
            .dailyCopyTextBtn: "Sao chép Kết quả",
            .dailyCopiedAlertTitle: "Đã sao chép vào bộ nhớ tạm",
            .dailyCopiedAlertMsg: "Đã sao chép kết quả. Bạn có thể dán vào ứng dụng nhắn tin yêu thích.",

            .calTitle: "CÂN CHỈNH ĐỘ RUNG",
            .calSubtitle: "Tinh chỉnh Độ nhạy Xúc giác",
            .calDesc: "Cân chỉnh cường độ rung để phù hợp với ốp lưng và thiết bị của bạn.",
            .calTestPulse: "Thử Rung Ngay",
            .calSaveApply: "LƯU & ÁP DỤNG",
            .calDelicate: "Thanh thoát (0.5x)",
            .calGentle: "Nhẹ nhàng (0.75x)",
            .calStandard: "Tiêu chuẩn (1.0x)",
            .calFirm: "Rõ nét (1.25x)",
            .calIntense: "Mạnh mẽ (1.5x)",

            .setHeader: "CÀI ĐẶT",
            .setLanguage: "NGÔN NGỮ / LANGUAGE",
            .setSensory: "TÙY CHỌN GIÁC QUAN",
            .setHaptics: "Rung Xúc giác (Haptics)",
            .setAudio: "Âm thanh Hòa âm (Audio)",
            .setHighContrast: "Chế độ Tương phản Cao",
            .setMode: "CHẾ ĐỘ TRẢI NGHIỆM MẶC ĐỊNH",
            .setProgressData: "DỮ LIỆU TIẾN TRÌNH",
            .setResetAll: "Xóa toàn bộ Tiến trình chơi",
            .setResetAlertTitle: "Xóa toàn bộ tiến trình?",
            .setResetAlertMsg: "Hành động này sẽ khóa lại các màn chơi (trừ Màn 1) và xóa số sao kỷ lục.",
            .setCancel: "Hủy",
            .setReset: "Xóa",

            .statsHeader: "THỐNG KÊ NGƯỜI CHƠI",
            .statsCurrentStreak: "CHUỖI NGÀY LIÊN TIẾP HIỆN TẠI",
            .statsBestStreak: "Kỷ lục chuỗi ngày dài nhất:",
            .statsTotalStars: "Tổng số Sao",
            .statsCuratedCleared: "Màn chơi Đã vượt",
            .statsDailiesCleared: "Màn Daily Đã vượt",
            .statsClearRate: "Tỷ lệ Hoàn thành",
            .statsDistribution: "PHÂN BỔ SAO ĐẠT ĐƯỢC"
        ],

        .japanese: [
            .appTitle: "ECHO GRID",
            .appTagline: "触覚と音色の演繹パズル",
            .menuContinue: "続きからプレイ",
            .menuDailyChallenge: "デイリーチャレンジ",
            .menuSelectLevel: "ステージ選択",
            .menuHowToPlay: "遊び方",
            .menuStatistics: "プレイ統計",
            .menuHapticCalibration: "触覚キャリブレーション",
            .menuSettings: "設定",
            .menuLevelsCleared: "クリア",
            .menuStarsCount: "スター",
            .menuTodayReady: "本日のパズルが準備完了",
            .menuTodayCompleted: "本日クリア済み",
            .tutSkip: "スキップ",
            .tutStep1Title: "1. タッチ＆ドラッグ",
            .tutStep1Desc: "左の白い点は固定アンカーです。光るシアンの点を右側の光る目標マスへドラッグしてください。",
            .tutStep1DragHere: "目標マス",
            .tutStep1Target: "目標",
            .tutStep2Title: "2. 共鳴フィードバック",
            .tutStep2Desc: "正解に近づくほど、振動がシャープになり音色が高くなります。2つの点をバランスよく配置しましょう。",
            .tutStep3Title: "3. 隠された法則を推理",
            .tutStep3Desc: "各パズルには対称や直線整列の法則が隠されています。3つの点を一直線に並べてください。",
            .tutTipAudio: "音声をオンにして本体をしっかりお持ちください",
            .tutExcellent: "クリア！",
            .tutStepSuccessDesc: "共鳴フィードバックを感じ取れました。次のステップへ進みましょう！",
            .tutAllDoneDesc: "基本操作をマスターしました！演繹の旅を始めましょう。",
            .tutNextStep: "次へ進む",
            .tutStartPlaying: "ゲームを開始",
            .tutResonanceBar: "共鳴同調度",
            .gameLevel: "ステージ",
            .gameMoves: "手数:",
            .gamePar: "目標",
            .gameTime: "タイム:",
            .gameNewRecord: "✨ 新記録達成！ ✨",
            .gameResonanceAligned: "共鳴同調完了",
            .gameNextLevel: "次のステージ",
            .gameReplay: "リトライ",
            .gameSelectLevelBtn: "ステージ一覧",
            .dailyTitle: "デイリーチャレンジ",
            .dailyStreak: "連続日数",
            .dailyHint: "ヒント",
            .dailyShareTitle: "共鳴フィンガープリント",
            .dailyShareBtn: "友達にシェア",
            .dailyCopyTextBtn: "結果をコピー",
            .dailyCopiedAlertTitle: "コピー完了",
            .dailyCopiedAlertMsg: "クリップボードにコピーしました。",
            .calTitle: "触覚キャリブレーション",
            .calSubtitle: "振動感度の調整",
            .calDesc: "ケースや端末に合わせて振動の強さを調整します。",
            .calTestPulse: "振動テスト",
            .calSaveApply: "保存して適用",
            .calDelicate: "繊細 (0.5x)",
            .calGentle: "ソフト (0.75x)",
            .calStandard: "標準 (1.0x)",
            .calFirm: "強め (1.25x)",
            .calIntense: "強力 (1.5x)",
            .setHeader: "設定",
            .setLanguage: "言語 / LANGUAGE",
            .setSensory: "感覚設定",
            .setHaptics: "触覚フィードバック",
            .setAudio: "和音サウンド",
            .setHighContrast: "ハイコントラスト",
            .setMode: "デフォルトモード",
            .setProgressData: "データ管理",
            .setResetAll: "進行状況をリセット",
            .setResetAlertTitle: "リセットしますか？",
            .setResetAlertMsg: "ステージ1以外の全ステージがロックされます。",
            .setCancel: "キャンセル",
            .setReset: "リセット",
            .statsHeader: "プレイヤー統計",
            .statsCurrentStreak: "現在の連続日数",
            .statsBestStreak: "最高連続日数:",
            .statsTotalStars: "獲得スター総数",
            .statsCuratedCleared: "クリアステージ数",
            .statsDailiesCleared: "デイリークリア数",
            .statsClearRate: "勝率",
            .statsDistribution: "スター獲得分布"
        ]
    ]
}
