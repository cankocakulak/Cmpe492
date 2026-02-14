import Foundation
import CoreData

struct TaskExport: Codable {
    let id: UUID
    let text: String
    let createdAt: Date
    let updatedAt: Date
    let scheduledDate: Date?
    let completedAt: Date?
    let state: String
    let sortOrder: Double
}

struct ExportPayload: Codable {
    let exportedAt: Date
    let tasks: [TaskExport]
}

enum ExportService {
    static func exportFileURL(context: NSManagedObjectContext) throws -> URL {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let tasks = try context.fetch(request)

        let exports = tasks.compactMap { task -> TaskExport? in
            guard let id = task.id,
                  let text = task.text,
                  let createdAt = task.createdAt,
                  let updatedAt = task.updatedAt else { return nil }

            return TaskExport(
                id: id,
                text: text,
                createdAt: createdAt,
                updatedAt: updatedAt,
                scheduledDate: task.scheduledDate,
                completedAt: task.completedAt,
                state: task.state.displayName,
                sortOrder: task.sortOrder ?? 0
            )
        }

        let payload = ExportPayload(exportedAt: Date(), tasks: exports)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(payload)
        let filename = "cmpe492-export-\(formattedDate()).json"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: url, options: [.atomic])
        return url
    }

    private static func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return formatter.string(from: Date())
    }
}
