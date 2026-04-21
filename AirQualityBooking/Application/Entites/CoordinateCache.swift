//
//  CoordinateCache.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public actor CoordinateCache {

    // MARK: - Storage

    private var locationNames: [String: String] = [:]
    private var airQualities: [String: AirQuality] = [:]
    private var mapPins: [String: MapPin] = [:]

    public init() {}

    // MARK: - Location Name

    public func locationName(for coordinate: Coordinate) -> String? {
        locationNames[coordinate.cacheKey]
    }

    public func storeLocationName(_ name: String, for coordinate: Coordinate) {
        locationNames[coordinate.cacheKey] = name
    }

    // MARK: - Air Quality

    public func airQuality(for coordinate: Coordinate) -> AirQuality? {
        airQualities[coordinate.cacheKey]
    }

    public func storeAirQuality(_ aq: AirQuality, for coordinate: Coordinate) {
        airQualities[coordinate.cacheKey] = aq
    }

    // MARK: - Map Pins (for Screen 5)

    public func storePin(_ pin: MapPin) {
        mapPins[pin.coordinate.cacheKey] = pin
    }

    public func allPins() -> [MapPin] {
        Array(mapPins.values)
    }

    public func pin(for coordinate: Coordinate) -> MapPin? {
        mapPins[coordinate.cacheKey]
    }

    // MARK: - Reset

    public func clear() {
        locationNames.removeAll()
        airQualities.removeAll()
        mapPins.removeAll()
    }
}
