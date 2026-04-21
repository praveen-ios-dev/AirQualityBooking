//
//  CreateBookingUseCaseImpl.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public final class CreateBookingUseCaseImpl: CreateBookingUseCase {
    private let repository: BookRepository

    public init(repository: BookRepository) {
        self.repository = repository
    }

    public func execute(locationA: BookedLocation, locationB: BookedLocation) async throws -> BookRecord {
        try await repository.createBook(locationA: locationA, locationB: locationB)
    }
}
