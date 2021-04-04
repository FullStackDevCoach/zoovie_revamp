//
//  Date+Extensions.swift
//  CAMELOT
//
//  Created by abc on 5/5/20.
//  Copyright © 2020 ZOOVIE. All rights reserved.
//

import UIKit

extension Date {

    struct CamelotDateFormat {
        static let shortDate = "EEEE MMM dd"
        static let shortTime = "HH:mm"
        static let eventFilterDate = "MMM dd"
        static let simpleDate = "dd/MM/YYYY"
    }
    
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date())
    }
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    var isInTheFuture: Bool {
        return Date() < self
    }
    var isInThePast: Bool {
        return self < Date()
    }

    static func autoConvertDateString(dateString: String, format: String) -> String? {
        if dateString.count == 0 {
            return nil
        }
        let formater = DateFormatter()
        formater.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        formater.dateFormat = "yyyyMMdd"
        let date = formater.date(from: dateString)
        formater.dateFormat = format
        if date == nil {
            print("unable to parse date using format->>\(format)")
        } else {
            let stringDate = formater.string(from: date!)
            return stringDate
        }
        return nil
    }

    func getCommonDateString() -> String {
        let format = "HH:mm:ss dd/MM/yyyy"
        let formater = DateFormatter.init()
        formater.dateFormat = format
        return formater.string(from: self as Date)
    }

    func toFormat(output: String) -> String {
        let format = output
        let formater = DateFormatter.init()
        formater.dateFormat = format
        return formater.string(from: self as Date)
    }

    func toCommonFormat() -> String {
        return self.toFormat(output: "HH:mm, EEE dd-MM-yyyy")
    }

    var timeStamp: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }

}
