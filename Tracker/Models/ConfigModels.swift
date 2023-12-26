//
//  ConfigModels.swift
//  Tracker
//
//  Created by Григорий Машук on 8.11.23.
//

import UIKit

struct CustomCellModel {
    let text: String
    let color: UIColor
}

struct Onboarding {
    let imageName: String
    let textLable: String
}

struct UpdateTracker {
    let count: Int
    let flag: Bool
}

struct StatisticViewModel {
    let item: Int
    let secondaryText: String
}
