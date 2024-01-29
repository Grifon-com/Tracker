//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

struct TrackerCategory {
    let nameCategory: String
    let arrayTrackers: [Tracker]
    let isPinned: Bool
}

extension TrackerCategory: Hashable {
    static func == (lhs: TrackerCategory,
                    rhs: TrackerCategory) -> Bool {
        lhs.nameCategory == rhs.nameCategory
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nameCategory)
    }
}

