//
//  LocationAPIService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import Alamofire

final class LocationAPIService: LocationNetworkService {
    private let baseURL = "https://api.bigdatacloud.net/data/reverse-geocode-client"

    func fetchLocation(latitude: Double, longitude: Double) async throws -> LocationResponseDTO {
        let params: Parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "localityLanguage": "en"
        ]
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseURL, parameters: params)
                .validate()
                .responseDecodable(of: LocationResponseDTO.self) { response in
                    switch response.result {
                    case .success(let dto):
                        continuation.resume(returning: dto)
                    case .failure(let error):
                        continuation.resume(throwing: NetworkError.unknown(error))
                    }
                }
        }
    }
}
