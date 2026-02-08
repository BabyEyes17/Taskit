// Authored by Jayden Lewis on 07/02/2026
// This utility function is used to format dates with a short term focus: "25/01/2026" -> "Sunday, Jan 25"

import Foundation

enum TaskDateStyle {
    case weekdayAbbrevMonthDay
}

extension Date {
    
    func formatted(using style: TaskDateStyle) -> String {
        
        let df = DateFormatter()
        df.locale = Locale.current

        switch style {
        
        case .weekdayAbbrevMonthDay:
            df.dateFormat = "EEEE, MMM d"
        }

        return df.string(from: self)
    }
}
