//
//  LocationDetailView.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @State var viewModel: LocationDetailViewModel
    let onSave: (MapPin) -> Void
    @State var coordinator: AppCoordinator
    @FocusState private var isNicknameFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Map preview
                mapPreview

                // Location Info Card
                locationCard

                // Nickname Section
                nicknameSection

                // Buttons
                actionButtons
            }
            .padding(20)
        }
        .navigationTitle("Location \(viewModel.slot.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isNicknameFocused = false }
            }
        }
    }

    // MARK: - Subviews

    private var mapPreview: some View {
        Map(
            initialPosition: .camera(
                MapCamera(
                    centerCoordinate: viewModel.pin.coordinate.clLocation,
                    distance: 1000
                )
            )
        ) {
            Annotation("", coordinate: viewModel.pin.coordinate.clLocation) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundStyle(.red, .white)
            }
        }
        .disabled(true)
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 4)
    }

    private var locationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Location Name
            HStack {
                Image(systemName: "location.fill")
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Location")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(viewModel.pin.locationName)
                        .font(.headline)
                }
                Spacer()
            }

            Divider()

            // AQI Info
            HStack {
                Text(viewModel.pin.airQuality.level.emoji)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Air Quality Index")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(viewModel.pin.airQuality.aqi)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(viewModel.pin.airQuality.level.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }

            Divider()

            // Coordinates
            HStack {
                Image(systemName: "globe")
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Coordinates")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.4f, %.4f",
                                viewModel.pin.coordinate.latitude,
                                viewModel.pin.coordinate.longitude))
                        .font(.subheadline)
                        .fontDesign(.monospaced)
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Nickname (optional)")
                .font(.headline)

            TextField("Enter a nickname...", text: $viewModel.nickname)
                .textFieldStyle(.plain)
                .focused($isNicknameFocused)
                .onChange(of: viewModel.nickname) { _, new in
                    _ = viewModel.handle(.nicknameChanged(new))
                }
                .padding(14)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isNicknameFocused ? Color.blue : Color.clear, lineWidth: 1.5)
                )

            HStack {
                Spacer()
                Text("\(viewModel.nickname.count)/20")
                    .font(.caption)
                    .foregroundStyle(viewModel.nickname.count >= 20 ? .red : .secondary)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                if let updated = viewModel.handle(.saveTapped) {
                    onSave(updated)
                    dismiss()
                }
            } label: {
                Label("Save", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }

            Button {
                if let pin = viewModel.handle(.skipTapped) {
                    onSave(pin)
                    dismiss()
                }
            } label: {
                Text("Skip")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.secondary.opacity(0.15), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(.primary)
            }
        }
    }
}

