//
//  BookNetworkService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

protocol BookNetworkService {
    func createBook(request: BookRequestDTO) async throws -> BookResponseDTO
    func fetchBooks(year: Int, month: Int) async throws -> [BookResponseDTO]
}
