//
//  HistoryView.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI

struct HistoryView: View {
    @State var viewModel: HistoryViewModel
    @State var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 0) {
            // Summary Header
            summaryHeader
                .padding(20)
                .background(.regularMaterial)

            // List
            Group {
                switch viewModel.loadState {
                case .idle, .loading:
                    ProgressView("Loading history...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded(let records):
                    if records.isEmpty {
                        emptyState
                    } else {
                        recordsList(records: records)
                    }

                case .failure(let message):
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text(message)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
        }
        .navigationTitle("This Month")
        .navigationBarTitleDisplayMode(.inline)
        .task { viewModel.handle(.onAppear) }
    }

    // MARK: - Subviews

    private var summaryHeader: some View {
        HStack(spacing: 20) {
            statCard(
                value: "\(viewModel.totalCount)",
                label: "Total Rides",
                icon: "car.fill",
                color: .blue
            )
            Divider().frame(height: 40)
            statCard(
                value: "₩\(Int(viewModel.totalPrice).formatted())",
                label: "Total Spent",
                icon: "wonsign.circle.fill",
                color: .orange
            )
        }
        .frame(maxWidth: .infinity)
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "car.rear.and.tire.marks")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No rides this month")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Your booking history will appear here.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func recordsList(records: [BookRecord]) -> some View {
        List(records) { record in
            BookRecordRow(record: record)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .onTapGesture {
                    coordinator.goToMapWith(record: record)
                }
        }
        .listStyle(.plain)
    }
}

// MARK: - BookRecordRow

struct BookRecordRow: View {
    let record: BookRecord

    var body: some View {
        VStack(spacing: 12) {
            locationRow(
                location: record.locationA,
                label: "A",
                color: .blue
            )

            HStack {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 1)
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 1)
            }

            locationRow(
                location: record.locationB,
                label: "B",
                color: .green
            )

            HStack {
                Spacer()
                Text("₩\(Int(record.price).formatted())")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func locationRow(location: BookedLocation, label: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(color, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(location.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(String(format: "%.3f, %.3f",
                                location.coordinate.latitude,
                                location.coordinate.longitude))
                        .font(.caption2)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.tertiary)
                    Text("· AQI \(location.aqi)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
}

