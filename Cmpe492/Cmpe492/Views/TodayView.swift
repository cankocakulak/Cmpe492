//
//  TodayView.swift
//  Cmpe492
//
//  Created for Story 1.4 - default Today view with task list
//

import SwiftUI
import CoreData
import UIKit

struct TodayView: View {
    @StateObject private var viewModel: TaskViewModel
    @State private var inputText: String = ""
    private let focusTrigger: AnyHashable?

    @MainActor
    init(viewModel: TaskViewModel? = nil, focusTrigger: AnyHashable? = nil) {
        self.focusTrigger = focusTrigger
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: TaskViewModel(filter: .today))
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PersistentInputField(text: $inputText, focusTrigger: focusTrigger) {
                    let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    viewModel.createTask(text: trimmed)
                    inputText = ""
                }

                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRow(task: task)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparatorTint(Color(.separator))
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if viewModel.tasks.isEmpty {
                        emptyStateView(
                            message: L10n.emptyToday
                        )
                    }
                }
            }
            .navigationTitle("Today")
            .background(Color(.systemBackground))
            .onChange(of: viewModel.restoreInputText) { restored in
                guard let restored else { return }
                inputText = restored
                viewModel.clearRestoreInput()
            }
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                viewModel.refreshForNewDay()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                viewModel.refreshForNewDay()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.refreshForNewDay()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private func emptyStateView(message: String) -> some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
    }
}

#Preview {
    TodayView(viewModel: TaskViewModel(context: PersistenceController.preview.container.viewContext, filter: .today))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
