//
//  ShareFingerprintSheetView.swift
//  Echo Grid
//

import SwiftUI
import UIKit

public struct ShareFingerprintSheetView: View {
    @ObservedObject private var l10n = LocalizationManager.shared
    let title: String
    let moves: Int
    let parMoves: Int
    let stars: Int
    let timeSec: Double
    let onDismiss: () -> Void

    @State private var generatedImage: UIImage?
    @State private var showCopiedNotification: Bool = false

    public init(
        title: String,
        moves: Int,
        parMoves: Int,
        stars: Int,
        timeSec: Double,
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.moves = moves
        self.parMoves = parMoves
        self.stars = stars
        self.timeSec = timeSec
        self.onDismiss = onDismiss
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                Color(white: 0.08)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text(l10n.text(.dailyShareTitle))
                        .font(.system(size: 16, weight: .black, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(.white)
                        .padding(.top, 16)

                    // Image Card Preview
                    if let img = generatedImage {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 320, maxHeight: 320)
                            .cornerRadius(16)
                            .shadow(color: Color.cyan.opacity(0.3), radius: 12)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(white: 0.15))
                            .frame(width: 300, height: 300)
                            .overlay(ProgressView())
                    }

                    Spacer()

                    // Share Buttons
                    VStack(spacing: 12) {
                        Button {
                            shareToSystem()
                        } label: {
                            Label(l10n.text(.dailyShareBtn), systemImage: "square.and.arrow.up.fill")
                                .font(.system(size: 15, weight: .bold, design: .monospaced))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.cyan)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }

                        Button {
                            let text = ResonanceFingerprintGenerator.makeShareText(
                                title: title,
                                moves: moves,
                                parMoves: parMoves,
                                stars: stars,
                                timeSec: timeSec
                            )
                            UIPasteboard.general.string = text
                            showCopiedNotification = true
                        } label: {
                            Label(l10n.text(.dailyCopyTextBtn), systemImage: "doc.on.doc")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(white: 0.18))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        onDismiss()
                    }
                }
            }
            .onAppear {
                generateImage()
            }
            .alert(l10n.text(.dailyCopiedAlertTitle), isPresented: $showCopiedNotification) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(l10n.text(.dailyCopiedAlertMsg))
            }
        }
    }

    private func generateImage() {
        generatedImage = ResonanceFingerprintGenerator.generateCardImage(
            title: title,
            moves: moves,
            parMoves: parMoves,
            stars: stars,
            timeSec: timeSec
        )
    }

    private func shareToSystem() {
        guard let img = generatedImage else { return }
        let text = ResonanceFingerprintGenerator.makeShareText(
            title: title,
            moves: moves,
            parMoves: parMoves,
            stars: stars,
            timeSec: timeSec
        )

        let activityVC = UIActivityViewController(activityItems: [img, text], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            var topVC = rootVC
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            topVC.present(activityVC, animated: true)
        }
    }
}
