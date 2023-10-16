//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Григорий Машук on 2.10.23.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
}

//extension TrackerRecord: Hashable {
//    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
//        return lhs.id == rhs.id
//    }
//}



//extension TrackerRecord: Equatable, Hashable {
//    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
//        let idResult = lhs.id == rhs.id
//        let lhsDate = lhs.date.ignoringTime ?? Date()
//        let rhsDate = rhs.date.ignoringTime ?? Date()
//        let date = Calendar.current.compare(lhsDate, to: rhsDate, toGranularity: .day)
//        var dateResult: Bool
//        if case .orderedSame = date {
//                dateResult = true
//            } else {
//                dateResult = false
//            }
//
//        return idResult && dateResult
//    }
//}

//    let idResult = lhs.id == rhs.id
//    let lhsDate = lhs.date.ignoringTime ?? Date()
//    let rhsDate = rhs.date.ignoringTime ?? Date()
//    let date = Calendar.current.compare(lhsDate, to: rhsDate, toGranularity: .day)
//    var dateResult: Bool
//    if case .orderedSame = date {
//        dateResult = true
//    } else {
//        dateResult = false
//    }
//    return idResult && dateResult
//}
