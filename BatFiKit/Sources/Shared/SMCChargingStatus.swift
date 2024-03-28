//
//  SMCChargingStatus.swift
//  BatFi
//
//  Created by Adam on 25/04/2023.
//

import Foundation

public struct SMCChargingStatus: Codable, CustomStringConvertible {
    public let forceDischarging: Bool
    public let inhitbitCharging: Bool
    public let lidClosed: Bool

    public init(
        forceDischarging: Bool,
        inhitbitCharging: Bool,
        lidClosed: Bool
    ) {
        self.forceDischarging = forceDischarging
        self.inhitbitCharging = inhitbitCharging
        self.lidClosed = lidClosed
    }

    public var description: String {
        """
        Status:
        forceDischarging: \(forceDischarging)
        inhitbitCharging: \(inhitbitCharging)
        lidClosed: \(lidClosed)
        """
    }
}
