//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Григорий Машук on 24.12.23.
//

import Foundation
import YandexMobileMetrica

protocol AnalyticsServiceProtocol {
    static func reportEvent(field: MetricEvent)
}

struct AnalyticsService: AnalyticsServiceProtocol {
    static func reportEvent(field: MetricEvent) {
        YMMYandexMetrica.reportEvent(field.event.rawValue,
                                     parameters: field.params,
                                     onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)})
    }
}
