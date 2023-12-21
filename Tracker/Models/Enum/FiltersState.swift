//
//  FiltersTracker.swift
//  Tracker
//
//  Created by Григорий Машук on 17.12.23.
//

import Foundation

enum FiltersState: String {
    case allTrackers
    case toDayTrackers
    case completed
    case notCompleted
    
    var name: String {
        var name = ""
        switch self {
        case .allTrackers:
            name = NSLocalizedString(self.rawValue, comment: "")
        case .toDayTrackers:
            name = NSLocalizedString(self.rawValue, comment: "")
        case .completed:
            name = NSLocalizedString(self.rawValue, comment: "")
        case .notCompleted:
            name = NSLocalizedString(self.rawValue, comment: "")
        }
        return name
    }
}
