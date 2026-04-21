//
//  MockBookRepo.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

final class MockBookRepo: BookRepository {
    var stubbedRecord: BookRecord?
    var stubbedHistory: [BookRecord] = []

    func createBook(locationA: BookedLocation, locationB: BookedLocation) async throws -> BookRecord {
        if let r = stubbedRecord { return r }
        return BookRecord(
            id: UUID().uuidString,
            locationA: locationA,
            locationB: locationB,
            price: 10_000
        )
    }

    func fetchBooks(year: Int, month: Int) async throws -> [BookRecord] {
        stubbedHistory
    }
}
