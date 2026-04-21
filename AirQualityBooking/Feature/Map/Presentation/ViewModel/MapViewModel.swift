//
//  MapViewModel.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import Observation
import FactoryKit

// MARK: - Intent (unidirectional data flow)
enum MapIntent {
    case mapCameraChanged(Coordinate)
    case setLocationTapped
    case bookTapped
    case labelATapped
    case labelBTapped
    case resetState
}

// MARK: - ViewModel State
enum ButtonState: Equatable {
    case setA
    case setB
    case book
}

@Observable final class MapViewModel {
    private let airQualityUseCase: FetchAirQualityUseCase

    // MARK: - Published State
    
    private(set) var cameraCoordinate: Coordinate = Coordinate(latitude: 37.5665, longitude: 126.9780)
    private(set) var currentAQI: AirQuality?
    private(set) var pinA: MapPin?
    private(set) var pinB: MapPin?
    private(set) var buttonState: ButtonState = .setA
    private(set) var isLoadingAQI: Bool = false
    private(set) var errorMessage: String?
    
    // MARK: - Dependencies

    private let fetchLocationName: FetchLocationNameUseCase
    private let cache: CoordinateCache
    
    // MARK: - Private
    
    private var aqiTask: Task<Void, Never>?
    
    init(
        fetchAQI: FetchAirQualityUseCase,
        fetchLocationName: FetchLocationNameUseCase,
        cache: CoordinateCache
    ) {
        self.airQualityUseCase = fetchAQI
        self.fetchLocationName = fetchLocationName
        self.cache = cache
    }
    
    // MARK: - Intent Handler

    func handle(_ intent: MapIntent) {
        switch intent {
        case .mapCameraChanged(let coord):
            cameraCoordinate = coord
            debounceAQIFetch(for: coord)

        case .setLocationTapped:
            Task { await handleSetLocation() }

        case .bookTapped:
            break // Handled by coordinator

        case .labelATapped:
            break // Handled by coordinator

        case .labelBTapped:
            break // Handled by coordinator

        case .resetState:
            reset()
        }
    }

    // MARK: - AQI Fetch with Debounce

    private func debounceAQIFetch(for coord: Coordinate) {
        aqiTask?.cancel()
        aqiTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }
            await loadAQI(for: coord)
        }
    }

    private func loadAQI(for coord: Coordinate) async {
        isLoadingAQI = true
        errorMessage = nil
        do {
            currentAQI = try await airQualityUseCase.execute(coordinate: coord)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingAQI = false
    }

    // MARK: - Set Location Logic

    private func handleSetLocation() async {
        let coord = cameraCoordinate
        isLoadingAQI = true
        errorMessage = nil

        do {
            async let aqiResult = airQualityUseCase.execute(coordinate: coord)
            async let nameResult = fetchLocationName.execute(coordinate: coord)

            let (aq, name) = try await (aqiResult, nameResult)

            let pin = MapPin(
                coordinate: coord,
                locationName: name,
                airQuality: aq
            )

            // Store in cache for Screen 5
            await cache.storePin(pin)

            switch buttonState {
            case .setA:
                pinA = pin
                buttonState = .setB
            case .setB:
                pinB = pin
                buttonState = .book
            case .book:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingAQI = false
    }

    // MARK: - History Pre-population (Screen 4 → Screen 1)

    func applyHistoryRecord(_ record: BookRecord) {
        Task {
            // Re-fetch AQI as it may have changed
            async let aqA = airQualityUseCase.execute(coordinate: record.locationA.coordinate)
            async let aqB = airQualityUseCase.execute(coordinate: record.locationB.coordinate)

            do {
                let (airA, airB) = try await (aqA, aqB)

                pinA = MapPin(
                    coordinate: record.locationA.coordinate,
                    locationName: record.locationA.name,
                    airQuality: airA
                )
                pinB = MapPin(
                    coordinate: record.locationB.coordinate,
                    locationName: record.locationB.name,
                    airQuality: airB
                )
                buttonState = .book
                cameraCoordinate = record.locationA.coordinate
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Slot Selection from Cache (Screen 5 → Screen 1)

    func applyPin(_ pin: MapPin, to slot: LocationSlot) {
        switch slot {
        case .a:
            pinA = pin
            buttonState = pinB == nil ? .setB : .book
        case .b:
            pinB = pin
            buttonState = .book
        }
    }

    func updatePinNickname(_ nickname: String?, slot: LocationSlot) {
        switch slot {
        case .a: pinA?.nickname = nickname.flatMap { $0.isEmpty ? nil : $0 }
        case .b: pinB?.nickname = nickname.flatMap { $0.isEmpty ? nil : $0 }
        }
    }

    // MARK: - Reset

    func reset() {
        pinA = nil
        pinB = nil
        buttonState = .setA
        currentAQI = nil
        errorMessage = nil
    }
}
