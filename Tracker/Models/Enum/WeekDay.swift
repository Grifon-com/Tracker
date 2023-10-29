//
//  WeekDay.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

import Foundation

enum WeekDay: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var day: String {
        var day: String
        switch self {
        case .monday:
            day = "Понедельник"
        case .tuesday:
            day = "Вторник"
        case .wednesday:
            day = "Среда"
        case .thursday:
            day = "Четверг"
        case .friday:
            day = "Пятница"
        case .saturday:
            day = "Суббота"
        case .sunday:
            day = "Воскресенье"
        }
        return day
    }
    
    var briefWordDay: String {
        var briefWordDay: String
        switch self {
        case .monday:
            briefWordDay = "Пн"
        case .tuesday:
            briefWordDay = "Вт"
        case .wednesday:
            briefWordDay = "Ср"
        case .thursday:
            briefWordDay = "Чт"
        case .friday:
            briefWordDay = "Пт"
        case .saturday:
            briefWordDay = "Сб"
        case .sunday:
            briefWordDay = "Вс"
        }
        return briefWordDay
    }
}

extension WeekDay: Codable { }
