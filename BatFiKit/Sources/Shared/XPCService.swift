//
//  XPCService.swift
//
//
//  Created by Adam Różyński on 28/03/2024.
//

import Foundation

@objc
public protocol XPCService {
    func setForceDischarge(_ handler: @escaping (Error?) -> Void)
    func setInhibitCharge(_ handler: @escaping (Error?) -> Void)
    func setAutocharge(_ handler: @escaping (Error?) -> Void)
    func setEnableSystemChargeLimit(_ handler: @escaping (Error?) -> Void)
    func getCurrentChargingStatus(_ handler: @escaping (SMCChargingStatus?, Error?) -> Void)
    func getPowerDistribution(_ handler: @escaping (PowerDistributionInfo?, Error?) -> Void)
    func setMagSafeLEDColor(color: UInt8, _ handler: @escaping (UInt8, Error?) -> Void)
    func getMagSafeLEDOption(_ handler: @escaping (UInt8, Error?) -> Void)
    func ping(_ handler: @escaping (Bool, Error?) -> Void)
    func quit(_ handler: @escaping (Bool, Error?) -> Void)
    func turnPowerMode(_ mode: UInt8, lowPowerModeOnly: Bool, _ handler: @escaping (Error?) -> Void)
    /// Boolean is telling us if the high power mode is available
    func currentPowerMode(_ handler: @escaping (NSNumber?, Bool) -> Void)
    func disableAutosleep(_ disable: Bool, _ handler: @escaping (Error?) -> Void)
}
