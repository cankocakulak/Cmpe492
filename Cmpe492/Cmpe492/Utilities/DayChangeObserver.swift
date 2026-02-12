//
//  DayChangeObserver.swift
//  Cmpe492
//
//  Created for Story 3.9 - centralized day change notifications
//

import Foundation
import Combine

@MainActor
final class DayChangeObserver: ObservableObject {
    @Published private(set) var refreshToken: UUID = UUID()

    func bump() {
        refreshToken = UUID()
    }
}
