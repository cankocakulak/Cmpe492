//
//  TodayView.swift
//  Cmpe492
//
//  Created for Story 1.4 - default Today view with task list
//

import SwiftUI
import CoreData

struct TodayView: View {
    @StateObject private var viewModel: TaskViewModel
    @State private var inputText: String = ""

    @MainActor
    init(viewModel: TaskViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: TaskViewModel())
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PersistentInputField(text: $inputText) {
                    let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    viewModel.createTask(text: trimmed)
                    inputText = ""
                }

                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRow(task: task)
                            .listRowSeparatorTint(Color(.separator))
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Today")
            .background(Color(.systemBackground))
            .onChange(of: viewModel.restoreInputText) { restored in
                guard let restored else { return }
                inputText = restored
                viewModel.clearRestoreInput()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    TodayView(viewModel: TaskViewModel(context: PersistenceController.preview.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
