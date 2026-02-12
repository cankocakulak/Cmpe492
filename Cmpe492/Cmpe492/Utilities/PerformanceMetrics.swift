//
//  PerformanceMetrics.swift
//  Cmpe492
//
//  Created for Story 1.11 - lightweight performance timing utilities
//

import Foundation
import os

enum PerformanceMetrics {
    private static let logger = Logger(subsystem: "Cmpe492", category: "Performance")

    static func measure(_ name: String, block: () -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        block()
        let durationMs = (CFAbsoluteTimeGetCurrent() - start) * 1000
        logger.debug("\(name, privacy: .public) took \(durationMs, privacy: .public) ms")
    }
}
