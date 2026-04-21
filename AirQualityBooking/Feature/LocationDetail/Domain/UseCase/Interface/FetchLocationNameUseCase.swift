//
//  FetchLocationNameUseCase.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public protocol FetchLocationNameUseCase {
    func execute(coordinate: Coordinate) async throws -> String
}
