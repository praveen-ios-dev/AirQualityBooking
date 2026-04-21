//
//  CachedLocationsView.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import MapKit

struct CachedLocationsView: View {
    @State var viewModel: CachedLocationsViewModel
    let slot: LocationSlot
    let onSelect: (MapPin) -> Void
    @State var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading cached locations...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.pins.isEmpty {
                emptyState
            } else {
                pinList
            }
        }
        .navigationTitle("Select Location \(slot.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .task { viewModel.handle(.onAppear) }
    }

    // MARK: - Subviews

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No Cached Locations")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Search and set locations on the map first.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var pinList: some View {
        List(viewModel.pins, id: \.coordinate) { pin in
            CachedLocationRow(pin: pin)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .onTapGesture {
                    onSelect(pin)
                    dismiss()
                }
        }
        .listStyle(.plain)
    }
}

// MARK: - CachedLocationRow

struct CachedLocationRow: View {
    let pin: MapPin

    var body: some View {
        HStack(spacing: 12) {
            // Mini map thumbnail
            Map(
                initialPosition: .camera(
                    MapCamera(
                        centerCoordinate: pin.coordinate.clLocation,
                        distance: 2000
                    )
                )
            ) {
                Annotation("", coordinate: pin.coordinate.clLocation) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.red, .white)
                }
            }
            .disabled(true)
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(pin.locationName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                pin.nickname.map {
                    Text($0)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                HStack(spacing: 6) {
                    Text("\(pin.airQuality.level.emoji) AQI \(pin.airQuality.aqi)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(String(format: "%.3f, %.3f",
                            pin.coordinate.latitude,
                            pin.coordinate.longitude))
                    .font(.caption2)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
