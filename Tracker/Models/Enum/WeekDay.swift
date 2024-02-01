//
//  WeekDay.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

enum WeekDay: Int {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday = 0
    
    var day: String {
        var day: String
        switch self {
        case .monday:
            day = Translate.monday
        case .tuesday:
            day = Translate.tuesday
        case .wednesday:
            day = Translate.wednesday
        case .thursday:
            day = Translate.thursday
        case .friday:
            day = Translate.friday
        case .saturday:
            day = Translate.saturday
        case .sunday:
            day = Translate.sunday
        }
        return day
    }
    
    var briefWordDay: String {
        var briefWordDay: String
        switch self {
        case .monday:
            briefWordDay = Translate.briefMonday
        case .tuesday:
            briefWordDay = Translate.briefTuesday
        case .wednesday:
            briefWordDay = Translate.briefWednesday
        case .thursday:
            briefWordDay = Translate.briefThursday
        case .friday:
            briefWordDay = Translate.briefFriday
        case .saturday:
            briefWordDay = Translate.briefSaturday
        case .sunday:
            briefWordDay = Translate.briefSunday
        }
        return briefWordDay
    }
}

extension WeekDay: Codable { }
