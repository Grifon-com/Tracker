//
//  FiltersTracker.swift
//  Tracker
//
//  Created by Григорий Машук on 17.12.23.
//

enum FiltersState: String {
    case allTrackers
    case toDayTrackers
    case completed
    case notCompleted
    
    var name: String {
        var name = ""
        switch self {
        case .allTrackers:
            name = Translate.allTrackers
        case .toDayTrackers:
            name = Translate.toDayTrackers
        case .completed:
            name = Translate.completed
        case .notCompleted:
            name = Translate.notCompleted
        }
        return name
    }
}
