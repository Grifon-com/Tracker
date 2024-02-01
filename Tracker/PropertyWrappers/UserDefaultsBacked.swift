//
//  UserDefaultsBacked.swift
//  Tracker
//
//  Created by Григорий Машук on 31.10.23.
//

import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String
    var storage: UserDefaults = .standard
    var wrappedValue: Value? {
        get {
            storage.value(forKey:key) as? Value
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
}
