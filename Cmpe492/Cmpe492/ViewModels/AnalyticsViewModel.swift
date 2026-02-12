//
//  AnalyticsViewModel.swift
//  Cmpe492
//
//  Created for Story 6.1 - Analytics view structure and queries
//

import Foundation
import CoreData
import Combine

#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class AnalyticsViewModel: ObservableObject {
    enum TrendDirection {
        case up
        case down
        case same
        case none
    }

    @Published private(set) var todayCount: Int = 0
    @Published private(set) var weekCount: Int = 0
    @Published private(set) var monthCount: Int = 0
    @Published private(set) var lastMonthCount: Int = 0
    @Published private(set) var totalCompletedCount: Int = 0
    @Published private(set) var trendMessage: String = "No data available yet"
    @Published private(set) var trendDirection: TrendDirection = .none

    private let context: NSManagedObjectContext
    private let calendar: Calendar
    private let nowProvider: () -> Date
    private lazy var backgroundContext: NSManagedObjectContext = {
        let background = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        background.persistentStoreCoordinator = context.persistentStoreCoordinator
        background.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return background
    }()

    private var refreshWorkItem: DispatchWorkItem?
    private var observers: [NSObjectProtocol] = []

    init(
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
        calendar: Calendar = .current,
        nowProvider: @escaping () -> Date = Date.init
    ) {
        self.context = context
        self.calendar = calendar
        self.nowProvider = nowProvider

        startObserving()
        refresh()
    }

    deinit {
        let center = NotificationCenter.default
        observers.forEach { center.removeObserver($0) }
    }

    func refresh() {
        scheduleRefresh(delay: 0)
    }

    private func scheduleRefresh(delay: TimeInterval = 0.05) {
        refreshWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.performRefresh()
        }
        refreshWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    private func performRefresh() {
        let now = nowProvider()
        let dayInterval = DateHelpers.dayInterval(for: now, calendar: calendar)
        let weekInterval = DateHelpers.weekInterval(for: now, calendar: calendar)
        let monthInterval = DateHelpers.monthInterval(for: now, calendar: calendar)
        let previousMonthInterval = DateHelpers.previousMonthInterval(for: now, calendar: calendar)

        PerformanceMetrics.start("analytics_refresh")
        backgroundContext.perform { [weak self] in
            guard let self else { return }

            let today = self.countCompleted(in: dayInterval, context: self.backgroundContext)
            let week = self.countCompleted(in: weekInterval, context: self.backgroundContext)
            let month = self.countCompleted(in: monthInterval, context: self.backgroundContext)
            let lastMonth = previousMonthInterval.map { interval in
                self.countCompleted(in: interval, context: self.backgroundContext)
            } ?? 0
            let total = self.countCompleted(in: nil, context: self.backgroundContext)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.todayCount = today
                self.weekCount = week
                self.monthCount = month
                self.lastMonthCount = lastMonth
                self.totalCompletedCount = total
                self.updateTrendMessage(month: month, lastMonth: lastMonth, total: total)
                PerformanceMetrics.end("analytics_refresh")
            }
        }
    }

    private func countCompleted(in interval: DateInterval?, context: NSManagedObjectContext) -> Int {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.resultType = .countResultType

        var predicates: [NSPredicate] = [
            NSPredicate(format: "state == %@", TaskState.completed.rawValue),
            NSPredicate(format: "completedAt != nil")
        ]

        if let interval {
            predicates.append(NSPredicate(format: "completedAt >= %@ AND completedAt < %@", interval.start as NSDate, interval.end as NSDate))
        }

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }

    private func updateTrendMessage(month: Int, lastMonth: Int, total: Int) {
        if total == 0 {
            trendMessage = "No data available yet"
            trendDirection = .none
            return
        }

        if lastMonth == 0 {
            trendMessage = "No data from last month"
            trendDirection = .none
            return
        }

        if month > lastMonth {
            trendMessage = "\(month) tasks this month, up from \(lastMonth) last month"
            trendDirection = .up
        } else if month < lastMonth {
            trendMessage = "\(month) tasks this month, down from \(lastMonth) last month"
            trendDirection = .down
        } else {
            trendMessage = "\(month) tasks this month, same as last month"
            trendDirection = .same
        }
    }

    private func startObserving() {
        let center = NotificationCenter.default
        observers.append(center.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: context,
            queue: .main
        ) { [weak self] _ in
            self?.scheduleRefresh()
        })

        #if canImport(UIKit)
        observers.append(center.addObserver(
            forName: UIApplication.significantTimeChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scheduleRefresh()
        })
        observers.append(center.addObserver(
            forName: .NSSystemTimeZoneDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scheduleRefresh()
        })
        observers.append(center.addObserver(
            forName: .NSCalendarDayChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scheduleRefresh()
        })
        #endif
    }
}
