//
//  TreckerStore.swift
//  Tracker
//
//  Created by Григорий Машук on 17.10.23.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker
    func trackers(_ objects: [TrackerCoreData]) throws -> [Tracker]
    func deleteTracker(_ trackerCoreData: TrackerCoreData) throws
    func update(_ trackerCoreData: TrackerCoreData, tracker: Tracker) throws
    func addNewTracker(_ tracker: Tracker, nameCategory: String) throws
}

//MARK: - TrackerStore
final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    
    convenience override init() {
        let context = AppDelegate.container.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerStore {
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            fatalError("not found ID")
        }
        
        guard let name = trackerCoreData.name else {
            throw  TrackrerStoreError.decodingErrorInvalidName
        }
        
        guard let emoji = trackerCoreData.emoji else {
            throw TrackrerStoreError.decodingErrorInvalidEmoji
        }
        
        guard let color = trackerCoreData.colorHex else {
            throw TrackrerStoreError.decodingErrorInvalidColor
        }
        
        guard let schedul = trackerCoreData.schedule as? [WeekDay] else {
            throw TrackrerStoreError.decodingErrorInvalidSchedul
        }
        
        return Tracker(id: id, name: name, color: colorMarshalling.color(from: color), emoji: emoji, schedule: schedul)
    }
    
    private func updateExistingTrackerRecord(trackerCoreData: TrackerCoreData, tracker: Tracker) throws {
        trackerCoreData.id = tracker.id
        trackerCoreData.colorHex = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = tracker.schedule as NSObject
    }
}

//MARK: - TrackerStore
extension TrackerStore: TrackerStoreProtocol {        
    func addNewTracker(_ tracker: Tracker, nameCategory: String) throws {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCategoryCoreData.nameCategory),
                                        nameCategory as CVarArg)
        let category = try context.fetch(request).first
        let trackerCoreData = TrackerCoreData(context: context)
        try updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
        category?.addToTrakers(trackerCoreData)
        try context.save()
    }
    
    func deleteTracker(_ trackerCoreData: TrackerCoreData) throws {
        context.delete(trackerCoreData)
        try context.save()
    }
    
    func update(_ trackerCoreData: TrackerCoreData, tracker: Tracker) throws {
        try updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
        try context.save()
    }
    
    func trackers(_ objects: [TrackerCoreData]) throws -> [Tracker] {
        guard let trackers = try? objects.map({try tracker(from: $0) })
        else { return [] }
        
        return trackers
    }
}

