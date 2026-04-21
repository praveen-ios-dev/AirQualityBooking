//
//  AirQualityResponseDTO.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

nonisolated struct AirQualityResponseDTO: Decodable {
    let status: String
    let data: AQIDataDTO
}

struct AQIDataDTO: Decodable {
    let aqi: Int
    let city: AQICityDTO?

    struct AQICityDTO: Decodable {
        let geo: [Double]?
        let name: String?
    }
}

