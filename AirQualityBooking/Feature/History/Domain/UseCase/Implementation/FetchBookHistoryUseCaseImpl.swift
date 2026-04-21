//
//  FetchBookHistoryUseCaseImpl.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public final class FetchBookHistoryUseCaseImpl: FetchBookHistoryUseCase {
    private let repository: BookRepository

    public init(repository: BookRepository) {
        self.repository = repository
    }

    public func execute(year: Int, month: Int) async throws -> [BookRecord] {
        try await repository.fetchBooks(year: year, month: month)
    }
}
