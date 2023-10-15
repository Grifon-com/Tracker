//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

import Foundation

struct TrackerRecord {
    let id: UUID
    let date: Date
}

extension TrackerRecord: Hashable {
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.id == rhs.id && lhs.date == rhs.date
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
    }
}
