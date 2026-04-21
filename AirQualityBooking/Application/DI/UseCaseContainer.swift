//
//  UseCaseContainer.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import FactoryKit

extension Container {
    var fetchAirQualityUseCase: Factory<FetchAirQualityUseCase> {
        self {
            FetchAirQualityUseCaseImpl(
                repository: self.airQualityRepository(),
                cache: self.coordinateCache()
            )
        }
    }
    
    var fetchLocationNameUseCase: Factory<FetchLocationNameUseCase> {
        self {
            FetchLocationNameUseCaseImpl(
                repository: self.locationRepository(),
                cache: self.coordinateCache()
            )
        }
    }
    
    var createBookingUseCase: Factory<CreateBookingUseCase> {
        self { CreateBookingUseCaseImpl(repository: self.bookRepository()) }
    }

    var fetchBookHistoryUseCase: Factory<FetchBookHistoryUseCase> {
        self { FetchBookHistoryUseCaseImpl(repository: self.bookRepository()) }
    }
}
