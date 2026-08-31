//
//  GameplaySessionController.swift
//  Echo Grid
//

import SwiftUI
import Combine

public enum GameSessionState: Equatable, Sendable {
    case idle
    case dragging(nodeId: String)
    case evaluating
    case solved
}

@MainActor
public final class GameplaySessionController: ObservableObject {
    @Published public var currentLevel: LevelDefinition
    @Published public var board: BoardState
    @Published public var feedbackMode: FeedbackMode = .fullSensory
    @Published public var sessionState: GameSessionState = .idle
    @Published public var latestResonanceScore: Double = 0.0
    @Published public var isSolved: Bool = false
    @Published public var isDebugOverlayVisible: Bool = false
    @Published public var isClearModalPresented: Bool = false
    @Published public var isSummaryPresented: Bool = false
    @Published public var movesCount: Int = 0
    @Published public var starsEarned: Int = 0
    @Published public var isNewRecord: Bool = false
    @Published public var sessionElapsedSeconds: Double = 0.0

    // Telemetry & Logger
    public let logger: SessionLogger

    // Evaluator & Feedback Orchestrators
    private var evaluator: ResonanceEvaluator
    private let haptics = HapticFeedbackOrchestrator.shared
    private let audio = AudioSynthesizerOrchestrator.shared

    // Move history tracking for oscillation calculation
    private var moveHistory: [(nodeId: String, from: CellPosition, to: CellPosition)] = []
    private var sessionTimer: AnyCancellable?
    private var sessionStartDate: Date = Date()

    public init(
        level: LevelDefinition? = nil,
        feedbackMode: FeedbackMode = .fullSensory
    ) {
        let resolvedLevel = level ?? LevelRepository.shared.allLevels[0]
        self.currentLevel = resolvedLevel
        self.feedbackMode = feedbackMode
        self.board = resolvedLevel.initialBoard
        self.evaluator = ResonanceEvaluator(evaluators: resolvedLevel.ruleEvaluators)
        self.logger = SessionLogger(condition: feedbackMode)

        loadLevel(resolvedLevel)
    }

    public func loadLevel(_ level: LevelDefinition) {
        self.currentLevel = level
        self.board = level.initialBoard
        self.evaluator = ResonanceEvaluator(evaluators: level.ruleEvaluators)
        self.sessionState = .idle
        self.isSolved = false
        self.isClearModalPresented = false
        self.isSummaryPresented = false
        self.movesCount = 0
        self.starsEarned = 0
        self.isNewRecord = false
        self.sessionElapsedSeconds = 0.0
        self.moveHistory.removeAll()

        self.sessionStartDate = Date()
        startTimer()

        logger.startNewSession(
            participantId: "Level-\(level.id)",
            condition: feedbackMode,
            hasPhoneCase: true
        )

        let initialResult = evaluator.evaluate(board: board)
        self.latestResonanceScore = initialResult.resonanceScore
    }

    public func resetCurrentLevel() {
        loadLevel(currentLevel)
    }

    public func resetSession(participantId: String = "P-01", hasPhoneCase: Bool = true) {
        self.board = currentLevel.initialBoard
        self.sessionState = .idle
        self.isSolved = false
        self.isClearModalPresented = false
        self.isSummaryPresented = false
        self.movesCount = 0
        self.starsEarned = 0
        self.isNewRecord = false
        self.sessionElapsedSeconds = 0.0
        self.moveHistory.removeAll()

        self.sessionStartDate = Date()
        startTimer()

        logger.startNewSession(
            participantId: participantId,
            condition: feedbackMode,
            hasPhoneCase: hasPhoneCase
        )

        let initialResult = evaluator.evaluate(board: board)
        self.latestResonanceScore = initialResult.resonanceScore
    }

    private func startTimer() {
        sessionTimer?.cancel()
        sessionTimer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, !self.isSolved else { return }
                self.sessionElapsedSeconds = Date().timeIntervalSince(self.sessionStartDate)
            }
    }

    public func switchFeedbackMode(_ mode: FeedbackMode) {
        self.feedbackMode = mode
        resetCurrentLevel()
    }

    public func startDragging(nodeId: String) {
        guard !isSolved else { return }
        sessionState = .dragging(nodeId: nodeId)
    }

    public func moveNode(nodeId: String, to targetPosition: CellPosition) {
        guard !isSolved else { return }
        sessionState = .evaluating

        guard let nodeIndex = board.nodes.firstIndex(where: { $0.id == nodeId }) else {
            sessionState = .idle
            return
        }

        let originPosition = board.nodes[nodeIndex].position

        // If target is unchanged, return to idle
        if originPosition == targetPosition {
            sessionState = .idle
            return
        }

        // Validate target position (bounds check and occupancy check)
        guard board.isValidPosition(targetPosition), !board.isOccupied(at: targetPosition) else {
            haptics.playFar()
            logger.registerMove(isInvalid: true, isOscillation: false)
            sessionState = .idle
            return
        }

        // Check for oscillation
        var isOscillation = false
        if let lastMove = moveHistory.last,
           lastMove.nodeId == nodeId && lastMove.from == targetPosition && lastMove.to == originPosition {
            isOscillation = true
        }

        // Apply Move
        board.nodes[nodeIndex].position = targetPosition
        moveHistory.append((nodeId: nodeId, from: originPosition, to: targetPosition))
        movesCount += 1

        // Play tactile snap
        haptics.playSnap()

        // Evaluate new board state
        let previousScore = latestResonanceScore
        let evaluation = evaluator.evaluate(board: board)
        let newScore = evaluation.resonanceScore
        let nowSolved = evaluation.isSolved

        latestResonanceScore = newScore
        isSolved = nowSolved

        // Telemetry
        logger.registerMove(isInvalid: false, isOscillation: isOscillation)

        // Route feedback
        var hapticType = "snap"
        if nowSolved {
            hapticType = "solved"
            haptics.playSolved()
            if feedbackMode.hasAudio {
                audio.playSolvedChord()
            }
            sessionState = .solved
            sessionTimer?.cancel()

            // Record in Progress Manager
            let result = ProgressManager.shared.recordLevelClear(
                levelId: currentLevel.id,
                moves: movesCount,
                timeSec: sessionElapsedSeconds,
                parMoves: currentLevel.parMoves
            )
            self.starsEarned = result.stars
            self.isNewRecord = result.isNewBest

            logger.completeSession(solved: true, score: 1.0)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                self?.isClearModalPresented = true
            }
        } else {
            if newScore > previousScore {
                hapticType = "progress"
                haptics.playProgress()
            } else {
                hapticType = "far"
                haptics.playFar()
            }

            if feedbackMode.hasAudio {
                audio.playHarmonicTone(forScore: newScore)
            }
            sessionState = .idle
        }

        logger.recordEvent(
            type: "drag_drop",
            nodeId: nodeId,
            from: originPosition,
            to: targetPosition,
            score: newScore,
            haptic: hapticType
        )
    }
}
