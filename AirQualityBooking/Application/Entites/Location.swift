//
//  Location.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import CoreLocation

public struct Location: Equatable, Hashable {
    public let coordinate: Coordinate
    public let name: String
    public var nickname: String?

    public init(coordinate: Coordinate, name: String, nickname: String? = nil) {
        self.coordinate = coordinate
        self.name = name
        self.nickname = nickname
    }

    /// Display label respects nickname if set
    public var displayName: String { nickname ?? name }
}

public struct Coordinate: Equatable, Hashable, Codable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Truncates to 3 decimal places for cache key matching
    public var cacheKey: String {
        let lat = truncate(latitude)
        let lon = truncate(longitude)
        return "\(lat),\(lon)"
    }

    private func truncate(_ value: Double) -> Double {
        (value * 1000).rounded(.towardZero) / 1000
    }
}

