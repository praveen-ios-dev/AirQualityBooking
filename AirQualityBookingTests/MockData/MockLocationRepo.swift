//
//  MockLocationRepo.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

final class MockLocationRepo: LocationRepository {
    var stubbedName: String = "Test Location"
    var callCount = 0

    func fetchLocationName(at coordinate: Coordinate) async throws -> String {
        callCount += 1
        return stubbedName
    }
}
