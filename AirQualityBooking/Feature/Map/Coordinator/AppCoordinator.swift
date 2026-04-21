//
//  AppCoordinator.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import FactoryKit
import Observation


@Observable final class AppCoordinator {
    
    // MARK: Navigation State
    var path: NavigationPath = NavigationPath()
    
    // MARK: Factory Injected
    private let mapViewModel: MapViewModel
    
    init(mapViewModel: MapViewModel = Container.shared.mapViewModel()) {
        self.mapViewModel = mapViewModel
    }
    
    // MARK: Navigation Methods
    
    func navigateToLocationDetail(pin: MapPin, slot: LocationSlot, onSave: @escaping (MapPin) -> Void) {
        path.append(Route.locationDetail(pin: pin, slot: slot, onSave: onSave))
    }
    
    func navigateToBooking(recordA: MapPin, recordB: MapPin) {
        path.append(Route.booking(recordA: recordA, recordB: recordB))
    }
    
    func navigateToHistory() {
        path.append(Route.history)
    }
    
    func navigateToCachedLocations(slot: LocationSlot, onSelect: @escaping (MapPin) -> Void) {
        path.append(Route.cachedLocations(slot: slot, onSelect: onSelect))
    }
    
    /// Pops all views and resets to initial map state
    func resetToRoot() {
        path = NavigationPath()
        mapViewModel.reset()
    }
    
    /// Pre-populate map from history record, go back to root
    func goToMapWith(record: BookRecord) {
        resetToRoot()
        mapViewModel.applyHistoryRecord(record)
    }
}

enum LocationSlot: String {
    case a = "A"
    case b = "B"
}
