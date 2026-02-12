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
    private static var timers: [String: CFAbsoluteTime] = [:]
    private static let timerLock = NSLock()

    @discardableResult
    static func measure<T>(_ name: String, block: () throws -> T) rethrows -> T {
        let start = CFAbsoluteTimeGetCurrent()
        let result = try block()
        let durationMs = (CFAbsoluteTimeGetCurrent() - start) * 1000
        logger.debug("\(name, privacy: .public) took \(durationMs, privacy: .public) ms")
        return result
    }

    static func start(_ name: String) {
        timerLock.lock()
        timers[name] = CFAbsoluteTimeGetCurrent()
        timerLock.unlock()
    }

    static func end(_ name: String) {
        timerLock.lock()
        let start = timers.removeValue(forKey: name)
        timerLock.unlock()
        guard let start else { return }
        let durationMs = (CFAbsoluteTimeGetCurrent() - start) * 1000
        logger.debug("\(name, privacy: .public) duration \(durationMs, privacy: .public) ms")
    }
}
