//
//  MockLocationNetworkService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

final class MockBookNetworkService: BookNetworkService {

    var delay: Duration = .milliseconds(400)
    
    private var createRamdomPrice: Double {
        Double.random(in: 100...20_000)
    }

    func createBook(request: BookRequestDTO) async throws -> BookResponseDTO {
        try await Task.sleep(for: delay)
        return BookResponseDTO(
            id: UUID().uuidString,
            a: request.a,
            b: request.b,
            price: createRamdomPrice
        )
    }

    func fetchBooks(year: Int, month: Int) async throws -> [BookResponseDTO] {
        try await Task.sleep(for: delay)
        return [
            BookResponseDTO(
                id: UUID().uuidString,
                a: BookLocationDTO(latitude: 36.564, longitude: 127.001, aqi: 30, name: "Fruits"),
                b: BookLocationDTO(latitude: 36.567, longitude: 127.000, aqi: 40, name: "Drink"),
                price: createRamdomPrice
            ),
            BookResponseDTO(
                id: UUID().uuidString,
                a: BookLocationDTO(latitude: 36.577, longitude: 127.033, aqi: 50, name: "Office"),
                b: BookLocationDTO(latitude: 36.567, longitude: 127.000, aqi: 60, name: "Home"),
                price: createRamdomPrice
            )
        ]
    }
}
