//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Григорий Машук on 13.12.23.
//

import UIKit

protocol CategoryViewModelProtocol {
    var isSchedul: Bool { get }
    var listSettings: [ChoiceParametrs] { get }
    var dataSection: [Header] { get }
    var emojies: [String] { get }
    var colors: [UIColor] { get }
    
    func reverseIsSchedul()
    func checkingForEmptiness() -> Bool
    func jonedSchedule(schedule: [WeekDay], stringArrayDay: String) -> String
    func setListWeekDay(listWeekDay: [WeekDay])
    func getColorRow(color: UIColor) -> Int
    func getEmojiRow(emoji: String) -> Int
    
    func setSchedule(_ vc: CreateTrackerViewController, schedule: [WeekDay])
    func setColor(_ vc: CreateTrackerViewController, color: UIColor)
    func setNameNewCategory(_ vc: CreateTrackerViewController, nameCategory: String)
    func setNameTracker(_ vc: CreateTrackerViewController, nameTracker: String)
    func setEmojiTracker(_ vc: CreateTrackerViewController, emoji: String)
    func editTracker(vc: CreateTrackerViewController, editTracker: Tracker, nameCategory: String)
}

//MARK: - CategoryViewModel
final class CategoryViewModel {
    var isSchedul: Bool = true
    var listSettings: [ChoiceParametrs] { isSchedul ? [.category] : [.category, .schedule] }
    let dataSection: [Header] = [.emoji, .color]
    let emojies: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                     "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3,.colorSelection4,
                                     .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8,
                                     .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12,
                                     .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16,
                                     .colorSelection17, .colorSelection18]
    
    let regular: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    @Observable<[WeekDay]> private(set) var schedule: [WeekDay] = []
    @Observable<UIColor?> private(set) var color: UIColor?
    @Observable<String> private(set) var nameNewCategory: String = ""
    @Observable<String> private(set) var nameTracker: String = ""
    @Observable<String> private(set) var emoji: String = ""
    private(set) var id: UUID?
    
    private var marshalling: UIColorMarshalling
    
    convenience init() {
        let marshalling = UIColorMarshalling()
        self.init(marshalling: marshalling)
    }
    
    init(marshalling: UIColorMarshalling) {
        self.marshalling = marshalling
    }
}

//MARK: - CategoryViewModelProtocol
extension CategoryViewModel: CategoryViewModelProtocol {
    func checkingForEmptiness() -> Bool {
        var flag: Bool
        if isSchedul {
            flag = !nameTracker.isEmpty &&
            color != nil &&
            !emoji.isEmpty &&
            !nameNewCategory.isEmpty ? true : false
            
            return flag
        }
        flag = !schedule.isEmpty &&
        !nameTracker.isEmpty &&
        color != nil &&
        !emoji.isEmpty &&
        !nameNewCategory.isEmpty ? true : false
        return flag
    }
    
    func reverseIsSchedul() {
        isSchedul = isSchedul ? !isSchedul : isSchedul
    }
    
    func jonedSchedule(schedule: [WeekDay], stringArrayDay: String) -> String {
        var stringListDay: String
        if schedule.count == 7 {
            stringListDay = stringArrayDay
            return stringListDay
        }
        let listDay = schedule.map { $0.briefWordDay }
        stringListDay = listDay.joined(separator: ",")
        
        return stringListDay
    }
    
    func setListWeekDay(listWeekDay: [WeekDay]) {
        schedule = listWeekDay
    }
    
    func getColorRow(color: UIColor) -> Int {
        var colorRow: Int = 0
        for (index, value) in colors.enumerated() {
            let colorMarshalling = marshalling.color(from: marshalling.hexString(from: value))
            if colorMarshalling == color {
                colorRow = index
            }
        }
        return colorRow
    }
    
    func getEmojiRow(emoji: String) -> Int {
        var emojiRow: Int = 0
        for (index, value) in emojies.enumerated() {
            if value == emoji {
                emojiRow = index
            }
        }
        return emojiRow
    }
    
    func setSchedule(_ vc: CreateTrackerViewController, schedule: [WeekDay]) {
        self.schedule = schedule
    }
    
    func setColor(_ vc: CreateTrackerViewController, color: UIColor) {
        self.color = color
    }
    
    func setNameNewCategory(_ vc: CreateTrackerViewController, nameCategory: String) {
        self.nameNewCategory = nameCategory
    }
    
    func setNameTracker(_ vc: CreateTrackerViewController, nameTracker: String) {
        self.nameTracker = nameTracker
    }
    
    func setEmojiTracker(_ vc: CreateTrackerViewController, emoji: String) {
        self.emoji = emoji
    }
    
    func editTracker(vc: CreateTrackerViewController, editTracker: Tracker, nameCategory: String) {
        schedule = editTracker.schedule
        color = editTracker.color
        nameNewCategory = nameCategory
        nameTracker = editTracker.name
        emoji = editTracker.emoji
        id = editTracker.id
    }
}

