//
//  MockAirQualityNetworkService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

final class MockAirQualityNetworkService: AirQualityNetworkService, Sendable {

    /// Simulates network latency
    var delay: Duration = .milliseconds(300)

    /// Customize per-coordinate responses for specific tests
    var stubbedAQI: Int = 42

    func fetchAQI(latitude: Double, longitude: Double) async throws -> AirQualityResponseDTO {
        try await Task.sleep(for: delay)
        return AirQualityResponseDTO(
            status: "ok",
            data: AQIDataDTO(
                aqi: stubbedAQI,
                city: AQIDataDTO.AQICityDTO(
                    geo: [latitude, longitude],
                    name: "Mock City"
                )
            )
        )
    }
}
