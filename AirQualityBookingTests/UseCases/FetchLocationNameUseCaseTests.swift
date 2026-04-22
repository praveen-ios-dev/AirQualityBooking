//
//  FetchLocationNameUseCaseTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - FetchLocationNameUseCase Tests

final class FetchLocationNameUseCaseTests: XCTestCase {

    func test_execute_cachesMisses() async throws {
        let cache = CoordinateCache()
        let repo = MockLocationRepo()
        repo.stubbedName = "Gangnam-gu"
        let sut = await FetchLocationNameUseCaseImpl(repository: repo, cache: cache)

        let coord = await Coordinate(latitude: 37.5172, longitude: 127.0473)
        let name1 = try await sut.execute(coordinate: coord)
        let name2 = try await sut.execute(coordinate: coord)

        XCTAssertEqual(name1, "Gangnam-gu")
        XCTAssertEqual(name2, "Gangnam-gu")
        XCTAssertEqual(repo.callCount, 1)
    }
}
