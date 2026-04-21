//
//  CachedLocationsViewModel.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import Observation

enum CachedLocationsIntent {
    case onAppear
    case locationSelected(MapPin)
}

@MainActor
@Observable final class CachedLocationsViewModel {
    private(set) var pins: [MapPin] = []
    private(set) var isLoading: Bool = false

    private let cache: CoordinateCache

    nonisolated init(cache: CoordinateCache) {
        self.cache = cache
    }

    func handle(_ intent: CachedLocationsIntent) {
        switch intent {
        case .onAppear:
            Task { await loadPins() }
        case .locationSelected:
            break // handled by coordinator
        }
    }

    private func loadPins() async {
        isLoading = true
        pins = await cache.allPins()
        isLoading = false
    }
}
