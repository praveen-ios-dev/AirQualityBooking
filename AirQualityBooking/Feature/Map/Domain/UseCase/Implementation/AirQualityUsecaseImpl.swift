//
//  DefaultAirQualityUsecase.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import FactoryKit

public final class FetchAirQualityUseCaseImpl: FetchAirQualityUseCase {
    
    private let repository: AirQualityRepository
    private let cache: CoordinateCache
    
    public init(repository: AirQualityRepository, cache: CoordinateCache) {
        self.repository = repository
        self.cache = cache
    }
    
    
    public func execute(coordinate: Coordinate) async throws -> AirQuality {
        // Check cache first
        if let cached = await cache.airQuality(for: coordinate) {
            return cached
        }
        let result = try await repository.fetchAQI(at: coordinate)
        await cache.storeAirQuality(result, for: coordinate)
        return result
    }
    
    
}
