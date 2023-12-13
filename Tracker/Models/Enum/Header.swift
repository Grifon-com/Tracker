//
//  Header.swift
//  Tracker
//
//  Created by Григорий Машук on 15.10.23.
//

import Foundation

enum Header {
    case color
    case emoji
    
    var name: String {
        var name: String
        switch self {
        case .color:
            name = NSLocalizedString("stringColor", comment: "")
        case .emoji:
            name = "Emoji"
        }
        return name
    }
}
