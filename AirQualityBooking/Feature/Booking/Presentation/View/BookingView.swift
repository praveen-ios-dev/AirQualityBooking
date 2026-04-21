//
//  BookingView.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI

struct BookingView: View {
    @State var viewModel: BookingViewModel
    @State var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection

                    // Location Cards
                    locationComparisonSection

                    // Price / Result
                    resultSection
                }
                .padding(20)
            }

            Spacer(minLength: 0)

            // Bottom buttons
            bottomButtons
                .padding(20)
        }
        .navigationTitle("Booking")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isSuccess)
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "car.fill")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
            Text("Confirm Your Booking")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding(.top, 10)
    }

    private var locationComparisonSection: some View {
        VStack(spacing: 12) {
            locationCard(pin: viewModel.pinA, label: "A", color: .blue)

            HStack {
                Divider()
                Image(systemName: "arrow.down")
                    .foregroundStyle(.secondary)
                Divider()
            }
            .frame(height: 20)

            locationCard(pin: viewModel.pinB, label: "B", color: .green)
        }
    }

    private func locationCard(pin: MapPin, label: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(color, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(pin.locationName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                HStack(spacing: 8) {
                    Text("\(pin.airQuality.level.emoji) AQI \(pin.airQuality.aqi)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.3f, %.3f",
                                pin.coordinate.latitude,
                                pin.coordinate.longitude))
                        .font(.caption2)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.tertiary)
                }
                pin.nickname.map{
                    Text($0)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            Spacer()
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    @ViewBuilder
    private var resultSection: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()

        case .loading:
            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Processing...")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

        case .success(let record):
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.green)
                Text("Booking Confirmed!")
                    .font(.title3)
                    .fontWeight(.bold)

                Divider()

                HStack {
                    Text("Total Price")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("₩\(Int(record.price).formatted())")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
            }
            .padding(20)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .transition(.scale.combined(with: .opacity))

        case .failure(let message):
            VStack(spacing: 10) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.red)
                Text("Booking Failed")
                    .fontWeight(.semibold)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var bottomButtons: some View {
        VStack(spacing: 12) {
            if isSuccess {
                Button {
                    coordinator.navigateToHistory()
                } label: {
                    Label("View History", systemImage: "clock.arrow.circlepath")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.orange, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }

                Button {
                    coordinator.resetToRoot()
                } label: {
                    Text("Back to Home")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.secondary.opacity(0.15), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            } else if viewModel.state == .loading {
                // No buttons while loading
            } else {
                Button {
                    viewModel.handle(.confirmTapped)
                } label: {
                    Label("Confirm Booking", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.orange, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
            }
        }
        .animation(.spring(duration: 0.3), value: viewModel.state)
    }

    private var isSuccess: Bool {
        if case .success = viewModel.state { return true }
        return false
    }
}
