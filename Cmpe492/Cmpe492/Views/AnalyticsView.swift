//
//  AnalyticsView.swift
//  Cmpe492
//
//  Created for Story 6.1 - Analytics view structure
//

import SwiftUI
import CoreData

struct AnalyticsView: View {
    @StateObject private var viewModel: AnalyticsViewModel

    @MainActor
    init(viewModel: AnalyticsViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: AnalyticsViewModel())
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    metricRow(text: "\(viewModel.todayCount) tasks completed today", emphasize: true)
                } header: {
                    Text("Today")
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                Section {
                    metricRow(text: "\(viewModel.weekCount) tasks completed this week")
                } header: {
                    Text("This Week")
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                Section {
                    metricRow(text: "\(viewModel.monthCount) tasks completed this month")
                } header: {
                    Text("This Month")
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                Section {
                    Text(viewModel.trendMessage)
                        .font(.body)
                        .foregroundStyle(trendColor)
                } header: {
                    Text("Trends")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Analytics")
            .background(Color(.systemBackground))
        }
    }

    private var trendColor: Color {
        switch viewModel.trendDirection {
        case .up:
            return .green
        case .down:
            return .red
        case .same:
            return .secondary
        case .none:
            return .secondary
        }
    }

    @ViewBuilder
    private func metricRow(text: String, emphasize: Bool = false) -> some View {
        Text(text)
            .font(.body)
            .foregroundStyle(emphasize ? Color.primary : Color.primary)
    }
}

#Preview {
    AnalyticsView(viewModel: AnalyticsViewModel(context: PersistenceController.preview.container.viewContext))
}
