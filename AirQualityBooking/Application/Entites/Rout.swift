//
//  Rout.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

import Foundation
import Combine

enum Route: Hashable {
    case locationDetail(pin: MapPin, slot: LocationSlot, onSave: (MapPin) -> Void)
    case booking(recordA: MapPin, recordB: MapPin)
    case history
    case cachedLocations(slot: LocationSlot, onSelect: (MapPin) -> Void)

    // Hashable conformance using associated value identity
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.history, .history): return true
        default: return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .locationDetail: hasher.combine("locationDetail")
        case .booking: hasher.combine("booking")
        case .history: hasher.combine("history")
        case .cachedLocations: hasher.combine("cachedLocations")
        }
    }
}
