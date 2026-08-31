//
//  SessionLogger.swift
//  Echo Grid
//

import Foundation
import UIKit
import Combine
import SwiftUI

public struct SessionEventRecord: Codable, Sendable {
    public let timestampOffsetSec: Double
    public let type: String
    public let nodeId: String?
    public let fromPosition: CellPosition?
    public let toPosition: CellPosition?
    public let resonanceScore: Double
    public let hapticFeedbackTriggered: String?
}

public struct PostTestInterviewRecord: Codable, Sendable {
    public var ruleDescribedByParticipant: String = ""
    public var ruleCorrectness: String = "pending" // "correct", "partially_correct", "incorrect"
    public var mostHelpfulFeedback: String = "haptic" // "haptic", "visual", "audio", "none"
    public var confidenceScore: Int = 3 // 1 to 5
    public var hadAhaMoment: Bool = true
    public var notes: String = ""
}

public struct SessionTelemetryRecord: Codable, Sendable {
    public let sessionId: String
    public var participantId: String
    public let deviceModel: String
    public var hasPhoneCase: Bool
    public let conditionType: String
    public let startTime: Date
    public var endTime: Date?
    public var durationSeconds: Double
    public var totalMoves: Int
    public var invalidMoves: Int
    public var oscillationCount: Int
    public var trialAndErrorRatio: Double
    public var solved: Bool
    public var finalResonanceScore: Double
    public var events: [SessionEventRecord]
    public var postTestInterview: PostTestInterviewRecord
}

@MainActor
public final class SessionLogger: ObservableObject {
    @Published public var currentRecord: SessionTelemetryRecord
    private var sessionStartDate: Date

    public init(
        participantId: String = "P-01",
        condition: FeedbackMode = .hapticOnly,
        hasPhoneCase: Bool = true
    ) {
        let now = Date()
        self.sessionStartDate = now
        let device = UIDevice.current.model

        self.currentRecord = SessionTelemetryRecord(
            sessionId: UUID().uuidString,
            participantId: participantId,
            deviceModel: device,
            hasPhoneCase: hasPhoneCase,
            conditionType: condition == .hapticOnly ? "hapticOnly" : "fullSensory",
            startTime: now,
            endTime: nil,
            durationSeconds: 0.0,
            totalMoves: 0,
            invalidMoves: 0,
            oscillationCount: 0,
            trialAndErrorRatio: 0.0,
            solved: false,
            finalResonanceScore: 0.0,
            events: [],
            postTestInterview: PostTestInterviewRecord()
        )
    }

    public func startNewSession(participantId: String, condition: FeedbackMode, hasPhoneCase: Bool) {
        let now = Date()
        self.sessionStartDate = now
        self.currentRecord = SessionTelemetryRecord(
            sessionId: UUID().uuidString,
            participantId: participantId,
            deviceModel: UIDevice.current.model,
            hasPhoneCase: hasPhoneCase,
            conditionType: condition == .hapticOnly ? "hapticOnly" : "fullSensory",
            startTime: now,
            endTime: nil,
            durationSeconds: 0.0,
            totalMoves: 0,
            invalidMoves: 0,
            oscillationCount: 0,
            trialAndErrorRatio: 0.0,
            solved: false,
            finalResonanceScore: 0.0,
            events: [],
            postTestInterview: PostTestInterviewRecord()
        )

        recordEvent(type: "session_start", nodeId: nil, from: nil, to: nil, score: 0.0, haptic: nil)
    }

    public func recordEvent(
        type: String,
        nodeId: String?,
        from: CellPosition?,
        to: CellPosition?,
        score: Double,
        haptic: String?
    ) {
        let offset = Date().timeIntervalSince(sessionStartDate)
        let event = SessionEventRecord(
            timestampOffsetSec: (offset * 100).rounded() / 100,
            type: type,
            nodeId: nodeId,
            fromPosition: from,
            toPosition: to,
            resonanceScore: (score * 1000).rounded() / 1000,
            hapticFeedbackTriggered: haptic
        )
        currentRecord.events.append(event)
        currentRecord.finalResonanceScore = score
        currentRecord.durationSeconds = (offset * 10).rounded() / 10
    }

    public func registerMove(isInvalid: Bool, isOscillation: Bool) {
        if isInvalid {
            currentRecord.invalidMoves += 1
        } else {
            currentRecord.totalMoves += 1
        }

        if isOscillation {
            currentRecord.oscillationCount += 1
        }

        // 6 optimal moves for opening layout
        currentRecord.trialAndErrorRatio = Double(currentRecord.totalMoves) / 6.0
    }

    public func completeSession(solved: Bool, score: Double) {
        let now = Date()
        currentRecord.endTime = now
        currentRecord.durationSeconds = (now.timeIntervalSince(sessionStartDate) * 10).rounded() / 10
        currentRecord.solved = solved
        currentRecord.finalResonanceScore = score

        recordEvent(
            type: solved ? "solved" : "session_abort",
            nodeId: nil,
            from: nil,
            to: nil,
            score: score,
            haptic: solved ? "solved" : nil
        )
    }

    public func exportJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        do {
            let data = try encoder.encode(currentRecord)
            return String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            return "{\"error\": \"\(error.localizedDescription)\"}"
        }
    }
}
