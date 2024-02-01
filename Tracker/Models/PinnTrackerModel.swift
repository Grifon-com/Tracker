//
//  UnpinModel.swift
//  Tracker
//
//  Created by Григорий Машук on 10.12.23.
//

import Foundation

struct PinnTracker {
    let id: UUID
    let nameCategory: String
}

extension PinnTracker: Equatable, Hashable {
    static func == (lhs: PinnTracker,
                    rhs: PinnTracker) -> Bool {
        lhs.id == rhs.id
    }
}
