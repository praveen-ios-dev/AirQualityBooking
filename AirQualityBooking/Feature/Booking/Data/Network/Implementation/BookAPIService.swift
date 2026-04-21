//
//  BookAPIService.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import Combine
import Alamofire

final class BookAPIService: BookNetworkService {
    private let baseURL = "https://DummyRequest.com"

    func createBook(request: BookRequestDTO) async throws -> BookResponseDTO {
        let encoder = JSONParameterEncoder.default
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/books",
                       method: .post,
                       parameters: request,
                       encoder: encoder)
            .validate()
            .responseDecodable(of: BookResponseDTO.self) { response in
                switch response.result {
                case .success(let dto): continuation.resume(returning: dto)
                case .failure(let err): continuation.resume(throwing: NetworkError.unknown(err))
                }
            }
        }
    }

    func fetchBooks(year: Int, month: Int) async throws -> [BookResponseDTO] {
        let params: Parameters = ["year": year, "month": month]
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(baseURL)/books", parameters: params)
                .validate()
                .responseDecodable(of: [BookResponseDTO].self) { response in
                    switch response.result {
                    case .success(let dtos): continuation.resume(returning: dtos)
                    case .failure(let err): continuation.resume(throwing: NetworkError.unknown(err))
                    }
                }
        }
    }
}
