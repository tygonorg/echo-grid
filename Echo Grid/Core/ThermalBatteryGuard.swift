//
//  ThermalBatteryGuard.swift
//  Echo Grid
//

import Foundation
import SwiftUI
import Combine

@MainActor
public final class ThermalBatteryGuard: ObservableObject {
    public static let shared = ThermalBatteryGuard()

    @Published public private(set) var isLowPowerMode: Bool = false
    @Published public private(set) var thermalState: ProcessInfo.ThermalState = .nominal
    @Published public private(set) var isThrottled: Bool = false

    private var cancellables = Set<AnyCancellable>()

    private init() {
        checkCurrentState()
        setupObservers()
    }

    private func checkCurrentState() {
        self.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        self.thermalState = ProcessInfo.processInfo.thermalState
        evaluateThrottling()
    }

    private func setupObservers() {
        NotificationCenter.default.publisher(for: NSNotification.Name.NSProcessInfoPowerStateDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
                self?.evaluateThrottling()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: ProcessInfo.thermalStateDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.thermalState = ProcessInfo.processInfo.thermalState
                self?.evaluateThrottling()
            }
            .store(in: &cancellables)
    }

    private func evaluateThrottling() {
        let isHot = thermalState == .serious || thermalState == .critical
        let shouldThrottle = isLowPowerMode || isHot
        self.isThrottled = shouldThrottle

        if shouldThrottle {
            // Automatically reduce haptic intensity to conserve battery & reduce heat
            HapticFeedbackOrchestrator.shared.hapticScale = min(HapticFeedbackOrchestrator.shared.hapticScale, 0.6)
        }
    }
}
