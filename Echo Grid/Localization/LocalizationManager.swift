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
        ],

        .korean: [
            .appTitle: "ECHO GRID",
            .appTagline: "촉각과 화음의 연역 퍼즐",
            .menuContinue: "이어하기",
            .menuDailyChallenge: "일일 챌린지",
            .menuSelectLevel: "스테이지 선택",
            .menuHowToPlay: "게임 방법",
            .menuStatistics: "통계",
            .menuHapticCalibration: "햅틱 보정",
            .menuSettings: "설정",
            .menuLevelsCleared: "클리어",
            .menuStarsCount: "스타",
            .menuTodayReady: "오늘의 퍼즐 준비 완료",
            .menuTodayCompleted: "오늘 완료됨",

            .tutSkip: "건너뛰기",
            .tutStep1Title: "1. 터치 및 드래그",
            .tutStep1Desc: "왼쪽 흰색 점은 고정 앵커입니다. 빛나는 시안색 점을 오른쪽 목표 셀로 드래그하세요.",
            .tutStep1DragHere: "목표 셀",
            .tutStep1Target: "목표",
            .tutStep2Title: "2. 공명 피드백",
            .tutStep2Desc: "소리와 진동을 느껴보세요. 정답에 가까워질수록 진동이 선명해지고 음정이 높아집니다.",
            .tutStep3Title: "3. 숨겨진 규칙 추리",
            .tutStep3Desc: "모든 퍼즐에는 대칭이나 직선 정렬 규칙이 숨겨져 있습니다. 3개의 점을 일직선으로 정렬하세요.",
            .tutTipAudio: "오디오를 켜고 기기를 잡아 진동을 느껴보세요",
            .tutExcellent: "완벽합니다!",
            .tutStepSuccessDesc: "공명 피드백을 감지했습니다. 다음 단계로 이동하세요!",
            .tutAllDoneDesc: "기본 규칙을 마스터했습니다! 연역의 여정을 시작하세요.",
            .tutNextStep: "다음 단계",
            .tutStartPlaying: "게임 시작",
            .tutResonanceBar: "공명 정렬도",

            .gameLevel: "스테이지",
            .gameMoves: "이동 횟수:",
            .gamePar: "목표",
            .gameTime: "시간:",
            .gameNewRecord: "✨ 신기록 달성! ✨",
            .gameResonanceAligned: "공명 완료",
            .gameNextLevel: "다음 스테이지",
            .gameReplay: "다시하기",
            .gameSelectLevelBtn: "목록",

            .dailyTitle: "일일 챌린지",
            .dailyStreak: "연속 달성",
            .dailyHint: "힌트",
            .dailyShareTitle: "공명 지문",
            .dailyShareBtn: "친구에게 공유",
            .dailyCopyTextBtn: "결과 복사",
            .dailyCopiedAlertTitle: "클립보드에 복사됨",
            .dailyCopiedAlertMsg: "요약이 복사되었습니다.",

            .calTitle: "햅틱 보정",
            .calSubtitle: "촉각 민감도 조절",
            .calDesc: "기기 및 케이스에 맞게 진동 세기를 조절하세요.",
            .calTestPulse: "진동 테스트",
            .calSaveApply: "저장 및 적용",
            .calDelicate: "섬세함 (0.5x)",
            .calGentle: "부드러움 (0.75x)",
            .calStandard: "표준 (1.0x)",
            .calFirm: "강하게 (1.25x)",
            .calIntense: "강렬함 (1.5x)",

            .setHeader: "설정",
            .setLanguage: "언어 / LANGUAGE",
            .setSensory: "감각 설정",
            .setHaptics: "햅틱 피드백",
            .setAudio: "화음 사운드",
            .setHighContrast: "고대비 모드",
            .setMode: "기본 모드",
            .setProgressData: "진행 데이터",
            .setResetAll: "모든 진행 상황 초기화",
            .setResetAlertTitle: "초기화하시겠습니까?",
            .setResetAlertMsg: "스테이지 1을 제외한 모든 스테이지가 잠깁니다.",
            .setCancel: "취소",
            .setReset: "초기화",

            .statsHeader: "플레이어 통계",
            .statsCurrentStreak: "현재 연속 달성",
            .statsBestStreak: "최고 연속 기록:",
            .statsTotalStars: "총 스타 수",
            .statsCuratedCleared: "클리어한 스테이지",
            .statsDailiesCleared: "클리어한 일일 퍼즐",
            .statsClearRate: "완료율",
            .statsDistribution: "스타 획득 분포"
        ],

        .spanish: [
            .appTitle: "ECHO GRID",
            .appTagline: "PUZZLE DE DEDUCCIÓN SENSORIAL",
            .menuContinue: "CONTINUAR",
            .menuDailyChallenge: "DESAFÍO DIARIO",
            .menuSelectLevel: "SELECCIONAR NIVEL",
            .menuHowToPlay: "CÓMO JUGAR",
            .menuStatistics: "ESTADÍSTICAS",
            .menuHapticCalibration: "CALIBRACIÓN HÁPTICA",
            .menuSettings: "AJUSTES",
            .menuLevelsCleared: "Superados",
            .menuStarsCount: "Estrellas",
            .menuTodayReady: "Puzle de hoy listo",
            .menuTodayCompleted: "Completado hoy",

            .tutSkip: "Omitir",
            .tutStep1Title: "1. TOCAR Y ARRASTRAR",
            .tutStep1Desc: "El punto blanco es un anclaje fijo. Arrastra el punto cian brillante a la casilla objetivo resaltada.",
            .tutStep1DragHere: "Casilla Objetivo",
            .tutStep1Target: "OBJETIVO",
            .tutStep2Title: "2. RESONANCIA SENSORIAL",
            .tutStep2Desc: "Escucha el tono y siente la vibración. ¡Más cerca de la meta = pulso más nítido y tono más alto!",
            .tutStep3Title: "3. DEDUCIR REGLAS OCULTAS",
            .tutStep3Desc: "Cada puzle oculta una regla de simetría o alineación. Alinea los 3 puntos cian en línea recta.",
            .tutTipAudio: "Activa el audio y sujeta el móvil para sentir la háptica",
            .tutExcellent: "¡EXCELENTE!",
            .tutStepSuccessDesc: "Sentiste la retroalimentación de resonancia. ¡Listo para el siguiente paso!",
            .tutAllDoneDesc: "¡Has dominado la mecánica de Echo Grid! Comienza tu viaje de deducción.",
            .tutNextStep: "SIGUIENTE PASO",
            .tutStartPlaying: "EMPEZAR A JUGAR",
            .tutResonanceBar: "Alineación de Resonancia",

            .gameLevel: "NIVEL",
            .gameMoves: "MOVIMIENTOS:",
            .gamePar: "Par",
            .gameTime: "Tiempo:",
            .gameNewRecord: "✨ ¡NUEVO RÉCORD! ✨",
            .gameResonanceAligned: "RESONANCIA ALINEADA",
            .gameNextLevel: "SIGUIENTE NIVEL",
            .gameReplay: "Reintentar",
            .gameSelectLevelBtn: "Niveles",

            .dailyTitle: "DESAFÍO DIARIO",
            .dailyStreak: "RACHA",
            .dailyHint: "PISTA",
            .dailyShareTitle: "HUELLA DE RESONANCIA",
            .dailyShareBtn: "Compartir con Amigos",
            .dailyCopyTextBtn: "Copiar Texto de Resultado",
            .dailyCopiedAlertTitle: "Copiado al portapapeles",
            .dailyCopiedAlertMsg: "Resumen copiado para compartir.",

            .calTitle: "CALIBRACIÓN HÁPTICA",
            .calSubtitle: "Ajustar Sensibilidad Táctil",
            .calDesc: "Calibra la intensidad del pulso según tu dispositivo y funda.",
            .calTestPulse: "Probar Pulso",
            .calSaveApply: "GUARDAR Y APLICAR",
            .calDelicate: "Delicado (0.5x)",
            .calGentle: "Suave (0.75x)",
            .calStandard: "Estándar (1.0x)",
            .calFirm: "Firme (1.25x)",
            .calIntense: "Intenso (1.5x)",

            .setHeader: "AJUSTES",
            .setLanguage: "IDIOMA / LANGUAGE",
            .setSensory: "PREFERENCIAS SENSORIALES",
            .setHaptics: "Retroalimentación Háptica",
            .setAudio: "Tonos Armónicos",
            .setHighContrast: "Modo Alto Contraste",
            .setMode: "MODO DE EXPERIENCIA",
            .setProgressData: "DATOS DE PROGRESO",
            .setResetAll: "Restablecer Progreso",
            .setResetAlertTitle: "¿Restablecer progreso?",
            .setResetAlertMsg: "Esto bloqueará todos los niveles excepto el Nivel 1.",
            .setCancel: "Cancelar",
            .setReset: "Restablecer",

            .statsHeader: "ESTADÍSTICAS",
            .statsCurrentStreak: "RACHA ACTUAL",
            .statsBestStreak: "Mejor Racha Histórica:",
            .statsTotalStars: "Estrellas Totales",
            .statsCuratedCleared: "Niveles Superados",
            .statsDailiesCleared: "Desafíos Diarios",
            .statsClearRate: "Tasa de Victoria",
            .statsDistribution: "DISTRIBUCIÓN DE ESTRELLAS"
        ],

        .french: [
            .appTitle: "ECHO GRID",
            .appTagline: "PUZZLE DE DÉDUCTION SENSORIELLE",
            .menuContinue: "CONTINUER",
            .menuDailyChallenge: "DÉFI QUOTIDIEN",
            .menuSelectLevel: "NIVEAUX",
            .menuHowToPlay: "COMMENT JOUER",
            .menuStatistics: "STATISTIQUES",
            .menuHapticCalibration: "CALIBRAGE HAPTIQUE",
            .menuSettings: "RÉGLAGES",
            .menuLevelsCleared: "Réussis",
            .menuStarsCount: "Étoiles",
            .menuTodayReady: "Défi du jour prêt",
            .menuTodayCompleted: "Terminé aujourd'hui",

            .tutSkip: "Passer",
            .tutStep1Title: "1. TOUCHER ET GLISSER",
            .tutStep1Desc: "Le point blanc est un ancrage fixe. Faites glisser le point cyan vers la case cible surlignée.",
            .tutStep1DragHere: "Case Cible",
            .tutStep1Target: "CIBLE",
            .tutStep2Title: "2. RÉSONANCE SENSORIELLE",
            .tutStep2Desc: "Écoutez la tonalité et ressentez la vibration. Plus vous êtes proche = pulsation nette et note aiguë!",
            .tutStep3Title: "3. DÉDUIRE LES RÈGLES",
            .tutStep3Desc: "Chaque puzzle cache une règle de symétrie ou d'alignement. Alignez les 3 points cyans en ligne droite.",
            .tutTipAudio: "Activez le son et tenez le téléphone pour sentir l'haptique",
            .tutExcellent: "EXCELLENT!",
            .tutStepSuccessDesc: "Vous avez ressenti la résonance. Prêt pour la suite!",
            .tutAllDoneDesc: "Vous maîtrisez les bases d'Echo Grid! Commencez votre voyage.",
            .tutNextStep: "ÉTAPE SUIVANTE",
            .tutStartPlaying: "COMMENCER",
            .tutResonanceBar: "Alignement de Résonance",

            .gameLevel: "NIVEAU",
            .gameMoves: "COUPS:",
            .gamePar: "Par",
            .gameTime: "Temps:",
            .gameNewRecord: "✨ NOUVEAU RECORD! ✨",
            .gameResonanceAligned: "RÉSONANCE PARFAITE",
            .gameNextLevel: "NIVEAU SUIVANT",
            .gameReplay: "Rejouer",
            .gameSelectLevelBtn: "Niveaux",

            .dailyTitle: "DÉFI QUOTIDIEN",
            .dailyStreak: "SÉRIE",
            .dailyHint: "INDICE",
            .dailyShareTitle: "EMPREINTE DE RÉSONANCE",
            .dailyShareBtn: "Partager avec des amis",
            .dailyCopyTextBtn: "Copier le texte",
            .dailyCopiedAlertTitle: "Copié dans le presse-papiers",
            .dailyCopiedAlertMsg: "Résumé copié avec succès.",

            .calTitle: "CALIBRAGE HAPTIQUE",
            .calSubtitle: "Régler la Sensibilité",
            .calDesc: "Ajustez l'intensité des vibrations selon votre appareil et coque.",
            .calTestPulse: "Tester la vibration",
            .calSaveApply: "ENREGISTRER",
            .calDelicate: "Délicat (0.5x)",
            .calGentle: "Doux (0.75x)",
            .calStandard: "Standard (1.0x)",
            .calFirm: "Ferme (1.25x)",
            .calIntense: "Intense (1.5x)",

            .setHeader: "RÉGLAGES",
            .setLanguage: "LANGUE / LANGUAGE",
            .setSensory: "PRÉFÉRENCES SENSORIELLES",
            .setHaptics: "Retour Haptique",
            .setAudio: "Sons Harmoniques",
            .setHighContrast: "Contraste Élevé",
            .setMode: "MODE PAR DÉFAUT",
            .setProgressData: "PROGRESSION",
            .setResetAll: "Réinitialiser la progression",
            .setResetAlertTitle: "Tout réinitialiser?",
            .setResetAlertMsg: "Tous les niveaux sauf le Niveau 1 seront reverrouillés.",
            .setCancel: "Annuler",
            .setReset: "Réinitialiser",

            .statsHeader: "STATISTIQUES JOUEUR",
            .statsCurrentStreak: "SÉRIE ACTUELLE",
            .statsBestStreak: "Meilleure Série:",
            .statsTotalStars: "Total d'Étoiles",
            .statsCuratedCleared: "Niveaux Réussis",
            .statsDailiesCleared: "Défis Quotidiens",
            .statsClearRate: "Taux de Réussite",
            .statsDistribution: "RÉPARTITION DES ÉTOILES"
        ],

        .german: [
            .appTitle: "ECHO GRID",
            .appTagline: "SENSORISCHES DEDUKTIONSRÄTSEL",
            .menuContinue: "WEITERSPIELEN",
            .menuDailyChallenge: "TÄGLICHE HERAUSFORDERUNG",
            .menuSelectLevel: "LEVELAUSWAHL",
            .menuHowToPlay: "ANLEITUNG",
            .menuStatistics: "STATISTIKEN",
            .menuHapticCalibration: "HAPTIK-KALIBRIERUNG",
            .menuSettings: "EINSTELLUNGEN",
            .menuLevelsCleared: "Gelöst",
            .menuStarsCount: "Sterne",
            .menuTodayReady: "Heutiges Rätsel bereit",
            .menuTodayCompleted: "Heute abgeschlossen",

            .tutSkip: "Überspringen",
            .tutStep1Title: "1. BERÜHREN & ZIEHEN",
            .tutStep1Desc: "Der weiße Punkt ist ein fester Anker. Ziehe den leuchtenden cyanfarbenen Punkt auf das Zielfeld.",
            .tutStep1DragHere: "Zielfeld",
            .tutStep1Target: "ZIEL",
            .tutStep2Title: "2. SENSORISCHE RESONANZ",
            .tutStep2Desc: "Höre den Ton und spüre die Vibration. Näher am Ziel = präziserer Doppelimpuls und höherer Ton!",
            .tutStep3Title: "3. VERSTECKTE REGELN ERKENNEN",
            .tutStep3Desc: "Jedes Rätsel birgt eine Regel (Symmetrie oder Ausrichtung). Bringe alle 3 Punkte in eine gerade Linie.",
            .tutTipAudio: "Ton einschalten und Gerät festhalten für Haptik",
            .tutExcellent: "AUSGEZEICHNET!",
            .tutStepSuccessDesc: "Du hast die Resonanz gespürt. Bereit für den nächsten Schritt!",
            .tutAllDoneDesc: "Du hast die Grundlagen von Echo Grid gemeistert!",
            .tutNextStep: "NÄCHSTER SCHRITT",
            .tutStartPlaying: "JETZT SPIELEN",
            .tutResonanceBar: "Resonanzausrichtung",

            .gameLevel: "LEVEL",
            .gameMoves: "ZÜGE:",
            .gamePar: "Par",
            .gameTime: "Zeit:",
            .gameNewRecord: "✨ NEUER REKORD! ✨",
            .gameResonanceAligned: "RESONANZ AUSGERICHTET",
            .gameNextLevel: "NÄCHSTES LEVEL",
            .gameReplay: "Wiederholen",
            .gameSelectLevelBtn: "Levels",

            .dailyTitle: "TÄGLICHE HERAUSFORDERUNG",
            .dailyStreak: "SERIE",
            .dailyHint: "TIPP",
            .dailyShareTitle: "RESONANZ-FINGERABDRUCK",
            .dailyShareBtn: "Mit Freunden teilen",
            .dailyCopyTextBtn: "Ergebnis kopieren",
            .dailyCopiedAlertTitle: "In Zwischenablage kopiert",
            .dailyCopiedAlertMsg: "Zusammenfassung wurde kopiert.",

            .calTitle: "HAPTIK-KALIBRIERUNG",
            .calSubtitle: "Taktile Sensibilität einstellen",
            .calDesc: "Passe die Vibrationsintensität an dein Gerät an.",
            .calTestPulse: "Impuls testen",
            .calSaveApply: "SPEICHERN",
            .calDelicate: "Zart (0.5x)",
            .calGentle: "Sanft (0.75x)",
            .calStandard: "Standard (1.0x)",
            .calFirm: "Kräftig (1.25x)",
            .calIntense: "Intensiv (1.5x)",

            .setHeader: "EINSTELLUNGEN",
            .setLanguage: "SPRACHE / LANGUAGE",
            .setSensory: "SENSORISCHE EINSTELLUNGEN",
            .setHaptics: "Haptisches Feedback",
            .setAudio: "Harmonische Töne",
            .setHighContrast: "Hoher Kontrast",
            .setMode: "STANDARD-MODUS",
            .setProgressData: "FORTSCHRITT",
            .setResetAll: "Fortschritt zurücksetzen",
            .setResetAlertTitle: "Wirklich zurücksetzen?",
            .setResetAlertMsg: "Alle Level außer Level 1 werden gesperrt.",
            .setCancel: "Abbrechen",
            .setReset: "Zurücksetzen",

            .statsHeader: "SPIELER-STATISTIK",
            .statsCurrentStreak: "AKTUELLE TAGES-SERIE",
            .statsBestStreak: "Beste Serie aller Zeiten:",
            .statsTotalStars: "Gesamtsterne",
            .statsCuratedCleared: "Levels abgeschlossen",
            .statsDailiesCleared: "Tagesrätsel gelöst",
            .statsClearRate: "Abschlussquote",
            .statsDistribution: "STERN-VERTEILUNG"
        ],

        .chineseSimplified: [
            .appTitle: "ECHO GRID",
            .appTagline: "触觉与音律演绎解谜",
            .menuContinue: "继续游戏",
            .menuDailyChallenge: "每日挑战",
            .menuSelectLevel: "关卡选择",
            .menuHowToPlay: "玩法指南",
            .menuStatistics: "成就统计",
            .menuHapticCalibration: "触觉校准",
            .menuSettings: "系统设置",
            .menuLevelsCleared: "已通关",
            .menuStarsCount: "星星",
            .menuTodayReady: "今日谜题已准备",
            .menuTodayCompleted: "今日已完成",

            .tutSkip: "跳过",
            .tutStep1Title: "1. 触控与拖动",
            .tutStep1Desc: "左侧白点为固定锚点。拖拽发光的青色圆点至右侧高亮目标方格中。",
            .tutStep1DragHere: "目标方格",
            .tutStep1Target: "目标",
            .tutStep2Title: "2. 感官共鸣",
            .tutStep2Desc: "倾听音调并感受震动反馈。越接近目标 = 震动越清脆且音调越高！",
            .tutStep3Title: "3. 推理隐藏规律",
            .tutStep3Desc: "每个谜题都隐藏着对称或线性共振规则。将3个青色圆点排成一条直线。",
            .tutTipAudio: "开启音频并握紧手机以感受触感震动",
            .tutExcellent: "太棒了！",
            .tutStepSuccessDesc: "你已敏锐感知到共鸣反馈。准备进入下一步！",
            .tutAllDoneDesc: "你已完全掌握 Echo Grid 的玩法！开启你的推理之旅。",
            .tutNextStep: "下一步",
            .tutStartPlaying: "开始游戏",
            .tutResonanceBar: "共鸣同频度",

            .gameLevel: "关卡",
            .gameMoves: "步数:",
            .gamePar: "目标",
            .gameTime: "用时:",
            .gameNewRecord: "✨ 刷新最佳纪录！ ✨",
            .gameResonanceAligned: "共鸣已锁定",
            .gameNextLevel: "下一关",
            .gameReplay: "重玩",
            .gameSelectLevelBtn: "关卡列表",

            .dailyTitle: "每日挑战",
            .dailyStreak: "连胜天数",
            .dailyHint: "提示",
            .dailyShareTitle: "共鸣指纹",
            .dailyShareBtn: "分享给好友",
            .dailyCopyTextBtn: "复制战绩文本",
            .dailyCopiedAlertTitle: "已复制到剪贴板",
            .dailyCopiedAlertMsg: "战绩摘要已复制。",

            .calTitle: "触觉强度校准",
            .calSubtitle: "调节触感反馈灵敏度",
            .calDesc: "根据设备型号及保护壳校准震动强度。",
            .calTestPulse: "测试脉冲震动",
            .calSaveApply: "保存并应用",
            .calDelicate: "细腻 (0.5x)",
            .calGentle: "柔和 (0.75x)",
            .calStandard: "标准 (1.0x)",
            .calFirm: "清晰 (1.25x)",
            .calIntense: "强烈 (1.5x)",

            .setHeader: "系统设置",
            .setLanguage: "语言 / LANGUAGE",
            .setSensory: "感官偏好",
            .setHaptics: "触觉震动反馈",
            .setAudio: "和声音效",
            .setHighContrast: "高对比度模式",
            .setMode: "默认体验模式",
            .setProgressData: "存档数据",
            .setResetAll: "重置所有关卡进度",
            .setResetAlertTitle: "重置所有进度？",
            .setResetAlertMsg: "除第1关外所有关卡将重新锁定，清空星数记录。",
            .setCancel: "取消",
            .setReset: "重置",

            .statsHeader: "玩家数据统计",
            .statsCurrentStreak: "当前每日连胜",
            .statsBestStreak: "最高连胜纪录:",
            .statsTotalStars: "累计获得星星",
            .statsCuratedCleared: "主线关卡通关数",
            .statsDailiesCleared: "每日挑战通关数",
            .statsClearRate: "通关率",
            .statsDistribution: "星级分布"
        ]
    ]
}
