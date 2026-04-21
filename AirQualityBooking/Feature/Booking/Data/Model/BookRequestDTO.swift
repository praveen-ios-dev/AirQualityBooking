//
//  BookRequestDTO.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

nonisolated struct BookRequestDTO: Encodable {
    let a: BookLocationDTO
    let b: BookLocationDTO
}

nonisolated struct BookResponseDTO: Decodable {
    let id: String?
    let a: BookLocationDTO
    let b: BookLocationDTO
    let price: Double
}

struct BookLocationDTO: Codable {
    let latitude: Double
    let longitude: Double
    let aqi: Int
    let name: String
}

extension BookRequestDTO {
    init(locationA: BookedLocation, locationB: BookedLocation) {
        self.a = BookLocationDTO(
            latitude: locationA.coordinate.latitude,
            longitude: locationA.coordinate.longitude,
            aqi: locationA.aqi,
            name: locationA.name
        )
        self.b = BookLocationDTO(
            latitude: locationB.coordinate.latitude,
            longitude: locationB.coordinate.longitude,
            aqi: locationB.aqi,
            name: locationB.name
        )
    }
}
