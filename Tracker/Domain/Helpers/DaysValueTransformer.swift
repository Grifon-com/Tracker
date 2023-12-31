//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Григорий Машук on 17.10.23.
//

import Foundation

@objc
final class DaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    static func register() {
        ValueTransformer.setValueTransformer(DaysValueTransformer(), forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self)))
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDay].self, from: data as Data)
    }
}
