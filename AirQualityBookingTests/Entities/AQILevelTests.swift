//
//  AQILevelTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - AQILevel Tests

final class AQILevelTests: XCTestCase {

    func test_aqiLevelBuckets() {
        XCTAssertEqual(AirQuality(aqi: 0,   coordinate: .init(latitude: 0, longitude: 0)).level, .good)
        XCTAssertEqual(AirQuality(aqi: 50,  coordinate: .init(latitude: 0, longitude: 0)).level, .good)
        XCTAssertEqual(AirQuality(aqi: 51,  coordinate: .init(latitude: 0, longitude: 0)).level, .moderate)
        XCTAssertEqual(AirQuality(aqi: 100, coordinate: .init(latitude: 0, longitude: 0)).level, .moderate)
        XCTAssertEqual(AirQuality(aqi: 101, coordinate: .init(latitude: 0, longitude: 0)).level, .unhealthyForSensitive)
        XCTAssertEqual(AirQuality(aqi: 151, coordinate: .init(latitude: 0, longitude: 0)).level, .unhealthy)
        XCTAssertEqual(AirQuality(aqi: 201, coordinate: .init(latitude: 0, longitude: 0)).level, .veryUnhealthy)
        XCTAssertEqual(AirQuality(aqi: 301, coordinate: .init(latitude: 0, longitude: 0)).level, .hazardous)
    }
}
