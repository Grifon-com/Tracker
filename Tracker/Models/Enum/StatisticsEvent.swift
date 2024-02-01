//
//  StatisticsEvent.swift
//  Tracker
//
//  Created by Григорий Машук on 5.01.24.
//

enum StatisticsEvent: String {
    case bestPeriod
    case perfectDays
    case trackersCompleted
    case averageValue
    
    var statisticName: String {
        var statisticName = ""
        switch self {
        case .bestPeriod:
            statisticName = Translate.bestPeriod
        case .perfectDays:
            statisticName = Translate.perfectDays
        case .trackersCompleted:
            statisticName = Translate.trackersCompleted
        case .averageValue:
            statisticName = Translate.averageValue
        }
        
        return statisticName
    }
}
