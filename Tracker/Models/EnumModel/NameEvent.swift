//
//  Event.swift
//  Tracker
//
//  Created by Марина Машук on 2.10.23.
//

import Foundation

enum NameEvent {
    case habit
    case irregularEvent
    
    var event: String {
        switch self {
        case .habit:
            return "Привычка"
        case .irregularEvent:
            return "Неркгулярное событие"
        }
    }
}
