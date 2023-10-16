//
//  RecordMenager.swift
//  Tracker
//
//  Created by Григорий Машук on 5.10.23.
//

import UIKit

//MARK: - RecordManagerProtocol
protocol RecordManagerProtocol {
    func getCategories() -> [TrackerCategory]
    func updateCategories(newCategories: [TrackerCategory])
    func getWeekDay() -> [WeekDay]
}

//MARK: - RecordManagerStab
final class RecordManagerStab: RecordManagerProtocol {
    static let shared = RecordManagerStab()
    private var categories: [TrackerCategory] = [TrackerCategory(nameCategori: "Важное", arrayTrackers: [
        Tracker(name: "Лес", color: .colorSelection1, emoji: "🏝️", schedule: [  .wednesday, .monday, .sunday]),
        Tracker(name: "Жыве", color: .colorSelection2, emoji: "🙌", schedule: [  .wednesday]),
        Tracker(name: "Вечна", color: .colorSelection3, emoji: "😡", schedule: [ .monday, .wednesday,  .sunday, .saturday]),
        Tracker(name: "Зубр", color: .colorSelection4, emoji: "🍏", schedule: [ .monday, .saturday,]),
        Tracker(name: "Жыве", color: .colorSelection5, emoji: "🏓", schedule: [ .monday,  .thursday, .wednesday]),
        Tracker(name: "Беларусь", color: .colorSelection6, emoji: "😱", schedule: [  .thursday,])
    ])]
    
    private let weekDay: [WeekDay] = [.friday, .monday, .saturday, .sunday, .thursday, .tuesday, .wednesday]
    
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                   "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3,.colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18]
    
    //TODO: Sprint_15
    func getCategories() -> [TrackerCategory] {
        categories
    }
    
    func updateCategories(newCategories: [TrackerCategory]) {
        categories = newCategories
    }
    
    func getWeekDay() -> [WeekDay] {
        return weekDay
    }
}



