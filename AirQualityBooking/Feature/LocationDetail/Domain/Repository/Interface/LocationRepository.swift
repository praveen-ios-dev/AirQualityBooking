//
//  LocationRepository.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public protocol LocationRepository {
    func fetchLocationName(at coordinate: Coordinate) async throws -> String
}
