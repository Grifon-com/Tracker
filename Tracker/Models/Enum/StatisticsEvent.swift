//
//  StatisticsEvent.swift
//  Tracker
//
//  Created by Григорий Машук on 5.01.24.
//

import Foundation

enum StatisticsEvent: String {
    case bestPeriod
    case perfectDays
    case trackersCompleted
    case averageValue
    
    var statisticName: String {
        var statisticName = ""
        switch self {
        case .bestPeriod:
            statisticName = NSLocalizedString(self.rawValue, comment: "")
        case .perfectDays:
            statisticName = NSLocalizedString(self.rawValue, comment: "")
        case .trackersCompleted:
            statisticName = NSLocalizedString(self.rawValue, comment: "")
        case .averageValue:
            statisticName = NSLocalizedString(self.rawValue, comment: "")
        }
        
        return statisticName
    }
}
