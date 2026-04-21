//
//  Container+Extension.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import FactoryKit
import Foundation

extension Container {
    var coordinateCache: Factory<CoordinateCache> {
        self { CoordinateCache() }.singleton
    }
}

enum AppConfig {
    static var useMocks: Bool = false
    nonisolated static var aqiToken: String {
            guard let token = Bundle.main.object(forInfoDictionaryKey: "AQI_TOKEN") as? String,
                  !token.isEmpty else {
                fatalError("AQI_TOKEN not found in Info.plist")
            }
            return token
        }
}

