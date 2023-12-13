//
//  WeekDay.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

import Foundation

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
            day = NSLocalizedString("monday.complete", comment: "")
        case .tuesday:
            day = NSLocalizedString("tuesday.complete", comment: "")
        case .wednesday:
            day = NSLocalizedString("wednesday.complete", comment: "")
        case .thursday:
            day = NSLocalizedString("thursday.complete", comment: "")
        case .friday:
            day = NSLocalizedString("friday.complete", comment: "")
        case .saturday:
            day = NSLocalizedString("saturday.complete", comment: "")
        case .sunday:
            day = NSLocalizedString("sunday.complete", comment: "")
        }
        return day
    }
    
    var briefWordDay: String {
        var briefWordDay: String
        switch self {
        case .monday:
            briefWordDay = NSLocalizedString("monday", comment: "")
        case .tuesday:
            briefWordDay = NSLocalizedString("tuesday", comment: "")
        case .wednesday:
            briefWordDay = NSLocalizedString("wednesday", comment: "")
        case .thursday:
            briefWordDay = NSLocalizedString("thursday", comment: "")
        case .friday:
            briefWordDay = NSLocalizedString("friday", comment: "")
        case .saturday:
            briefWordDay = NSLocalizedString("saturday", comment: "")
        case .sunday:
            briefWordDay = NSLocalizedString("sunday", comment: "")
        }
        return briefWordDay
    }
}

extension WeekDay: Codable { }
