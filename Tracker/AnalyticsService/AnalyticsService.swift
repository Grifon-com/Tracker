//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Григорий Машук on 24.12.23.
//

import Foundation
import YandexMobileMetrica

protocol AnalyticsServiceProtocol {
    func open()
    func close()
    func addTracker()
    func track()
    func edit()
    func delete()
    func filter() 
}

struct AnalyticsService {
    static let shared = AnalyticsService()
    private let handler: (MetricEvent) -> Void = { field in
        YMMYandexMetrica.reportEvent(field.event.rawValue,
                                     parameters: field.params,
                                     onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
    
extension AnalyticsService: AnalyticsServiceProtocol {
    func open()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue]
        let metricEvent = MetricEvent(event: .open, params: params)
        handler(metricEvent)
    }
    
    func close()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue]
        let metricEvent = MetricEvent(event: .close, params: params)
        handler(metricEvent)
    }
    
    func addTracker()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue,
                      EventFields.item.rawValue: ItemClick.add_track.rawValue]
        let metricEvent = MetricEvent(event: .click, params: params)
        handler(metricEvent)
    }
    
    func track()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue,
                      EventFields.item.rawValue: ItemClick.track.rawValue]
        let metricEvent = MetricEvent(event: .click, params: params)
        handler(metricEvent)
    }
    
    func edit()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue,
                      EventFields.item.rawValue: ItemClick.edit.rawValue]
        let metricEvent = MetricEvent(event: .click, params: params)
        handler(metricEvent)
    }
    
    func delete()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue,
                      EventFields.item.rawValue: ItemClick.delete.rawValue]
        let metricEvent = MetricEvent(event: .click, params: params)
        handler(metricEvent)
    }
    
    func filter()
    {
        let params = [EventFields.screen.rawValue: Screen.Main.rawValue,
                      EventFields.item.rawValue: ItemClick.filter.rawValue]
        let metricEvent = MetricEvent(event: .click, params: params)
        handler(metricEvent)
    }
}
