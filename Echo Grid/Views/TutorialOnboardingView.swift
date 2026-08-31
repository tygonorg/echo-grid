//
//  TutorialOnboardingView.swift
//  Echo Grid
//

import SwiftUI

public struct TutorialOnboardingView: View {
    @ObservedObject private var l10n = LocalizationManager.shared
    let onFinish: () -> Void

    @State private var currentStepIndex: Int = 0
    @StateObject private var controller: GameplaySessionController
    @State private var showStepSuccess: Bool = false

    // Animated hand slide progress (0.0 to 1.0)
    @State private var swipeProgress: CGFloat = 0.0
    @State private var animationTimer: Timer?

    private var tutorialSteps: [TutorialStepData] {
        [
            TutorialStepData(
                stepNumber: 1,
                title: l10n.text(.tutStep1Title),
                instruction: l10n.text(.tutStep1Desc),
                board: BoardState(size: 5, nodes: [
                    NodeState(id: "S1", type: .source, position: CellPosition(row: 2, col: 0)),
                    NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 3))
                ]),
                rules: [VerticalSymmetryRule()],
                startPosition: CellPosition(row: 0, col: 3),
                targetPosition: CellPosition(row: 2, col: 4)
            ),
            TutorialStepData(
                stepNumber: 2,
                title: l10n.text(.tutStep2Title),
                instruction: l10n.text(.tutStep2Desc),
                board: BoardState(size: 5, nodes: [
                    NodeState(id: "S1", type: .source, position: CellPosition(row: 1, col: 1)),
                    NodeState(id: "S2", type: .source, position: CellPosition(row: 3, col: 0)),
                    NodeState(id: "M1", type: .receiver, position: CellPosition(row: 4, col: 2)),
                    NodeState(id: "M2", type: .receiver, position: CellPosition(row: 0, col: 4))
                ]),
                rules: [VerticalSymmetryRule()],
                startPosition: nil,
                targetPosition: nil
            ),
            TutorialStepData(
                stepNumber: 3,
                title: l10n.text(.tutStep3Title),
                instruction: l10n.text(.tutStep3Desc),
                board: BoardState(size: 5, nodes: [
                    NodeState(id: "M1", type: .receiver, position: CellPosition(row: 2, col: 0)),
                    NodeState(id: "M2", type: .receiver, position: CellPosition(row: 1, col: 2)),
                    NodeState(id: "M3", type: .receiver, position: CellPosition(row: 4, col: 4))
                ]),
                rules: [CollinearAlignmentRule()],
                startPosition: nil,
                targetPosition: nil
            )
        ]
    }

    public init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        let initialBoard = BoardState(size: 5, nodes: [
            NodeState(id: "S1", type: .source, position: CellPosition(row: 2, col: 0)),
            NodeState(id: "M1", type: .receiver, position: CellPosition(row: 0, col: 3))
        ])
        let lvl = LevelDefinition(
            id: 0,
            chapter: 0,
            chapterTitle: "Tutorial",
            title: LocalizationManager.shared.text(.tutStep1Title),
            subtitle: LocalizationManager.shared.text(.tutStep1Desc),
            parMoves: 1,
            parTimeSec: 30,
            initialBoard: initialBoard,
            ruleEvaluators: [VerticalSymmetryRule()]
        )
        _controller = StateObject(wrappedValue: GameplaySessionController(level: lvl))
    }

    private var currentStep: TutorialStepData {
        let steps = tutorialSteps
        return steps[min(currentStepIndex, steps.count - 1)]
    }

    public var body: some View {
        ZStack {
            Color(white: 0.07)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                // Top Step Progress Indicator
                HStack {
                    Button(l10n.text(.tutSkip)) {
                        completeTutorial()
                    }
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(.gray)

                    Spacer()

                    HStack(spacing: 8) {
                        ForEach(0..<tutorialSteps.count, id: \.self) { idx in
                            Capsule()
                                .fill(idx <= currentStepIndex ? Color.cyan : Color.white.opacity(0.2))
                                .frame(width: idx == currentStepIndex ? 24 : 8, height: 6)
                                .animation(.spring(), value: currentStepIndex)
                        }
                    }

                    Spacer()

                    Text("\(currentStepIndex + 1)/\(tutorialSteps.count)")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // Step Instructions Card
                VStack(spacing: 6) {
                    Text(currentStep.title)
                        .font(.system(size: 16, weight: .black, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(.white)

                    Text(currentStep.instruction)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color(white: 0.13))
                .cornerRadius(14)
                .padding(.horizontal, 20)

                Spacer(minLength: 0)

                // 5x5 Board with Exact Target Overlay & Animated Slide Gesture
                TutorialBoardContainerView(
                    controller: controller,
                    currentStep: currentStep,
                    swipeProgress: swipeProgress
                )
                .layoutPriority(1)

                Spacer(minLength: 0)

                // Resonance Feedback Bar
                VStack(spacing: 6) {
                    HStack {
                        Text(l10n.text(.tutResonanceBar))
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int(controller.latestResonanceScore * 100))%")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.1))
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.cyan, Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * CGFloat(controller.latestResonanceScore))
                                .animation(.easeOut(duration: 0.2), value: controller.latestResonanceScore)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.horizontal, 24)

                // Bottom Audio Tip
                HStack(spacing: 8) {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.cyan)
                    Text(l10n.text(.tutTipAudio))
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
            }

            // Step Solved Modal
            if showStepSuccess {
                ZStack {
                    Color.black.opacity(0.85)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.green)

                        Text(l10n.text(.tutExcellent))
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                            .foregroundColor(.white)

                        Text(currentStepIndex < tutorialSteps.count - 1
                             ? l10n.text(.tutStepSuccessDesc)
                             : l10n.text(.tutAllDoneDesc))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        Button {
                            if currentStepIndex < tutorialSteps.count - 1 {
                                nextStep()
                            } else {
                                completeTutorial()
                            }
                        } label: {
                            Text(currentStepIndex < tutorialSteps.count - 1
                                 ? l10n.text(.tutNextStep)
                                 : l10n.text(.tutStartPlaying))
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.cyan)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(white: 0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 30)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            startSlideAnimation()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
        .onChange(of: controller.isSolved) { isSolved in
            if isSolved {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation {
                        showStepSuccess = true
                    }
                }
            }
        }
    }

    private func startSlideAnimation() {
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            Task { @MainActor in
                if self.swipeProgress < 1.0 {
                    self.swipeProgress += 0.02
                } else {
                    // Reset with brief pause
                    self.swipeProgress = 0.0
                }
            }
        }
    }

    private func nextStep() {
        showStepSuccess = false
        currentStepIndex += 1
        let nextData = tutorialSteps[currentStepIndex]
        let lvl = LevelDefinition(
            id: 0,
            chapter: 0,
            chapterTitle: "Tutorial",
            title: nextData.title,
            subtitle: nextData.instruction,
            parMoves: 2,
            parTimeSec: 30,
            initialBoard: nextData.board,
            ruleEvaluators: nextData.rules
        )
        controller.loadLevel(lvl)
        swipeProgress = 0.0
    }

    private func completeTutorial() {
        animationTimer?.invalidate()
        ProgressManager.shared.completeOnboarding()
        onFinish()
    }
}

