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

    /// Renders a 9:16 high-resolution vertical card for Instagram Stories, TikTok, and YouTube Shorts
    @MainActor
    public static func generateVerticalStoryCardImage(
        title: String,
        moves: Int,
        parMoves: Int,
        stars: Int,
        timeSec: Double
    ) -> UIImage {
        let width: CGFloat = 540
        let height: CGFloat = 960
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

        return renderer.image { ctx in
            let rect = CGRect(x: 0, y: 0, width: width, height: height)

            // Dark Gradient Background
            let colors = [UIColor(white: 0.05, alpha: 1.0).cgColor, UIColor(white: 0.12, alpha: 1.0).cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0]) {
                ctx.cgContext.drawLinearGradient(gradient, start: CGPoint(x: width / 2, y: 0), end: CGPoint(x: width / 2, y: height), options: [])
            }

            // Outer Card
            let cardRect = rect.insetBy(dx: 30, dy: 60)
            let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 28)
            UIColor(white: 0.14, alpha: 0.9).setFill()
            cardPath.fill()
            UIColor.cyan.withAlphaComponent(0.5).setStroke()
            cardPath.lineWidth = 2.5
            cardPath.stroke()

            // Header Glow
            let brandAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 22, weight: .black),
                .foregroundColor: UIColor.cyan
            ]
            "ECHO GRID".draw(at: CGPoint(x: 60, y: 100), withAttributes: brandAttributes)

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            title.draw(at: CGPoint(x: 60, y: 135), withAttributes: titleAttributes)

            // Dynamic Waveform Resonance Visualization
            let waveCenterY: CGFloat = 460
            let wavePath = UIBezierPath()
            wavePath.move(to: CGPoint(x: 60, y: waveCenterY))

            let wavePoints = 120
            for i in 0...wavePoints {
                let progress = Double(i) / Double(wavePoints)
                let x = 60.0 + progress * 420.0
                let envelope = sin(progress * .pi)
                let freq = Double(stars * 4)
                let y = waveCenterY + sin(progress * .pi * freq) * 70.0 * envelope
                wavePath.addLine(to: CGPoint(x: x, y: y))
            }

            UIColor.cyan.setStroke()
            wavePath.lineWidth = 4
            wavePath.stroke()

            // Harmonic Nodes along the wave
            let nodePositions = [0.25, 0.5, 0.75]
            for frac in nodePositions {
                let nodeX = 60.0 + frac * 420.0
                let nodePath = UIBezierPath(arcCenter: CGPoint(x: nodeX, y: waveCenterY), radius: 8, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                UIColor.white.setFill()
                nodePath.fill()
            }

            // Solved Stars
            var starText = ""
            for _ in 0..<stars { starText += "★ " }
            let starAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 34),
                .foregroundColor: UIColor.systemYellow
            ]
            starText.draw(at: CGPoint(x: 60, y: 640), withAttributes: starAttributes)

            // Solve Metrics
            let statsText = "MOVES: \(moves) / PAR \(parMoves)  •  TIME: \(String(format: "%.1fs", timeSec))"
            let statsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor.lightGray
            ]
            statsText.draw(at: CGPoint(x: 60, y: 700), withAttributes: statsAttributes)

            // Tagline & Call-to-action
            let ctaAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 14, weight: .bold),
                .foregroundColor: UIColor.cyan.withAlphaComponent(0.8)
            ]
            "FEEL THE RESONANCE  •  #EchoGrid".draw(at: CGPoint(x: 60, y: 780), withAttributes: ctaAttributes)

            let footerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor.gray
            ]
            "Available on iOS • Zero Audio Lag • Pure Core Haptics".draw(at: CGPoint(x: 60, y: 820), withAttributes: footerAttributes)
        }
    }
}
