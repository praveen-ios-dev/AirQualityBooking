//
//  FetchAirQualityUseCaseTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - FetchAirQualityUseCase Tests

final class FetchAirQualityUseCaseTests: XCTestCase {

    func test_execute_returnsCachedValue() async throws {
        let cache = CoordinateCache()
        let repo = MockAirQualityRepo()
        let sut = FetchAirQualityUseCaseImpl(repository: repo, cache: cache)

        let coord = Coordinate(latitude: 37.5, longitude: 127.0)

        // First call → hits repo
        let result1 = try await sut.execute(coordinate: coord)
        XCTAssertEqual(repo.callCount, 1)

        // Second call → should hit cache
        let result2 = try await sut.execute(coordinate: coord)
        XCTAssertEqual(repo.callCount, 1, "Should not call repo again — cached")
        XCTAssertEqual(result1.aqi, result2.aqi)
    }

    func test_execute_propagatesError() async {
        let cache = CoordinateCache()
        let repo = MockAirQualityRepo()
        repo.stubbedResult = .failure(NetworkError.invalidResponse)
        let sut = FetchAirQualityUseCaseImpl(repository: repo, cache: cache)

        do {
            _ = try await sut.execute(coordinate: Coordinate(latitude: 0, longitude: 0))
            XCTFail("Should have thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
