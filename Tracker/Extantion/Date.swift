//
//  Date.swift
//  Tracker
//
//  Created by Марина Машук on 15.10.23.
//

import Foundation

extension Date {
    var ignoringTime: Date? {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
