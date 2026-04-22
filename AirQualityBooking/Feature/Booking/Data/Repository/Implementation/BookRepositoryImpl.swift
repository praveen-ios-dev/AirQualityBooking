//
//  BookRepositoryImpl.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

final class BookRepositoryImpl: BookRepository {
    private let networkService: BookNetworkService

    init(networkService: BookNetworkService) {
        self.networkService = networkService
    }

    func createBook(locationA: BookedLocation, locationB: BookedLocation) async throws -> BookRecord {
        let request = BookRequestDTO(locationA: locationA, locationB: locationB)
        let dto = try await networkService.createBook(request: request)
        return BookRecord(dto: dto)
    }

    func fetchBooks(year: Int, month: Int) async throws -> [BookRecord] {
        let dtos = try await networkService.fetchBooks(year: year, month: month)
        return dtos.map(BookRecord.init)
    }

}
