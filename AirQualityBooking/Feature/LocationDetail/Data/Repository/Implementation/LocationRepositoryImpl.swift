//
//  LocationRepositoryImpl.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

final class LocationRepositoryImpl: LocationRepository {
    private let networkService: LocationNetworkService

    init(networkService: LocationNetworkService) {
        self.networkService = networkService
    }

    func fetchLocationName(at coordinate: Coordinate) async throws -> String {
        let dto = try await networkService.fetchLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        return dto.resolvedName()
    }
}
