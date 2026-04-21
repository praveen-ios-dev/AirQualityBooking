//
//  AirQualityRepository.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public protocol AirQualityRepository: Sendable {
    func fetchAQI(at coordinate: Coordinate) async throws -> AirQuality
}
