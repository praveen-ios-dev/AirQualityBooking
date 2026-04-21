//
//  AppCoordinatorView.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import Foundation
import SwiftUI
import FactoryKit


struct AppCoordinatorView: View {
    @State var coordinator: AppCoordinator
    @Injected(\.mapViewModel) private var mapViewModel

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MapView(
                viewModel: mapViewModel,
                coordinator: coordinator
            )
            .navigationDestination(for: Route.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .locationDetail(let pin, let slot, let onSave):
            LocationDetailView(
                viewModel: LocationDetailViewModel(pin: pin, slot: slot),
                onSave: onSave,
                coordinator: coordinator
            )

        case .booking(let pinA, let pinB):
            BookingView(
                viewModel: BookingViewModel(
                    pinA: pinA,
                    pinB: pinB,
                    createBooking: Container.shared.createBookingUseCase()
                ),
                coordinator: coordinator
            )

        case .history:
            HistoryView(
                viewModel: Container.shared.historyViewModel(),
                coordinator: coordinator
            )

        case .cachedLocations(let slot, let onSelect):
            CachedLocationsView(
                viewModel: Container.shared.cachedLocationsViewModel(),
                slot: slot,
                onSelect: onSelect,
                coordinator: coordinator
            )
        }
    }
}
