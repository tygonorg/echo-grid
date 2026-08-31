//
//  EchoGridWidgetView.swift
//  Echo Grid
//

import SwiftUI

public struct EchoGridWidgetSmallView: View {
    let streak: Int
    let isTodayCompleted: Bool
    let dateString: String

    public init(streak: Int = 3, isTodayCompleted: Bool = false, dateString: String = "Today") {
        self.streak = streak
        self.isTodayCompleted = isTodayCompleted
        self.dateString = dateString
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)

            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Text("ECHO GRID")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.cyan)

                    Spacer()

                    Image(systemName: isTodayCompleted ? "checkmark.circle.fill" : "circle.dashed")
                        .foregroundColor(isTodayCompleted ? .green : .orange)
                        .font(.caption)
                }

                Spacer()

                // Flame & Streak Number
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)

                    Text("\(streak)")
                        .font(.system(size: 28, weight: .black, design: .monospaced))
                        .foregroundColor(.white)

                    Text("DAYS")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                }

                // Footer Status
                Text(isTodayCompleted ? "Daily Solved ✨" : "Daily Puzzle Ready 🧩")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isTodayCompleted ? .green : .white.opacity(0.8))
                    .lineLimit(1)
            }
            .padding(14)
        }
    }
}

public struct EchoGridWidgetMediumView: View {
    let streak: Int
    let isTodayCompleted: Bool
    let totalStars: Int
    let dateString: String

    public init(streak: Int = 3, isTodayCompleted: Bool = false, totalStars: Int = 24, dateString: String = "Today") {
        self.streak = streak
        self.isTodayCompleted = isTodayCompleted
        self.totalStars = totalStars
        self.dateString = dateString
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)

            HStack(spacing: 16) {
                // Left Column
                VStack(alignment: .leading, spacing: 8) {
                    Text("ECHO GRID DAILY")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.cyan)

                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)

                        Text("\(streak) DAYS")
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }

                    Text(isTodayCompleted ? "Today's Resonance Aligned ✨" : "Tap to Play Today's Puzzle 🧩")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isTodayCompleted ? .green : .white.opacity(0.8))
                }

                Spacer()

                // Right Column Miniature Dot Matrix
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Circle().fill(Color.white).frame(width: 8, height: 8)
                        Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                        Circle().fill(Color.cyan).frame(width: 8, height: 8)
                    }
                    HStack(spacing: 6) {
                        Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                        Circle().fill(Color.cyan).frame(width: 8, height: 8)
                        Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                    }
                    HStack(spacing: 6) {
                        Circle().fill(Color.cyan).frame(width: 8, height: 8)
                        Circle().fill(Color.white.opacity(0.3)).frame(width: 8, height: 8)
                        Circle().fill(Color.white).frame(width: 8, height: 8)
                    }
                }
                .padding(10)
                .background(Color(white: 0.14))
                .cornerRadius(12)
            }
            .padding(16)
        }
    }
}
