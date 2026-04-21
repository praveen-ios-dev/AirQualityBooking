//
//  FetchLocationNameImpl.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public final class FetchLocationNameUseCaseImpl: FetchLocationNameUseCase {
    
    private let repository: LocationRepository
    private let cache: CoordinateCache
    
    public init(repository: LocationRepository, cache: CoordinateCache) {
        self.repository = repository
        self.cache = cache
    }
    
    public func execute(coordinate: Coordinate) async throws -> String {
        if let cached = await cache.locationName(for: coordinate) {
            return cached
        }
        let name = try await repository.fetchLocationName(at: coordinate)
        await cache.storeLocationName(name, for: coordinate)
        return name
    }
}
