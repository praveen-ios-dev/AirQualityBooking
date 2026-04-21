//
//  BookRecord.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public struct BookRecord: Equatable, Identifiable {
    public let id: String
    public let locationA: BookedLocation
    public let locationB: BookedLocation
    public let price: Double

    public init(id: String, locationA: BookedLocation, locationB: BookedLocation, price: Double) {
        self.id = id
        self.locationA = locationA
        self.locationB = locationB
        self.price = price
    }
}
extension BookRecord {
    init(dto: BookResponseDTO) {
        self.init(
            id: dto.id ?? UUID().uuidString,
            locationA: BookedLocation(
                coordinate: Coordinate(latitude: dto.a.latitude, longitude: dto.a.longitude),
                aqi: dto.a.aqi,
                name: dto.a.name
            ),
            locationB: BookedLocation(
                coordinate: Coordinate(latitude: dto.b.latitude, longitude: dto.b.longitude),
                aqi: dto.b.aqi,
                name: dto.b.name
            ),
            price: dto.price
        )
    }
}
