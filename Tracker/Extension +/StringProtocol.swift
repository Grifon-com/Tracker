//
//  StringProtocol.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
