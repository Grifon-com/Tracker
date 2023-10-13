//
//  RecordMenager.swift
//  Tracker
//
//  Created by Григорий Машук on 5.10.23.
//

import UIKit

//MARK: - RecordManagerProtocol
protocol RecordManagerProtocol {
    var categories: [TrackerCategory] { get }
    var weekDay: [WeekDay] { get }
}

//MARK: - RecordManagerStab
final class RecordManagerStab: RecordManagerProtocol {
    var categories: [TrackerCategory] = [TrackerCategory(nameCategori: "Как сдать 14 спринт", arrayTrackers: [
        Tracker(name: "Лес", color: .colorSelection1, emoji: "🏝️", schedule: [  .wednesday, .monday, .sunday]),
        Tracker(name: "Жыве", color: .colorSelection2, emoji: "🙌", schedule: [  .wednesday]),
        Tracker(name: "Вечна", color: .colorSelection3, emoji: "😡", schedule: [ .monday, .wednesday,  .sunday, .saturday]),
        Tracker(name: "Зубр", color: .colorSelection4, emoji: "🍏", schedule: [ .monday, .saturday,]),
        Tracker(name: "Жыве", color: .colorSelection5, emoji: "🏓", schedule: [ .monday,  .thursday, .wednesday]),
        Tracker(name: "Беларусь", color: .colorSelection6, emoji: "😱", schedule: [  .thursday,]),
        Tracker(name: "Учиться", color: .colorSelection7, emoji: "🍔", schedule: [ .monday, .tuesday, .wednesday])
    ])]
    
    let weekDay: [WeekDay] = [.friday, .monday, .saturday, .sunday, .thursday, .tuesday, .wednesday]
    
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private var visibleCategories: [TrackerCategory]?
    
    //TODO: Sprint_15
    func getCategories() -> [TrackerCategory]? {
        categories
    }
    
    func getVisibleCategories() -> [TrackerCategory]? {
        visibleCategories
    }
    
    func updateCategories(listCategories: [TrackerCategory]) {
        categories = listCategories
    }
    
    func updateVisibleCategories(listCategories: [TrackerCategory]) {
        visibleCategories = listCategories
    }
}





