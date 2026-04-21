//
//  BookingViewModel.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Observation
import Foundation

enum BookingIntent {
    case confirmTapped
    case backToRootTapped
}

enum BookingState: Equatable {
    case idle
    case loading
    case success(BookRecord)
    case failure(String)
}

@MainActor
@Observable final class BookingViewModel {
    private(set) var state: BookingState = .idle

    let pinA: MapPin
    let pinB: MapPin
    private let createBooking: CreateBookingUseCase

    init(pinA: MapPin, pinB: MapPin, createBooking: CreateBookingUseCase) {
        self.pinA = pinA
        self.pinB = pinB
        self.createBooking = createBooking
    }

    func handle(_ intent: BookingIntent) {
        switch intent {
        case .confirmTapped:
            Task { await performBooking() }
        case .backToRootTapped:
            break // coordinator handles navigation
        }
    }

    private func performBooking() async {
        state = .loading
        do {
            let record = try await createBooking.execute(
                locationA: pinA.asBookedLocation(),
                locationB: pinB.asBookedLocation()
            )
            state = .success(record)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
}
