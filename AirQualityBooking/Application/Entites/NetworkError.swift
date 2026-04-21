//
//  NetworkError.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:      return "Invalid response from server."
        case .decodingFailed(let e): return "Decoding error: \(e.localizedDescription)"
        case .serverError(let code): return "Server error with code: \(code)"
        case .unknown(let e):       return e.localizedDescription
        }
    }
}
