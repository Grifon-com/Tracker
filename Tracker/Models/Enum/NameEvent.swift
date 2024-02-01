//
//  NameEvent.swift
//  Tracker
//
//  Created by Григорий Машук on 10.10.23.
//

enum NameEvent {
    case habit
    case irregularEvent
    
    var name: String {
        var name: String
        switch self {
        case .habit:
            name = Translate.nameHabit
        case .irregularEvent:
            name = Translate.nameIrregularEvent
        }
        return name
    }
}
