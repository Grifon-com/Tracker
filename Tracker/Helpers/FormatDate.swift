//
//  File.swift
//  FormatDate
//
//  Created by Григорий Машук on 9.10.23.
//

import Foundation

final class FormatDate {
    static let shared = FormatDate()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "e"

        return dateFormatter
    }()
    
    
    func greateWeekDayInt(date: Date) -> Int {
        let weekDayString = dateFormatter.string(from: date)
        let deyWeek = NSString(string: weekDayString).intValue - 1
        return Int(deyWeek)
    }
}
