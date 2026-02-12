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
        let tomorrow = startOfTomorrow(for: referenceDate)
        if calendar.isDate(date, inSameDayAs: tomorrow) {
            return "Tomorrow"
        }
        return monthDayFormatter.string(from: date)
    }
}
