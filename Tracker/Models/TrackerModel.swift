//
//  TrackerModel.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    
    init(id: UUID = UUID() , name: String, color: UIColor, emoji: String, schedule: [WeekDay]) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}

extension Tracker: Equatable {
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
            lhs.id == rhs.id
    }
}

extension Tracker: Hashable {}

