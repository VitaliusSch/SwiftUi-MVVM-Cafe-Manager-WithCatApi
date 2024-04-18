//
//  Date.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 06.09.2023.
//

import Foundation

extension Date {
    /// Calculates months, days, hours, minutes, and seconds beetwen the two Date instances
    /// - Parameters:
    ///   - recent: recent Date
    ///   - previous: previos Date
    /// - Returns: months, days, hours, minutes, and seconds beetwen the two Date instances
    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let totalSeconds = Int(recent.minus(previous: previous))
        let day = totalSeconds / 86400
        let hour = (totalSeconds % 86400) / 3600
        let minute = (totalSeconds % 3600) / 60
        let second = (totalSeconds % 3600) % 60
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    /// Calculates the number of seconds between the two Date instances
    /// - Parameters:
    ///   - previous: previos Date
    /// - Returns: TimeInterval beetwen two dates
    func minus(previous: Date) -> TimeInterval {
        return self.timeIntervalSinceReferenceDate - previous.timeIntervalSinceReferenceDate
    }
    func toString(dateFormat: String = AppConstants.Date.FormatLocalDateTime) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let string = dateFormatter.string(from: self)
        return string
    }
}
