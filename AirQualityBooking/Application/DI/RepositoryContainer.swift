//
//  RepositoryContainer.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import FactoryKit

extension Container {
    var airQualityRepository: Factory<AirQualityRepository> {
        self { AirQualityRepositoryImpl(networkService: self.airQualityNetworkService()) }
    }

    var locationRepository: Factory<LocationRepository> {
        self { LocationRepositoryImpl(networkService: self.locationNetworkService()) }
    }

    var bookRepository: Factory<BookRepository> {
        self { BookRepositoryImpl(networkService: self.bookNetworkService()) }
    }
}
