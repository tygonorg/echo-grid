//
//  PlayerStatsView.swift
//  Echo Grid
//

import SwiftUI

public struct PlayerStatsView: View {
    @ObservedObject private var progressManager = ProgressManager.shared
    @ObservedObject private var dailyManager = DailyChallengeManager.shared
    @ObservedObject private var l10n = LocalizationManager.shared
    let onBack: () -> Void

    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header
                HStack {
                    Button {
                        onBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(white: 0.18))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text(l10n.text(.statsHeader))
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Hero Streak Card
                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.orange)
                                Text("\(dailyManager.currentStreak)")
                                    .font(.system(size: 36, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                Text("DAYS")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.orange)
                            }

                            Text(l10n.text(.statsCurrentStreak))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.gray)

                            Divider().background(Color.white.opacity(0.1))

                            HStack {
                                Text(l10n.text(.statsBestStreak))
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(dailyManager.maxStreak) days")
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color(white: 0.13))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )

                        // 4-Card Performance Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(
                                icon: "star.fill",
                                iconColor: .yellow,
                                value: "\(progressManager.totalStarsEarned)/45",
                                label: l10n.text(.statsTotalStars)
                            )
                            StatCard(
                                icon: "checkmark.circle.fill",
                                iconColor: .green,
                                value: "\(progressManager.completedLevelsCount)/15",
                                label: l10n.text(.statsCuratedCleared)
                            )
                            StatCard(
                                icon: "calendar.badge.checkmark",
                                iconColor: .cyan,
                                value: "\(dailyManager.totalDailyCompleted)",
                                label: l10n.text(.statsDailiesCleared)
                            )
                            StatCard(
                                icon: "percent",
                                iconColor: .purple,
                                value: calculateWinRate(),
                                label: l10n.text(.statsClearRate)
                            )
                        }

                        // Star Distribution Card
                        VStack(alignment: .leading, spacing: 14) {
                            Text(l10n.text(.statsDistribution))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)

                            StarBarRow(stars: 3, count: countLevelsWithStars(3))
                            StarBarRow(stars: 2, count: countLevelsWithStars(2))
                            StarBarRow(stars: 1, count: countLevelsWithStars(1))
                        }
                        .padding()
                        .background(Color(white: 0.13))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private func calculateWinRate() -> String {
        let completed = progressManager.completedLevelsCount
        let percentage = Int((Double(completed) / 15.0) * 100)
        return "\(percentage)%"
    }

    private func countLevelsWithStars(_ stars: Int) -> Int {
        progressManager.progressMap.values.filter { $0.starsEarned == stars }.count
    }
}

private struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(white: 0.13))
        .cornerRadius(14)
    }
}

private struct StarBarRow: View {
    let stars: Int
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            Text("\(stars) ★")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.yellow)
                .frame(width: 32, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 12)

                    let fillWidth = 15 > 0 ? (CGFloat(count) / 15.0) * geo.size.width : 0
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.yellow.opacity(0.8))
                        .frame(width: max(fillWidth, count > 0 ? 8 : 0), height: 12)
                }
            }
            .frame(height: 12)

            Text("\(count)")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 24, alignment: .trailing)
        }
    }
}
