//
//  TaskDragPayload.swift
//  Cmpe492
//
//  Created for internal task drag/drop payload typing.
//

import Foundation
import UniformTypeIdentifiers

enum TaskDragPayload {
    static let type = UTType(importedAs: "com.kantakademi.cmpe492.task-id")

    static func itemProvider(for taskID: UUID?) -> NSItemProvider {
        let provider = NSItemProvider()
        let payload = (taskID?.uuidString ?? "").data(using: .utf8) ?? Data()
        provider.registerDataRepresentation(
            forTypeIdentifier: type.identifier,
            visibility: .all
        ) { completion in
            completion(payload, nil)
            return nil
        }
        return provider
    }
}
