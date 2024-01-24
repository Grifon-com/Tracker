//
//  ChoiceParametrs.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import Foundation

enum ChoiceParametrs: String {
    case category
    case schedule
    
    var name: String {
        var name: String
        switch self {
        case .category:
            name = NSLocalizedString(self.rawValue, comment: "")
        case .schedule:
            name = NSLocalizedString(self.rawValue, comment: "")
        }
        return name
    }
}
