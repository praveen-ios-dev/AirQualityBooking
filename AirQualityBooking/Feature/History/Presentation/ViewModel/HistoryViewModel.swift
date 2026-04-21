//
//  HistoryViewModel.swift
//  AirQualityBooking
//
//  Created by Praveen on 21/04/26.
//

import SwiftUI
import Observation

enum HistoryIntent {
    case onAppear
    case recordTapped(BookRecord)
}

enum HistoryLoadState {
    case idle
    case loading
    case loaded([BookRecord])
    case failure(String)
}


@Observable final class HistoryViewModel {
    private(set) var loadState: HistoryLoadState = .idle

    private let fetchHistory: FetchBookHistoryUseCase

    nonisolated init(fetchHistory: FetchBookHistoryUseCase) {
        self.fetchHistory = fetchHistory
    }

    var records: [BookRecord] {
        if case .loaded(let r) = loadState { return r }
        return []
    }

    var totalCount: Int { records.count }

    var totalPrice: Double { records.reduce(0) { $0 + $1.price } }

    func handle(_ intent: HistoryIntent) {
        switch intent {
        case .onAppear:
            Task { await loadHistory() }
        case .recordTapped:
            break // handled by coordinator
        }
    }

    private func loadHistory() async {
        loadState = .loading
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        do {
            let records = try await fetchHistory.execute(year: year, month: month)
            loadState = .loaded(records)
        } catch {
            loadState = .failure(error.localizedDescription)
        }
    }
}
