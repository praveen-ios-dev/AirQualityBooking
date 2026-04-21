//
//  BookRepository.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public protocol BookRepository {
    func createBook(locationA: BookedLocation, locationB: BookedLocation) async throws -> BookRecord
    func fetchBooks(year: Int, month: Int) async throws -> [BookRecord]
}
