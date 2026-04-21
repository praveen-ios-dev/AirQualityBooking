//
//  Mpin.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public struct MapPin: Equatable {
    public let coordinate: Coordinate
    public let locationName: String
    public let airQuality: AirQuality
    public var nickname: String?

    public var displayName: String { nickname ?? locationName }

    public func asBookedLocation() -> BookedLocation {
        BookedLocation(coordinate: coordinate, aqi: airQuality.aqi, name: displayName, nickName: nickname)
    }
}
