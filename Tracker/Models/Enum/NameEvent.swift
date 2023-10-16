//
//  NameEvent.swift
//  Tracker
//
//  Created by Григорий Машук on 10.10.23.
//

import Foundation

enum NameEvent {
    case habit
    case irregularEvent
    
    var name: String {
        var name: String
        switch self {
        case .habit:
            name = "Привычка"
        case .irregularEvent:
            name = "Нерегулярное событие"
        }
        return name
    }
}
