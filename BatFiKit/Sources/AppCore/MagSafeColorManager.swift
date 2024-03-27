//
//  MagSafeColorManager.swift
//
//
//  Created by Adam on 16/07/2023.
//

import AppShared
import AsyncAlgorithms
import Clients
import DefaultsKeys
import Dependencies
import Foundation
import os
import Shared

public final class MagSafeColorManager {
    private lazy var logger = Logger(category: "MagSafe Color Manager")
    @Dependency(\.magSafeLEDColor) private var magSafeLEDColor
    @Dependency(\.defaults) private var defaults
    @Dependency(\.appChargingState) private var appChargingState
    @Dependency(\.suspendingClock) private var suspendingClock
    @Dependency(\.powerSourceClient) private var powerSourceClient

    public init() {}

    public func setUpObserving() {
        Task {
            for await ((greenLight, blinkWhenDischarging, limit), (mode, powerState)) in
                combineLatest(
                    combineLatest(
                        defaults.observe(.showGreenLightMagSafeWhenInhibiting),
                        defaults.observe(.blinkMagSafeWhenDischarging),
                        defaults.observe(.chargeLimit)
                    ),
                    combineLatest(
                        appChargingState.observeChargingStateMode(),
                        powerSourceClient.powerSourceChanges()
                    )
                ).debounce(for: .seconds(1), clock: AnyClock(self.suspendingClock))
            {
                await updateMagsafeLEDIndicator(
                    showGreenLightWhenInhibiting: greenLight,
                    blinkWhenDischarging: blinkWhenDischarging,
                    powerState: powerState,
                    appMode: mode,
                    limit: limit
                )
            }
        }
    }

    public func appWillQuit() async {
        await resetMagSafeColor()
    }

    private func updateMagsafeLEDIndicator(
        showGreenLightWhenInhibiting: Bool,
        blinkWhenDischarging: Bool,
        powerState: PowerState,
        appMode: AppChargingMode,
        limit: Int
    ) async {
        if appMode == .inhibit, showGreenLightWhenInhibiting, powerState.batteryLevel >= limit {
            logger.debug("Should change the color of MagSafe to green")
            do {
                _ = try await magSafeLEDColor.changeMagSafeLEDColor(.green)
                logger.debug("Color changed! 🎉")
            } catch {}
        } else if appMode == .forceDischarge, blinkWhenDischarging {
            _ = try? await magSafeLEDColor.changeMagSafeLEDColor(.errorOnce)
        } else {
            await resetMagSafeColor()
        }
    }

    private func resetMagSafeColor() async {
        do {
            logger.debug("Should reset the color of MagSafe...")
            _ = try await magSafeLEDColor.changeMagSafeLEDColor(.reset)
            logger.debug("Color reset was succesful! 🎉")
        } catch {
            logger.error("Error when resetting the color of MagSafe: \(error.localizedDescription, privacy: .public)")
        }
    }
}
