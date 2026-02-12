//
//  ContentViewTests.swift
//  Cmpe492Tests
//
//  Created for Story 2.1 - TabView navigation scaffolding
//

import XCTest
@testable import Cmpe492

final class ContentViewTests: XCTestCase {
    func testMainTabLabelsAndSymbols() throws {
        XCTAssertEqual(MainTab.inbox.title, "Inbox")
        XCTAssertEqual(MainTab.today.title, "Today")
        XCTAssertEqual(MainTab.upcoming.title, "Upcoming")

        XCTAssertEqual(MainTab.inbox.systemImage, "tray")
        XCTAssertEqual(MainTab.today.systemImage, "sun.max")
        XCTAssertEqual(MainTab.upcoming.systemImage, "calendar")
    }

    func testContentViewDefaultTabIsToday() throws {
        XCTAssertEqual(ContentView.defaultTab, .today)
    }

    func testSwipeAnimationDurationMatchesRequirement() throws {
        XCTAssertEqual(ContentView.swipeAnimationDuration, 0.3, accuracy: 0.0001)
    }
}
