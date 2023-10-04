//
//  ChoiceParametrs.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import Foundation

enum ChoiceParametrs {
    case category
    case schedule
    
    var name: String {
        switch self {
        case .category:
            return "Категория"
        case .schedule:
            return "Расписание"
        }
    }
}
