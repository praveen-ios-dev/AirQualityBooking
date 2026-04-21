//
//  BookingViewModelTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - BookingViewModel Tests
@MainActor
final class BookingViewModelTests: XCTestCase {

    func test_confirmTapped_transitionsToSuccess() async throws {
        let bookRepo = MockBookRepo()
        let useCase = CreateBookingUseCaseImpl(repository: bookRepo)

        let makePin = { (name: String, lat: Double) -> MapPin in
            MapPin(
                coordinate: Coordinate(latitude: lat, longitude: 127.0),
                locationName: name,
                airQuality: AirQuality(aqi: 30, coordinate: Coordinate(latitude: lat, longitude: 127.0))
            )
        }

        let sut = BookingViewModel(
            pinA: makePin("A", 37.5),
            pinB: makePin("B", 37.6),
            createBooking: useCase
        )

        XCTAssertEqual(sut.state, .idle)
        sut.handle(.confirmTapped)
        try await Task.sleep(for: .milliseconds(150))

        if case .success(let record) = sut.state {
            XCTAssertEqual(record.price, 10_000)
        } else {
            XCTFail("Expected success state, got \(sut.state)")
        }
    }
}
