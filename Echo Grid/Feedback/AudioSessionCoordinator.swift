//
//  AudioSessionCoordinator.swift
//  Echo Grid
//

import AVFoundation
import UIKit
import Combine

@MainActor
public final class AudioSessionCoordinator: ObservableObject {
    public static let shared = AudioSessionCoordinator()

    private var cancellables = Set<AnyCancellable>()

    private init() {
        configureAudioSession()
        setupInterruptionObservers()
    }

    public func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
        }
    }

    private func setupInterruptionObservers() {
        // Audio interruption (Phone call, alarm, Siri)
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)
            .sink { notification in
                guard let userInfo = notification.userInfo,
                      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                    return
                }

                switch type {
                case .began:
                    print("Audio interruption began")
                case .ended:
                    if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                        let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                        if options.contains(.shouldResume) {
                            AudioSynthesizerOrchestrator.shared.restartEngineIfNeeded()
                        }
                    }
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)

        // Route change (AirPods disconnect / reconnect)
        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                AudioSynthesizerOrchestrator.shared.restartEngineIfNeeded()
            }
            .store(in: &cancellables)
    }
}
