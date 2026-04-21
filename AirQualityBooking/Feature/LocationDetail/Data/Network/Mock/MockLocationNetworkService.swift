//
//  MockLocationNetworkService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

final class MockLocationNetworkService: LocationNetworkService {

    var delay: Duration = .milliseconds(200)

    func fetchLocation(latitude: Double, longitude: Double) async throws -> LocationResponseDTO {
        try await Task.sleep(for: delay)
        return LocationResponseDTO(
            locality: "Mock Locality",
            localityInfo: LocationResponseDTO.LocalityInfoDTO(
                administrative: [
                    LocationResponseDTO.AdminDTO(name: "Seoul", order: 1),
                    LocationResponseDTO.AdminDTO(name: "Gangnam-gu", order: 2),
                    LocationResponseDTO.AdminDTO(name: "Apgujeong-dong", order: 3)
                ]
            )
        )
    }
}
