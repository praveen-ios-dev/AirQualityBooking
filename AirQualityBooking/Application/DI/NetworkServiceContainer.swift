//
//  NetworkServiceContainer.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import FactoryKit

extension Container {
    var airQualityNetworkService: Factory<AirQualityNetworkService> {
        self { AppConfig.useMocks ? MockAirQualityNetworkService() as AirQualityNetworkService : AirQualityAPIService() as AirQualityNetworkService }
    }

    var locationNetworkService: Factory<LocationNetworkService> {
        self { AppConfig.useMocks ? MockLocationNetworkService() as LocationNetworkService : LocationAPIService() as LocationNetworkService }
    }

    var bookNetworkService: Factory<BookNetworkService> {
        self { AppConfig.useMocks ? MockBookNetworkService() as BookNetworkService : BookAPIService() as BookNetworkService }
    }
}
