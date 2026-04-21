//
//  LocationDTOTests.swift
//  AirQualityBookingTests
//
//  Created by Praveen on 22/04/26.
//

import XCTest
@testable import AirQualityBooking

// MARK: - LocationResponseDTO Tests

final class LocationDTOTests: XCTestCase {

    func test_resolvedName_topTwoAdminByOrder() {
        let dto = LocationResponseDTO(
            locality: "Fallback",
            localityInfo: LocationResponseDTO.LocalityInfoDTO(administrative: [
                LocationResponseDTO.AdminDTO(name: "Apgujeong-dong", order: 3),
                LocationResponseDTO.AdminDTO(name: "Seoul",          order: 1),
                LocationResponseDTO.AdminDTO(name: "Gangnam-gu",     order: 2)
            ])
        )
        XCTAssertEqual(dto.resolvedName(), "Seoul Gangnam-gu")
    }

    func test_resolvedName_fallsBackToLocality() {
        let dto = LocationResponseDTO(locality: "My Locality", localityInfo: nil)
        XCTAssertEqual(dto.resolvedName(), "My Locality")
    }
}
