//
//  ChoiceParametrs.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

enum ChoiceParametrs: String {
    case category
    case schedule
    
    var name: String {
        var name: String
        switch self {
        case .category:
            name = Translate.category
        case .schedule:
            name = Translate.schedule
        }
        return name
    }
}
