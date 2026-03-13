// Authored by Jayden Lewis on 07/02/2026
// Date formatting utilities for Taskit

import Foundation

enum TaskDateStyle {
    case weekdayAbbrevMonthDay
}

extension Date {

    func formatted(using style: TaskDateStyle) -> String {

        let df = DateFormatter()
        df.locale = .current

        switch style {
        case .weekdayAbbrevMonthDay:
            df.dateFormat = "EEEE, MMM d"
        }

        return df.string(from: self)
    }

    /// Example: "Sunday, January 25th - 2:00 PM"
    func formattedDueDate() -> String {

        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)

        let dayWithSuffix = "\(day)\(daySuffix(day))"

        let weekday = formatted(.dateTime.weekday(.wide))
        let month = formatted(.dateTime.month(.wide))
        let time = formatted(.dateTime.hour().minute())

        return "\(weekday), \(month) \(dayWithSuffix) - \(time)"
    }

    private func daySuffix(_ day: Int) -> String {
        let tens = day % 100
        if tens >= 11 && tens <= 13 { return "th" }

        switch day % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}

extension Int {
    func minutesToFriendlyString() -> String {
        if self < 60 {
            return "\(self) minute\(self == 1 ? "" : "s")"
        }

        let hours = self / 60
        let remainder = self % 60

        if remainder == 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s")"
        } else {
            return "\(hours) hour\(hours == 1 ? "" : "s") \(remainder) min"
        }
    }
}
