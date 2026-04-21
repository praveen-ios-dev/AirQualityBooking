//
//  FetchBookHistoryUseCase.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation

public protocol FetchBookHistoryUseCase {
    func execute(year: Int, month: Int) async throws -> [BookRecord]
}
