//
//  AnalyticsViewModelTests.swift
//  Cmpe492Tests
//
//  Created for Story 6.x - analytics counts and trends
//

import XCTest
import Foundation
import CoreData
@testable import Cmpe492

@MainActor
final class AnalyticsViewModelTests: XCTestCase {
    private var controller: PersistenceController!
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        controller = PersistenceController(inMemory: true)
        context = controller.container.viewContext
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        calendar.firstWeekday = 2
        return calendar
    }

    private func insertCompletedTask(at date: Date, id: UUID = UUID()) throws {
        let task = Task(context: context)
        task.id = id
        task.text = "Done"
        task.state = TaskState.completed.rawValue
        task.createdAt = date
        task.updatedAt = date
        task.completedAt = date
        task.scheduledDate = nil
        task.sortOrder = 0
        try context.save()
    }

    private func waitForRefresh() {
        let exp = expectation(description: "wait for refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testTodayCountUsesCompletedAtRange() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 12))!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!

        try insertCompletedTask(at: now)
        try insertCompletedTask(at: yesterday)

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.todayCount, 1)
    }

    func testWeekCountRespectsLocaleWeekBoundary() throws {
        var calendar = makeCalendar()
        calendar.firstWeekday = 2
        let monday = calendar.date(from: DateComponents(year: 2026, month: 2, day: 9, hour: 9))!
        let sunday = calendar.date(byAdding: .day, value: -1, to: monday)!

        try insertCompletedTask(at: monday)
        try insertCompletedTask(at: sunday)

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { monday })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.weekCount, 1)
    }

    func testMonthCountIncludesCurrentMonthOnly() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 15, hour: 12))!
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!

        try insertCompletedTask(at: now)
        try insertCompletedTask(at: lastMonth)

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.monthCount, 1)
    }

    func testTrendMessageNoDataYet() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 12))!

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.trendMessage, "No data available yet")
        XCTAssertEqual(viewModel.trendDirection, .none)
    }

    func testTrendMessageNoDataFromLastMonth() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 12))!

        try insertCompletedTask(at: now)

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.trendMessage, "No data from last month")
        XCTAssertEqual(viewModel.trendDirection, .none)
    }

    func testTrendMessageUp() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 20, hour: 12))!
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: now)!

        try insertCompletedTask(at: lastMonthDate)
        try insertCompletedTask(at: now)
        try insertCompletedTask(at: now.addingTimeInterval(60))

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.trendDirection, .up)
    }

    func testTrendMessageDown() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 20, hour: 12))!
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: now)!

        try insertCompletedTask(at: lastMonthDate)
        try insertCompletedTask(at: lastMonthDate.addingTimeInterval(60))
        try insertCompletedTask(at: now)

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.trendDirection, .down)
    }

    func testTrendMessageSame() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 20, hour: 12))!
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: now)!

        try insertCompletedTask(at: lastMonthDate)
        try insertCompletedTask(at: now)

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        viewModel.refresh()
        waitForRefresh()

        XCTAssertEqual(viewModel.trendDirection, .same)
    }

    func testCountsRefreshAfterContextChanges() throws {
        let calendar = makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 12))!

        let viewModel = AnalyticsViewModel(context: context, calendar: calendar, nowProvider: { now })
        waitForRefresh()
        XCTAssertEqual(viewModel.todayCount, 0)

        try insertCompletedTask(at: now)
        waitForRefresh()

        XCTAssertEqual(viewModel.todayCount, 1)
    }
}
