//
//  Header.swift
//  Tracker
//
//  Created by Григорий Машук on 15.10.23.
//

enum Header: String {
    case color
    case emoji = "Emoji"
    
    var name: String {
        var name: String
        switch self {
        case .color:
            name = Translate.colorHeader
        case .emoji:
            name = self.rawValue
        }
        return name
    }
}