// MARK: - Tutorial Board Container with Pixel-Perfect Coordinate Mapping

private struct TutorialBoardContainerView: View {
    @ObservedObject var controller: GameplaySessionController
    let currentStep: TutorialStepData
    let swipeProgress: CGFloat
    @ObservedObject private var l10n = LocalizationManager.shared

    private let gridSize: Int = 5

    var body: some View {
        GeometryReader { geometry in
            let sideLength = min(geometry.size.width, geometry.size.height) - 32
            let cellSize = sideLength / CGFloat(gridSize)

            ZStack {
                // The Base Game Board
                BoardGridView(controller: controller)

                // Exact Target Cell Highlight (Pixel-perfect on (row, col))
                if let target = currentStep.targetPosition, !controller.isSolved {
                    let targetCenter = CGPoint(
                        x: (CGFloat(target.col) + 0.5) * cellSize + 16,
                        y: (CGFloat(target.row) + 0.5) * cellSize + 16
                    )

                    // Glowing Target Box
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.cyan, style: StrokeStyle(lineWidth: 2.5, dash: [5, 4]))
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.cyan.opacity(0.18)))
                        .frame(width: cellSize * 0.88, height: cellSize * 0.88)
                        .position(targetCenter)
                        .overlay(
                            Text(l10n.text(.tutStep1Target))
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundColor(.cyan)
                                .padding(2)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(4)
                                .position(x: targetCenter.x, y: targetCenter.y - cellSize * 0.45)
                        )
                        .allowsHitTesting(false)
                }

                // Animated Hand Finger sliding from Start Node to Target Cell
                if let start = currentStep.startPosition,
                   let target = currentStep.targetPosition,
                   !controller.isSolved {

                    let startCenter = CGPoint(
                        x: (CGFloat(start.col) + 0.5) * cellSize + 16,
                        y: (CGFloat(start.row) + 0.5) * cellSize + 16
                    )
                    let targetCenter = CGPoint(
                        x: (CGFloat(target.col) + 0.5) * cellSize + 16,
                        y: (CGFloat(target.row) + 0.5) * cellSize + 16
                    )

                    // Interpolated Position along path
                    let currentHandPos = CGPoint(
                        x: startCenter.x + (targetCenter.x - startCenter.x) * swipeProgress,
                        y: startCenter.y + (targetCenter.y - startCenter.y) * swipeProgress
                    )

                    VStack(spacing: 2) {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.cyan)
                            .shadow(color: .cyan.opacity(0.8), radius: 8)

                        Text(l10n.text(.tutStep1DragHere))
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(4)
                    }
                    .position(currentHandPos)
                    .opacity(swipeProgress > 0.05 && swipeProgress < 0.95 ? 1.0 : 0.2)
                    .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

public struct TutorialStepData: Sendable {
    public let stepNumber: Int
    public let title: String
    public let instruction: String
    public let board: BoardState
    public let rules: [any RuleEvaluator]
    public let startPosition: CellPosition?
    public let targetPosition: CellPosition?

    public init(
        stepNumber: Int,
        title: String,
        instruction: String,
        board: BoardState,
        rules: [any RuleEvaluator],
        startPosition: CellPosition? = nil,
        targetPosition: CellPosition? = nil
    ) {
        self.stepNumber = stepNumber
        self.title = title
        self.instruction = instruction
        self.board = board
        self.rules = rules
        self.startPosition = startPosition
        self.targetPosition = targetPosition
    }
}
