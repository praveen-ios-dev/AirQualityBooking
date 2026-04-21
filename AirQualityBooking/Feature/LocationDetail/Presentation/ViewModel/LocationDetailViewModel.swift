//
//  LocationDetailViewModel.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import Combine
import Observation

enum LocationDetailIntent {
    case nicknameChanged(String)
    case saveTapped
    case skipTapped
}

@MainActor
@Observable final class LocationDetailViewModel {
    var nickname: String = ""
    private(set) var pin: MapPin
    let slot: LocationSlot

    // Nickname max 20 chars
    var trimmedNickname: String? {
        let s = nickname.trimmingCharacters(in: .whitespaces)
        return s.isEmpty ? nil : String(s.prefix(20))
    }

    init(pin: MapPin, slot: LocationSlot) {
        self.pin = pin
        self.slot = slot
        self.nickname = pin.nickname ?? ""
    }

    func handle(_ intent: LocationDetailIntent) -> MapPin? {
        switch intent {
        case .nicknameChanged(let text):
            nickname = String(text.prefix(20))
            return nil
        case .saveTapped:
            var updated = pin
            updated.nickname = trimmedNickname
            return updated
        case .skipTapped:
            return pin
        }
    }
}
