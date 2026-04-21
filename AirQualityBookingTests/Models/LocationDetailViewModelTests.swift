//
//  LocationDetailViewModelTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - LocationDetailViewModel Tests
@MainActor
final class LocationDetailViewModelTests: XCTestCase {

    func test_nicknameTruncatedAt20Chars() {
        let pin = MapPin(
            coordinate: Coordinate(latitude: 37.5, longitude: 127.0),
            locationName: "Test",
            airQuality: AirQuality(aqi: 10, coordinate: Coordinate(latitude: 0, longitude: 0))
        )
        let sut = LocationDetailViewModel(pin: pin, slot: .a)
        _ = sut.handle(.nicknameChanged("This is a very long nickname that exceeds 20 chars"))
        XCTAssertEqual(sut.nickname.count, 20)
    }

    func test_saveTapped_returnsUpdatedPin() {
        let pin = MapPin(
            coordinate: Coordinate(latitude: 37.5, longitude: 127.0),
            locationName: "Location",
            airQuality: AirQuality(aqi: 15, coordinate: Coordinate(latitude: 0, longitude: 0))
        )
        let sut = LocationDetailViewModel(pin: pin, slot: .a)
        _ = sut.handle(.nicknameChanged("Office"))
        let result = sut.handle(.saveTapped)
        XCTAssertEqual(result?.nickname, "Office")
        XCTAssertEqual(result?.displayName, "Office")
    }

    func test_skipTapped_returnsOriginalPin() {
        let pin = MapPin(
            coordinate: Coordinate(latitude: 37.5, longitude: 127.0),
            locationName: "Location",
            airQuality: AirQuality(aqi: 15, coordinate: Coordinate(latitude: 0, longitude: 0))
        )
        let sut = LocationDetailViewModel(pin: pin, slot: .b)
        let result = sut.handle(.skipTapped)
        XCTAssertNil(result?.nickname)
        XCTAssertEqual(result?.displayName, "Location")
    }
}
