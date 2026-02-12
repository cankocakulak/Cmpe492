//
//  InboxView.swift
//  Cmpe492
//
//  Created for Story 2.2 - Inbox view for timeless tasks
//

import SwiftUI
import CoreData

struct InboxView: View {
    @StateObject private var viewModel: TaskViewModel
    @State private var inputText: String = ""
    private let focusTrigger: AnyHashable?

    @MainActor
    init(viewModel: TaskViewModel? = nil, focusTrigger: AnyHashable? = nil) {
        self.focusTrigger = focusTrigger
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: TaskViewModel(filter: .inbox))
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
                            message: L10n.emptyInbox
                        )
                    }
                }
            }
            .navigationTitle("Inbox")
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
    InboxView(viewModel: TaskViewModel(context: PersistenceController.preview.container.viewContext, filter: .inbox))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
