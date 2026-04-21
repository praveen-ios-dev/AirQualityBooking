//
//  MockAirQualityRepo.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

final class MockAirQualityRepo: AirQualityRepository {
    var stubbedResult: Result<AirQuality, Error> = .success(
        AirQuality(aqi: 55, coordinate: Coordinate(latitude: 0, longitude: 0))
    )
    var callCount = 0

    func fetchAQI(at coordinate: Coordinate) async throws -> AirQuality {
        callCount += 1
        switch stubbedResult {
        case .success(let aq): return AirQuality(aqi: aq.aqi, coordinate: coordinate)
        case .failure(let e): throw e
        }
    }
}
