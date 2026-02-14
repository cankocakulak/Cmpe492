import SwiftUI
import CoreData

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(sortDescriptors: [])
    private var tasks: FetchedResults<Task>

    @State private var snapshot = AnalyticsSnapshot(
        completedToday: 0,
        completedWeek: 0,
        completedMonth: 0,
        completedLastWeek: 0,
        completedLastMonth: 0
    )
    @State private var shareURL: URL?
    @State private var showShareSheet = false
    @State private var exportError: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    AnalyticsCard(title: "Completed Today", value: snapshot.completedToday)
                    AnalyticsCard(title: "Completed This Week", value: snapshot.completedWeek, trend: trendText(current: snapshot.completedWeek, previous: snapshot.completedLastWeek))
                    AnalyticsCard(title: "Completed This Month", value: snapshot.completedMonth, trend: trendText(current: snapshot.completedMonth, previous: snapshot.completedLastMonth))

                    Button(action: exportJSON) {
                        Label("Export JSON", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding(16)
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            refreshSnapshot()
        }
        .onChange(of: tasks.count) { _ in
            refreshSnapshot()
        }
        .sheet(isPresented: $showShareSheet) {
            if let shareURL {
                ShareSheet(activityItems: [shareURL])
            }
        }
        .alert("Export Failed", isPresented: Binding(get: {
            exportError != nil
        }, set: { _ in
            exportError = nil
        })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(exportError ?? "")
        }
    }

    private func refreshSnapshot() {
        snapshot = AnalyticsService.snapshot(context: context)
    }

    private func exportJSON() {
        do {
            shareURL = try ExportService.exportFileURL(context: context)
            showShareSheet = true
        } catch {
            exportError = "Unable to export JSON."
        }
    }

    private func trendText(current: Int, previous: Int) -> String {
        let delta = current - previous
        if delta == 0 {
            return "No change from last period"
        }
        if delta > 0 {
            return "+\(delta) from last period"
        }
        return "\(delta) from last period"
    }
}

private struct AnalyticsCard: View {
    let title: String
    let value: Int
    var trend: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.title.bold())
            if let trend {
                Text(trend)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}
