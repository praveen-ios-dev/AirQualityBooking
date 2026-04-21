//
//  BookedLocation.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

// MARK: - BookRecord.swift

public struct BookedLocation: Equatable {
    public let coordinate: Coordinate
    public let aqi: Int
    public let name: String
    public let nickName: String?

    public init(coordinate: Coordinate, aqi: Int, name: String, nickName: String? = nil) {
        self.coordinate = coordinate
        self.aqi = aqi
        self.name = name
        self.nickName = nickName
    }
}


