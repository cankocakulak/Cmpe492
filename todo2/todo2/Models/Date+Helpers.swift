import Foundation

extension Calendar {
    func startOfToday() -> Date {
        startOfDay(for: Date())
    }

    func startOfTomorrow(from date: Date = Date()) -> Date {
        let today = startOfDay(for: date)
        return self.date(byAdding: .day, value: 1, to: today) ?? today
    }

    func startOfYesterday(from date: Date = Date()) -> Date {
        let today = startOfDay(for: date)
        return self.date(byAdding: .day, value: -1, to: today) ?? today
    }

    func isDate(_ date: Date?, inSameDayAs dayStart: Date) -> Bool {
        guard let date else { return false }
        return isDate(date, inSameDayAs: dayStart)
    }
}

extension Date {
    func startOfDay(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }

    func addingDays(_ days: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
}
