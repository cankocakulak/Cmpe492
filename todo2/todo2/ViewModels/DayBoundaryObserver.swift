import Foundation
import Combine

final class DayBoundaryObserver: ObservableObject {
    @Published private(set) var todayStart: Date

    private var timer: Timer?
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.todayStart = calendar.startOfDay(for: Date())
        scheduleMidnightTimer()
    }

    private func scheduleMidnightTimer() {
        timer?.invalidate()
        let now = Date()
        let nextMidnight = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) ?? now.addingTimeInterval(24 * 60 * 60)

        timer = Timer(fireAt: nextMidnight, interval: 0, target: self, selector: #selector(handleMidnight), userInfo: nil, repeats: false)
        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    @objc private func handleMidnight() {
        todayStart = calendar.startOfDay(for: Date())
        scheduleMidnightTimer()
    }
}
