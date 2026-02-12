//
//  TaskDragPayload.swift
//  Cmpe492
//
//  Created for internal task drag/drop payload typing.
//

import Foundation
import UniformTypeIdentifiers

enum TaskDragPayload {
    static let type = UTType.text

    static func itemProvider(for taskID: UUID?) -> NSItemProvider {
        let payload = taskID?.uuidString ?? ""
        return NSItemProvider(object: payload as NSString)
    }
}
