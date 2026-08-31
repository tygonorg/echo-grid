//
//  AudioSynthesizerOrchestrator.swift
//  Echo Grid
//

import AVFoundation

@MainActor
public final class AudioSynthesizerOrchestrator {
    public static let shared = AudioSynthesizerOrchestrator()

    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var isEngineReady: Bool = false

    // Pre-rendered cached buffers for zero-latency, zero-overhead playback
    private var toneBuffers: [Int: AVAudioPCMBuffer] = [:]
    private var chordBuffers: [AVAudioPCMBuffer] = []

    private let baseFrequencies: [Double] = [261.63, 329.63, 392.00, 440.00, 523.25] // C4, E4, G4, A4, C5
    private let chordFrequencies: [Double] = [261.63, 329.63, 392.00, 523.25] // C Major chord

    private init() {
        setupAudioEngine()
    }

    public func restartEngineIfNeeded() {
        guard let engine = audioEngine else {
            setupAudioEngine()
            return
        }
        if !engine.isRunning {
            do {
                try engine.start()
                playerNode?.play()
                self.isEngineReady = true
            } catch {
                print("Could not restart AVAudioEngine, re-initializing: \(error)")
                setupAudioEngine()
            }
        }
    }

    private func setupAudioEngine() {
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)

        let mainMixer = engine.mainMixerNode
        let format = mainMixer.outputFormat(forBus: 0)

        // Ensure valid format parameters
        guard format.sampleRate > 0 && format.channelCount > 0 else {
            print("Audio engine mixer format is invalid")
            return
        }

        engine.connect(player, to: mainMixer, format: format)

        // Pre-render buffers using the EXACT mixer format (matching sample rate and channel count)
        precacheToneBuffers(format: format)

        do {
            try engine.start()
            player.play()
            self.audioEngine = engine
            self.playerNode = player
            self.isEngineReady = true
        } catch {
            print("Could not start AVAudioEngine: \(error)")
            self.isEngineReady = false
        }
    }

    private func precacheToneBuffers(format: AVAudioFormat) {
        let sampleRate = format.sampleRate
        let channelCount = Int(format.channelCount)

        // Precache 5 pentatonic tones (0.18s duration)
        for (index, freq) in baseFrequencies.enumerated() {
            if let buffer = createSineBuffer(frequency: freq, duration: 0.18, amplitude: 0.28, format: format, sampleRate: sampleRate, channelCount: channelCount) {
                toneBuffers[index] = buffer
            }
        }

        // Precache 4 chord tones (0.40s duration)
        for freq in chordFrequencies {
            if let buffer = createSineBuffer(frequency: freq, duration: 0.40, amplitude: 0.25, format: format, sampleRate: sampleRate, channelCount: channelCount) {
                chordBuffers.append(buffer)
            }
        }
    }

    private func createSineBuffer(
        frequency: Double,
        duration: Double,
        amplitude: Float,
        format: AVAudioFormat,
        sampleRate: Double,
        channelCount: Int
    ) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return nil
        }
        buffer.frameLength = frameCount

        let angularFrequency = 2.0 * .pi * frequency / sampleRate

        // Render mono sample and copy to all channels (e.g. Left & Right stereo)
        for frame in 0..<Int(frameCount) {
            let progress = Double(frame) / Double(frameCount)
            let envelope = sin(progress * .pi)
            let sample = Float(sin(angularFrequency * Double(frame))) * amplitude * Float(envelope)

            for channel in 0..<channelCount {
                buffer.floatChannelData?[channel][frame] = sample
            }
        }

        return buffer
    }

    /// Instant zero-latency playback using pre-cached matching buffer
    public func playHarmonicTone(forScore score: Double) {
        guard isEngineReady, let player = playerNode else { return }

        let index = min(Int(score * Double(baseFrequencies.count - 1)), baseFrequencies.count - 1)
        let safeIndex = max(0, index)

        guard let buffer = toneBuffers[safeIndex] else { return }

        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
    }

    /// Plays completion chord for Solved state
    public func playSolvedChord() {
        guard isEngineReady, let player = playerNode else { return }

        for (i, buffer) in chordBuffers.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
                player.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
            }
        }
    }
}
