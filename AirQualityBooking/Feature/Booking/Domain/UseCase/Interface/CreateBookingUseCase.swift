//
//  CreateBookingUseCase.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public protocol CreateBookingUseCase: Sendable {
    func execute(locationA: BookedLocation, locationB: BookedLocation) async throws -> BookRecord
}
