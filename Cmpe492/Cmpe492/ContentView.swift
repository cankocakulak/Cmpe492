//
//  ContentView.swift
//  Cmpe492
//
//  Created by Murat Can Kocakulak on 12.02.2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    NavigationLink {
                        VStack(alignment: .leading) {
                            Text(task.text ?? "Untitled")
                                .font(.headline)
                            Text("Created: \(task.createdAt!, formatter: dateFormatter)")
                                .font(.caption)
                            Text("State: \(task.state ?? "unknown")")
                                .font(.caption)
                        }
                    } label: {
                        Text(task.text ?? "Untitled")
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addTask) {
                        Label("Add Task", systemImage: "plus")
                    }
                }
            }
            Text("Select a task")
        }
    }

    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.text = "New Task"
            newTask.state = "notStarted"
            newTask.createdAt = Date()
            newTask.updatedAt = Date()
            newTask.sortOrder = Int32(tasks.count)

            do {
                try viewContext.save()
            } catch {
                // Core Data save error - log and display to user
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Core Data deletion error - log and display to user
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
