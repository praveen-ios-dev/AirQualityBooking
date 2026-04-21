//
//  AirQualityNetworkService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

protocol AirQualityNetworkService {
    func fetchAQI(latitude: Double, longitude: Double) async throws -> AirQualityResponseDTO
}
