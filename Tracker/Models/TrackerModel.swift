//
//  TrackerModel.swift
//  Tracker
//
//  Created by Григрий Машук on 2.10.23.
//

import UIKit

struct Tracker {
    var id: UInt = UInt(0.0)
    let name: String
    let color: UIColor
    let emoji: String
    
    init(name: String, color: UIColor, emoji: String) {
        self.id += UInt(0.1)
        self.name = name
        self.color = color
        self.emoji = emoji
    }
}
