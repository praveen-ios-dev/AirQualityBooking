//
//  MapView.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import MapKit
import FactoryKit

struct MapView: View {
    @Bindable var viewModel: MapViewModel
//    @Injected(\.mapViewModel) private var viewModel
    
    @State var coordinator: AppCoordinator
    
    @State private var mapCamera: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isFirstLoad = true
    
    var body: some View {
        ZStack {
            // MARK: Full-screen Map
            mapLayer

            // MARK: Center Pin
            centerPin

            // MARK: AQI Badge (top-right)
            VStack {
                HStack {
                    Spacer()
                    aqiBadge
                        .padding(.top, 60)
                        .padding(.trailing, 16)
                }
                Spacer()
            }

            // MARK: Bottom Panel
            VStack {
                Spacer()
                bottomPanel
            }
        }
        .ignoresSafeArea()
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
            // Request location on first appear
            if isFirstLoad {
                isFirstLoad = false
                mapCamera = .userLocation(fallback: .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    )
                ))
            }
        }
    }

    // MARK: - Subviews

    private var mapLayer: some View {
        Map(position: $mapCamera) {
            UserAnnotation()
        }
        .onMapCameraChange(frequency: .continuous) { context in
            let coord = Coordinate(
                latitude: context.camera.centerCoordinate.latitude,
                longitude: context.camera.centerCoordinate.longitude
            )
            viewModel.handle(.mapCameraChanged(coord))
        }
    }

    private var centerPin: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.red, .white)
                .shadow(radius: 4)
            // Stem
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: 8)
        }
        .allowsHitTesting(false)
    }

    private var aqiBadge: some View {
        Group {
            if viewModel.isLoadingAQI {
                ProgressView()
                    .padding(10)
                    .background(.ultraThinMaterial, in: Capsule())
            } else if let aqi = viewModel.currentAQI {
                HStack(spacing: 6) {
                    Text("aqi")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(aqi.aqi)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.thinMaterial, in: Capsule())
            }
        }
    }

    private var bottomPanel: some View {
        HStack(spacing: 12) {

            VStack(spacing: 10) {
                locationLabel(title: "A", pin: viewModel.pinA, slot: .a)
                locationLabel(title: "B", pin: viewModel.pinB, slot: .b)
            }

            actionButton
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 28)
    }

    private func locationLabel(title: String, pin: MapPin?, slot: LocationSlot) -> some View {
        Button {
            handleLabelTap(pin: pin, slot: slot)
        } label: {
            HStack {
                Text(title)
                    .font(.headline)
                    .frame(width: 20)

                if let pin {
                    Text(pin.displayName)
                        .font(.subheadline)
                        .lineLimit(1)
                } else {
                    Text("Not set")
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var actionButton: some View {
        Button {
            handleActionButton()
        } label: {
            HStack {
                if viewModel.isLoadingAQI && viewModel.buttonState != .book {
                    ProgressView()
                        .tint(.white)
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: buttonIcon)
                    Text(buttonLabel)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
            .frame(height: 100)
            .padding(.vertical, 16)
            .background(buttonColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .foregroundStyle(.white)
        }
        .disabled(viewModel.isLoadingAQI && viewModel.buttonState != .book)
        .animation(.spring(duration: 0.3), value: viewModel.buttonState)
    }
    
    private var buttonLabel: String {
        switch viewModel.buttonState {
        case .setA: return "Set A"
        case .setB: return "Set B"
        case .book: return "Book"
        }
    }

    private var buttonIcon: String {
        switch viewModel.buttonState {
        case .setA: return "mappin"
        case .setB: return "mappin"
        case .book: return "checkmark.circle.fill"
        }
    }

    private var buttonColor: Color {
        switch viewModel.buttonState {
        case .setA: return .blue
        case .setB: return .green
        case .book: return .orange
        }
    }

    // MARK: - Actions

    private func handleLabelTap(pin: MapPin?, slot: LocationSlot) {
        if let pin {
            // Navigate to detail screen
            coordinator.navigateToLocationDetail(pin: pin, slot: slot) { updatedPin in
                viewModel.applyPin(updatedPin, to: slot)
            }
        } else {
            // Navigate to cached locations screen
            coordinator.navigateToCachedLocations(slot: slot) { selectedPin in
                viewModel.applyPin(selectedPin, to: slot)
            }
        }
    }

    private func handleActionButton() {
        switch viewModel.buttonState {
        case .setA, .setB:
            viewModel.handle(.setLocationTapped)
        case .book:
            guard let pinA = viewModel.pinA, let pinB = viewModel.pinB else { return }
            coordinator.navigateToBooking(recordA: pinA, recordB: pinB)
        }
    }
}
