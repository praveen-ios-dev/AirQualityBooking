//
//  CreateBookingUseCaseTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - CreateBookingUseCase Tests

final class CreateBookingUseCaseTests: XCTestCase {

    func test_execute_returnsRecordWithCorrectLocations() async throws {
        let repo = MockBookRepo()
        let sut = await CreateBookingUseCaseImpl(repository: repo)

        let locA = await BookedLocation(coordinate: Coordinate(latitude: 37.0, longitude: 127.0), aqi: 30, name: "A")
        let locB = await BookedLocation(coordinate: Coordinate(latitude: 37.1, longitude: 127.1), aqi: 40, name: "B")

        let record = try await sut.execute(locationA: locA, locationB: locB)
        XCTAssertEqual(record.locationA.name, "A")
        XCTAssertEqual(record.locationB.name, "B")
        XCTAssertEqual(record.price, 10_000)
    }
}
