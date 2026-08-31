//
//  LevelSelectView.swift
//  Echo Grid
//

import SwiftUI

public struct LevelSelectView: View {
    @ObservedObject private var progressManager = ProgressManager.shared
    let onSelectLevel: (LevelDefinition) -> Void
    let onBack: () -> Void

    private let repository = LevelRepository.shared
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    public init(onSelectLevel: @escaping (LevelDefinition) -> Void, onBack: @escaping () -> Void) {
        self.onSelectLevel = onSelectLevel
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            Color(white: 0.08)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Header Bar
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

                    Text("SELECT LEVEL")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.white)

                    Spacer()

                    // Total Stars Badge
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text("\(progressManager.totalStarsEarned)/45")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(white: 0.18))
                    .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 16)

                // Scrollable Chapters
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(1...3, id: \.self) { chapter in
                            ChapterSectionView(
                                chapterNumber: chapter,
                                levels: repository.levels(forChapter: chapter),
                                progressManager: progressManager,
                                onSelectLevel: onSelectLevel
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

private struct ChapterSectionView: View {
    let chapterNumber: Int
    let levels: [LevelDefinition]
    @ObservedObject var progressManager: ProgressManager
    let onSelectLevel: (LevelDefinition) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Chapter Title
            Text(chapterTitle(for: chapterNumber))
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)

            // Grid of Levels
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(levels) { level in
                    let record = progressManager.progress(for: level.id)
                    LevelCardView(
                        level: level,
                        progress: record,
                        onTap: {
                            if record.isUnlocked {
                                onSelectLevel(level)
                            }
                        }
                    )
                }
            }
        }
    }

    private func chapterTitle(for chapter: Int) -> String {
        switch chapter {
        case 1: return "CHAPTER 1: THE MIRROR"
        case 2: return "CHAPTER 2: HARMONICS & BARRIERS"
        case 3: return "CHAPTER 3: RESONANCE SYNTHESIS"
        default: return "CHAPTER \(chapter)"
        }
    }
}

private struct LevelCardView: View {
    let level: LevelDefinition
    let progress: LevelProgressRecord
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 6) {
                if progress.isUnlocked {
                    Text("\(level.id)")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundColor(.white)

                    Text(level.title)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                        .lineLimit(1)

                    // Stars
                    HStack(spacing: 2) {
                        ForEach(1...3, id: \.self) { s in
                            Image(systemName: s <= progress.starsEarned ? "star.fill" : "star")
                                .font(.system(size: 9))
                                .foregroundColor(s <= progress.starsEarned ? .yellow : Color(white: 0.3))
                        }
                    }
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(white: 0.35))
                        .padding(.vertical, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 84)
            .background(progress.isUnlocked ? Color(white: 0.14) : Color(white: 0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(progress.isCompleted ? Color.cyan.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .disabled(!progress.isUnlocked)
    }
}
