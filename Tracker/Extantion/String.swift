//
//  String.swift
//  Tracker
//
//  Created by Григорий Машук on 8.10.23.
//

import Foundation

extension String {
    func firstCharOnly() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
