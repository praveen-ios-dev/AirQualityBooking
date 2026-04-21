//
//  LocationResponseDTO.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

nonisolated struct LocationResponseDTO: Decodable {
    let locality: String?
    let localityInfo: LocalityInfoDTO?

    struct LocalityInfoDTO: Decodable {
        let administrative: [AdminDTO]?
    }

    struct AdminDTO: Decodable {
        let name: String
        let order: Int
    }
}

extension LocationResponseDTO {
    /// Returns the two highest-order (lowest order number) administrative names concatenated.
    func resolvedName() -> String {
        guard let admins = localityInfo?.administrative, !admins.isEmpty else {
            return locality ?? "Unknown"
        }
        let sorted = admins.sorted { $0.order < $1.order }
        let top2 = sorted.prefix(2).map(\.name)
        return top2.joined(separator: " ")
    }
}
