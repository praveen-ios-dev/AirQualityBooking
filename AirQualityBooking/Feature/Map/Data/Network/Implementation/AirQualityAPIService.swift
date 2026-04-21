//
//  AirQualityAPIService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import Alamofire

final class AirQualityAPIService: AirQualityNetworkService {
    private let token = "1bd85245dace9053499cb87a126716bf500575eb"
    private let baseURL = "https://api.waqi.info/feed"

    nonisolated func fetchAQI(latitude: Double, longitude: Double) async throws -> AirQualityResponseDTO {
        let url = "\(baseURL)/geo:\(latitude);\(longitude)/"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, parameters: ["token": AppConfig.aqiToken])
                .validate()
                .responseDecodable(of: AirQualityResponseDTO.self) { response in
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
