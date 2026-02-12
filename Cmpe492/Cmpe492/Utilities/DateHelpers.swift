//
//  DateHelpers.swift
//  Cmpe492
//
//  Created for Story 2.3 - date boundaries and section formatting
//

import Foundation

enum DateHelpers {
    private static var calendar: Calendar { Calendar.current }
    private static let monthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    static func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func startOfTomorrow(for date: Date) -> Date {
        let startOfToday = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? startOfToday
    }

    static func sectionTitle(for date: Date, referenceDate: Date) -> String {
        return monthDayFormatter.string(from: date)
    }

    static func dayInterval(for date: Date, calendar: Calendar = .current) -> DateInterval {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        return DateInterval(start: start, end: end)
    }

    static func weekInterval(for date: Date, calendar: Calendar = .current) -> DateInterval {
        calendar.dateInterval(of: .weekOfYear, for: date) ?? dayInterval(for: date, calendar: calendar)
    }

    static func monthInterval(for date: Date, calendar: Calendar = .current) -> DateInterval {
        calendar.dateInterval(of: .month, for: date) ?? dayInterval(for: date, calendar: calendar)
    }

    static func previousMonthInterval(for date: Date, calendar: Calendar = .current) -> DateInterval? {
        guard let previous = calendar.date(byAdding: .month, value: -1, to: date) else { return nil }
        return calendar.dateInterval(of: .month, for: previous)
    }
}
