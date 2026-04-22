//
//  CoordinateCacheTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//
import XCTest
@testable import AirQualityBooking

// MARK: - CoordinateCache Tests

final class CoordinateCacheTests: XCTestCase {

    var sut: CoordinateCache!

    override func setUp() {
        super.setUp()
        sut = CoordinateCache()
    }

    // Two coords matching to 3rd decimal place → same cache key
    func test_sameLocation_matchesThirdDecimal() {
        let coord1 = Coordinate(latitude: 37.5642, longitude: 127.0016)
        let coord2 = Coordinate(latitude: 37.5645, longitude: 127.0018)
        XCTAssertEqual(coord1.cacheKey, coord2.cacheKey, "Coords within 3rd decimal should share a key")
    }

    // Different 3rd decimal → different cache key
    func test_differentLocation_differsAtThirdDecimal() {
        let coord1 = Coordinate(latitude: 37.5655, longitude: 127.2321)
        let coord2 = Coordinate(latitude: 37.5624, longitude: 127.2328)
        XCTAssertNotEqual(coord1.cacheKey, coord2.cacheKey, "Coords differing at 3rd decimal should have different keys")
    }

    func test_storeAndRetrieve_locationName() async {
        let coord = await Coordinate(latitude: 37.5665, longitude: 126.9780)
        await sut.storeLocationName("Seoul", for: coord)
        let retrieved = await sut.locationName(for: coord)
        XCTAssertEqual(retrieved, "Seoul")
    }

    func test_storeAndRetrieve_airQuality() async {
        let coord = await Coordinate(latitude: 37.5665, longitude: 126.9780)
        let aq = AirQuality(aqi: 42, coordinate: coord)
        await sut.storeAirQuality(aq, for: coord)
        let retrieved = await sut.airQuality(for: coord)
        XCTAssertEqual(retrieved?.aqi, 42)
    }

    func test_cache_hitsForNearbyCoordinate() async {
        let coord1 = await Coordinate(latitude: 37.5642, longitude: 127.0016)
        let coord2 = await Coordinate(latitude: 37.5645, longitude: 127.0018)
        await sut.storeLocationName("Cached Name", for: coord1)
        let retrieved = await sut.locationName(for: coord2)
        XCTAssertEqual(retrieved, "Cached Name", "Nearby coordinate should hit cache")
    }

    func test_cache_missForFarCoordinate() async {
        let coord1 = await Coordinate(latitude: 37.5655, longitude: 127.2321)
        let coord2 = await Coordinate(latitude: 37.5624, longitude: 127.2328)
        await sut.storeLocationName("Name A", for: coord1)
        let retrieved = await sut.locationName(for: coord2)
        XCTAssertNil(retrieved, "Different location should not hit cache")
    }

    func test_clear_removesAllEntries() async {
        let coord = await Coordinate(latitude: 37.5665, longitude: 126.9780)
        await sut.storeLocationName("Seoul", for: coord)
        await sut.clear()
        let retrieved = await sut.locationName(for: coord)
        XCTAssertNil(retrieved)
    }
}
