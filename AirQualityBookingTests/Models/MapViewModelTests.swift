//
//  MapViewModelTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//
import XCTest
@testable import AirQualityBooking

// MARK: - MapViewModel Integration Tests

@MainActor
final class MapViewModelTests: XCTestCase {

    var cache: CoordinateCache!
    var aqiRepo: MockAirQualityRepo!
    var locationRepo: MockLocationRepo!
    var sut: MapViewModel!

    override func setUp() async throws {
        cache = CoordinateCache()
        aqiRepo = MockAirQualityRepo()
        locationRepo = MockLocationRepo()

        let aqiUseCase = FetchAirQualityUseCaseImpl(repository: aqiRepo, cache: cache)
        let locationUseCase = FetchLocationNameUseCaseImpl(repository: locationRepo, cache: cache)

        sut = MapViewModel(
            fetchAQI: aqiUseCase,
            fetchLocationName: locationUseCase,
            cache: cache
        )
    }

    // MARK: - Button State Transitions

    func test_initialState_isSetA() {
        XCTAssertEqual(sut.buttonState, .setA)
        XCTAssertNil(sut.pinA)
        XCTAssertNil(sut.pinB)
    }

    func test_afterSetA_buttonBecomesSetB() async throws {
        locationRepo.stubbedName = "Seoul"
        aqiRepo.stubbedResult = .success(AirQuality(aqi: 42, coordinate: .init(latitude: 37.5, longitude: 127.0)))

        sut.handle(.setLocationTapped)

        // Let async work complete
        try await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(sut.buttonState, .setB)
        XCTAssertNotNil(sut.pinA)
        XCTAssertNil(sut.pinB)
    }

    func test_afterSetB_buttonBecomesBook() async throws {
        locationRepo.stubbedName = "Gangnam"
        aqiRepo.stubbedResult = .success(AirQuality(aqi: 30, coordinate: .init(latitude: 0, longitude: 0)))

        // Set A
        sut.handle(.setLocationTapped)
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertEqual(sut.buttonState, .setB)

        // Set B
        sut.handle(.setLocationTapped)
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertEqual(sut.buttonState, .book)
        XCTAssertNotNil(sut.pinA)
        XCTAssertNotNil(sut.pinB)
    }

    func test_reset_clearsAllState() async throws {
        locationRepo.stubbedName = "Test"
        aqiRepo.stubbedResult = .success(AirQuality(aqi: 10, coordinate: .init(latitude: 0, longitude: 0)))

        sut.handle(.setLocationTapped)
        try await Task.sleep(for: .milliseconds(100))

        sut.reset()

        XCTAssertNil(sut.pinA)
        XCTAssertNil(sut.pinB)
        XCTAssertEqual(sut.buttonState, .setA)
    }

    // MARK: - Apply Pin from Cache (Screen 5)

    func test_applyPin_toSlotA_updatesButtonToSetB() {
        let pin = MapPin(
            coordinate: Coordinate(latitude: 37.5, longitude: 127.0),
            locationName: "Test A",
            airQuality: AirQuality(aqi: 30, coordinate: Coordinate(latitude: 37.5, longitude: 127.0))
        )
        sut.applyPin(pin, to: .a)

        XCTAssertNotNil(sut.pinA)
        XCTAssertNil(sut.pinB)
        XCTAssertEqual(sut.buttonState, .setB)
    }

    func test_applyPin_bothSlots_buttonBecomesBook() {
        let makePin = { (lat: Double, name: String) -> MapPin in
            MapPin(
                coordinate: Coordinate(latitude: lat, longitude: 127.0),
                locationName: name,
                airQuality: AirQuality(aqi: 20, coordinate: Coordinate(latitude: lat, longitude: 127.0))
            )
        }
        sut.applyPin(makePin(37.5, "A"), to: .a)
        sut.applyPin(makePin(37.6, "B"), to: .b)
        XCTAssertEqual(sut.buttonState, .book)
    }

    // MARK: - Nickname

    func test_updateNickname_slotA() {
        let pin = MapPin(
            coordinate: Coordinate(latitude: 37.5, longitude: 127.0),
            locationName: "Real Name",
            airQuality: AirQuality(aqi: 30, coordinate: Coordinate(latitude: 37.5, longitude: 127.0))
        )
        sut.applyPin(pin, to: .a)
        sut.updatePinNickname("My Spot", slot: .a)

        XCTAssertEqual(sut.pinA?.nickname, "My Spot")
        XCTAssertEqual(sut.pinA?.displayName, "My Spot")
    }

    func test_emptyNickname_fallsBackToLocationName() {
        let pin = MapPin(
            coordinate: Coordinate(latitude: 37.5, longitude: 127.0),
            locationName: "Real Name",
            airQuality: AirQuality(aqi: 30, coordinate: Coordinate(latitude: 37.5, longitude: 127.0))
        )
        sut.applyPin(pin, to: .a)
        sut.updatePinNickname("", slot: .a)

        XCTAssertNil(sut.pinA?.nickname)
        XCTAssertEqual(sut.pinA?.displayName, "Real Name")
    }
}
