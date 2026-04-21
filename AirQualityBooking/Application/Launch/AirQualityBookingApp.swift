//
//  AirQualityBookingApp.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI

@main
struct AirQualityBookingApp: App {
    @State private var appCoordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: appCoordinator)
        }
    }
}
