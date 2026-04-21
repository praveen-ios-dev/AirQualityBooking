//
//  AirQuality.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public struct AirQuality: Equatable, Hashable {
    public let aqi: Int
    public let coordinate: Coordinate

    public init(aqi: Int, coordinate: Coordinate) {
        self.aqi = aqi
        self.coordinate = coordinate
    }

    public var level: AQILevel {
        switch aqi {
        case ..<51:   return .good
        case 51..<101: return .moderate
        case 101..<151: return .unhealthyForSensitive
        case 151..<201: return .unhealthy
        case 201..<301: return .veryUnhealthy
        default:        return .hazardous
        }
    }
}

public enum AQILevel: String {
    case good                  = "Good"
    case moderate              = "Moderate"
    case unhealthyForSensitive = "Unhealthy for Sensitive"
    case unhealthy             = "Unhealthy"
    case veryUnhealthy         = "Very Unhealthy"
    case hazardous             = "Hazardous"

    public var emoji: String {
        switch self {
        case .good: return "🟢"
        case .moderate: return "🟡"
        case .unhealthyForSensitive: return "🟠"
        case .unhealthy: return "🔴"
        case .veryUnhealthy: return "🟣"
        case .hazardous: return "🟤"
        }
    }
}

extension AirQuality {
    init(dto: AQIDataDTO, requestedCoordinate: Coordinate) {
        self.init(aqi: dto.aqi, coordinate: requestedCoordinate)
    }
}
