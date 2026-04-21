//
//  LocationNetworkService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

protocol LocationNetworkService {
    func fetchLocation(latitude: Double, longitude: Double) async throws -> LocationResponseDTO
}
