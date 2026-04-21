//
//  AirQualityRepositoryImpl.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

final class AirQualityRepositoryImpl: AirQualityRepository {
    private let networkService: AirQualityNetworkService

    init(networkService: AirQualityNetworkService, isFetchingFromMockData: Bool = false) {
        self.networkService = networkService
        AppConfig.useMocks = isFetchingFromMockData
    }

    func fetchAQI(at coordinate: Coordinate) async throws -> AirQuality {
        let dto = try await networkService.fetchAQI(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        return AirQuality(dto: dto.data, requestedCoordinate: coordinate)
    }
}
