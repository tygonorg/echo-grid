//
//  SessionSummaryView.swift
//  Echo Grid
//

import SwiftUI

public struct SessionSummaryView: View {
    @ObservedObject var controller: GameplaySessionController
    @Environment(\.dismiss) private var dismiss

    @State private var participantId: String = ""
    @State private var hasPhoneCase: Bool = true
    @State private var ruleDescription: String = ""
    @State private var ruleCorrectness: String = "correct"
    @State private var mostHelpfulFeedback: String = "haptic"
    @State private var confidenceScore: Int = 4
    @State private var hadAhaMoment: Bool = true
    @State private var notes: String = ""
    @State private var showCopiedAlert: Bool = false

    public init(controller: GameplaySessionController) {
        self.controller = controller
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Banner
                    VStack(spacing: 6) {
                        Image(systemName: controller.isSolved ? "checkmark.seal.fill" : "chart.bar.doc.horizontal")
                            .font(.system(size: 44))
                            .foregroundColor(controller.isSolved ? .green : .orange)
                        Text(controller.isSolved ? "PUZZLE RESOLVED" : "SESSION TELEMETRY")
                            .font(.title2.bold())
                        Text("Validation Spike Session Report")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)

                    // Quantitative Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("QUANTITATIVE METRICS")
                            .font(.caption.bold())
                            .foregroundColor(.gray)

                        HStack(spacing: 12) {
                            SummaryCard(
                                title: "Solve Time",
                                value: String(format: "%.1fs", controller.logger.currentRecord.durationSeconds),
                                icon: "stopwatch"
                            )
                            SummaryCard(
                                title: "Total Moves",
                                value: "\(controller.logger.currentRecord.totalMoves)",
                                icon: "arrow.up.and.down.and.arrow.left.and.right"
                            )
                        }

                        HStack(spacing: 12) {
                            SummaryCard(
                                title: "Oscillations",
                                value: "\(controller.logger.currentRecord.oscillationCount)",
                                icon: "waveform.path.ecg"
                            )
                            SummaryCard(
                                title: "Trial/Error Ratio",
                                value: String(format: "%.2fx", controller.logger.currentRecord.trialAndErrorRatio),
                                icon: "gauge.medium"
                            )
                        }
                    }
                    .padding()
                    .background(Color(white: 0.12))
                    .cornerRadius(12)

                    // Moderator Post-Test Questionnaire
                    VStack(alignment: .leading, spacing: 14) {
                        Text("MODERATOR INTERVIEW ENTRY")
                            .font(.caption.bold())
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Participant ID:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("e.g. P-01", text: $participantId)
                                .textFieldStyle(.roundedBorder)
                        }

                        Toggle("Device Has Phone Case", isOn: $hasPhoneCase)
                            .font(.subheadline)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Rule Described by Participant (Verbatim):")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("What rule did participant state?", text: $ruleDescription, axis: .vertical)
                                .lineLimit(3...5)
                                .textFieldStyle(.roundedBorder)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Rule Evaluation:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("Correctness", selection: $ruleCorrectness) {
                                Text("Correct").tag("correct")
                                Text("Partially Correct").tag("partially_correct")
                                Text("Incorrect").tag("incorrect")
                            }
                            .pickerStyle(.segmented)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Most Helpful Feedback Channel:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("Feedback", selection: $mostHelpfulFeedback) {
                                Text("Haptic").tag("haptic")
                                Text("Visual").tag("visual")
                                Text("Audio").tag("audio")
                                Text("None").tag("none")
                            }
                            .pickerStyle(.segmented)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Confidence Score (1-5):")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(confidenceScore)/5")
                                    .font(.caption.bold())
                            }
                            Stepper("", value: $confidenceScore, in: 1...5)
                                .labelsHidden()
                        }

                        Toggle("Reported True 'Aha!' Moment", isOn: $hadAhaMoment)
                            .font(.subheadline)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Observer Notes:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Notable participant behaviors / quotes...", text: $notes, axis: .vertical)
                                .lineLimit(2...4)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .padding()
                    .background(Color(white: 0.12))
                    .cornerRadius(12)

                    // Action Buttons
                    VStack(spacing: 12) {
                        Button {
                            saveInterviewData()
                            let jsonString = controller.logger.exportJSON()
                            UIPasteboard.general.string = jsonString
                            showCopiedAlert = true
                        } label: {
                            Label("Copy Telemetry JSON", systemImage: "doc.on.doc.fill")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.cyan)
                                .foregroundColor(.black)
                                .font(.headline)
                                .cornerRadius(10)
                        }

                        Button {
                            saveInterviewData()
                            controller.resetSession(
                                participantId: participantId.isEmpty ? "P-01" : participantId,
                                hasPhoneCase: hasPhoneCase
                            )
                            dismiss()
                        } label: {
                            Label("Start Next Participant", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(white: 0.2))
                                .foregroundColor(.white)
                                .font(.headline)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Session Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        saveInterviewData()
                        dismiss()
                    }
                }
            }
            .onAppear {
                self.participantId = controller.logger.currentRecord.participantId
                self.hasPhoneCase = controller.logger.currentRecord.hasPhoneCase
            }
            .alert("Copied to Clipboard", isPresented: $showCopiedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Session telemetry JSON has been copied. You can paste it into the Playtest Results Template.")
            }
        }
    }

    private func saveInterviewData() {
        var interview = PostTestInterviewRecord()
        interview.ruleDescribedByParticipant = ruleDescription
        interview.ruleCorrectness = ruleCorrectness
        interview.mostHelpfulFeedback = mostHelpfulFeedback
        interview.confidenceScore = confidenceScore
        interview.hadAhaMoment = hadAhaMoment
        interview.notes = notes

        controller.logger.currentRecord.participantId = participantId.isEmpty ? "P-01" : participantId
        controller.logger.currentRecord.hasPhoneCase = hasPhoneCase
        controller.logger.currentRecord.postTestInterview = interview
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.cyan)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(white: 0.16))
        .cornerRadius(8)
    }
}
