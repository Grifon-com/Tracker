//
//  WeekDay.swift
//  Tracker
//
//  Created by Марина Машук on 2.10.23.
//

import Foundation

enum WeekDay {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var day: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return  "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return  "Пятница"
        case .saturday:
            return  "Суббота"
        case .sunday:
            return  "Воскресенье"
        }
    }
}
