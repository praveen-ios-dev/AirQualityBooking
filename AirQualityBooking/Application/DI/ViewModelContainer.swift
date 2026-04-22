//
//  ViewModelContainer.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import FactoryKit


extension Container {
    var mapViewModel: Factory<MapViewModel> {
        self {
            MapViewModel(
                fetchAQI: self.fetchAirQualityUseCase(),
                fetchLocationName: self.fetchLocationNameUseCase(),
                cache: self.coordinateCache()
            )
        }.shared
    }
    
    var historyViewModel: Factory<HistoryViewModel> {
        self { HistoryViewModel(fetchHistory: self.fetchBookHistoryUseCase()) }
    }

    var cachedLocationsViewModel: Factory<CachedLocationsViewModel> {
        self { CachedLocationsViewModel(cache: self.coordinateCache()) }
    }
}
