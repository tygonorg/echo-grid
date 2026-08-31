//
//  ResonanceFingerprintGenerator.swift
//  Echo Grid
//

import UIKit
import SwiftUI

public struct ResonanceFingerprintGenerator {

    /// Formats a clean, spoiler-free text string for social sharing
    public static func makeShareText(
        title: String,
        moves: Int,
        parMoves: Int,
        stars: Int,
        timeSec: Double
    ) -> String {
        let starsEmoji = String(repeating: "⭐️", count: stars)
        let waveformSymbols = makeWaveformGlyph(moves: moves, par: parMoves)

        return """
        Echo Grid — \(title)
        \(starsEmoji)
        🧩 Moves: \(moves) (Par \(parMoves))
        ⏱️ Time: \(String(format: "%.1fs", timeSec))
        〰️ Fingerprint: \(waveformSymbols)

        Can you feel the hidden rule?
        #EchoGrid #iOSGame
        """
    }

    private static func makeWaveformGlyph(moves: Int, par: Int) -> String {
        let bars = [" ▂", "▃▄", "▅▆", "▇█"]
        if moves <= par {
            return "▅▇██▇▅"
        } else if moves <= par + 2 {
            return "▃▅▆▅▃"
        } else {
            return " ▂▃▂ "
        }
    }

    /// Renders a UIImage card representing the user's tactile solve fingerprint
    @MainActor
    public static func generateCardImage(
        title: String,
        moves: Int,
        parMoves: Int,
        stars: Int,
        timeSec: Double
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400))

        return renderer.image { ctx in
            let rect = CGRect(x: 0, y: 0, width: 400, height: 400)

            // Background
            let bgColor = UIColor(white: 0.08, alpha: 1.0)
            bgColor.setFill()
            ctx.cgContext.fill(rect)

            // Outer Card Border
            let cardRect = rect.insetBy(dx: 16, dy: 16)
            let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 20)
            UIColor(white: 0.16, alpha: 1.0).setFill()
            cardPath.fill()
            UIColor.cyan.withAlphaComponent(0.4).setStroke()
            cardPath.lineWidth = 2
            cardPath.stroke()

            // Header Title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .black),
                .foregroundColor: UIColor.white
            ]
            let titleText = "ECHO GRID"
            titleText.draw(at: CGPoint(x: 36, y: 36), withAttributes: titleAttributes)

            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 12, weight: .bold),
                .foregroundColor: UIColor.cyan
            ]
            title.draw(at: CGPoint(x: 36, y: 62), withAttributes: subtitleAttributes)

            // Draw Waveform Graphic
            let waveCenterY: CGFloat = 200
            let wavePath = UIBezierPath()
            wavePath.move(to: CGPoint(x: 40, y: waveCenterY))

            let wavePoints = 80
            for i in 0...wavePoints {
                let x = 40.0 + (Double(i) / Double(wavePoints)) * 320.0
                let progress = Double(i) / Double(wavePoints)
                let envelope = sin(progress * .pi)
                let freq = Double(stars * 3)
                let y = waveCenterY + sin(progress * .pi * freq) * 45.0 * envelope
                wavePath.addLine(to: CGPoint(x: x, y: y))
            }

            UIColor.cyan.setStroke()
            wavePath.lineWidth = 3
            wavePath.stroke()

            // Draw Stars
            var starText = ""
            for _ in 0..<stars { starText += "★ " }
            let starAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22),
                .foregroundColor: UIColor.systemYellow
            ]
            starText.draw(at: CGPoint(x: 36, y: 280), withAttributes: starAttributes)

            // Draw Stats
            let statsText = "MOVES: \(moves)/\(parMoves)  |  TIME: \(String(format: "%.1fs", timeSec))"
            let statsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 13, weight: .semibold),
                .foregroundColor: UIColor.lightGray
            ]
            statsText.draw(at: CGPoint(x: 36, y: 320), withAttributes: statsAttributes)

            // Footer
            let footerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 10, weight: .regular),
                .foregroundColor: UIColor.darkGray
            ]
            "DEDUCTION THROUGH SENSATION".draw(at: CGPoint(x: 36, y: 350), withAttributes: footerAttributes)
        }
    }
}
