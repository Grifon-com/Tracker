//
//  TreckerStore.swift
//  Tracker
//
//  Created by Григорий Машук on 17.10.23.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func addNewTracker(_ tracker: Tracker, nameCategory: String) -> Result<Void, Error>
    func getTrackers(_ objects: [TrackerCoreData]) -> Result<[Tracker], Error>
    func updateTracker(tracker: Tracker) -> Result<Void, Error>
    func deleteTracker(_ id: UUID) -> Result<Void, Error>
    
    func addPinnedCategory(_ id: UUID, pinnedCategory: PinnCategoryCoreData) -> Result<Void, Error>
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

//MARK: - Private
private extension TrackerStore {
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            fatalError("not found ID")
        }
        
        guard let name = trackerCoreData.name else {
            throw  StoreErrors.TrackrerStoreError.decodingErrorInvalidName
        }
        
        guard let emoji = trackerCoreData.emoji else {
            throw StoreErrors.TrackrerStoreError.decodingErrorInvalidEmoji
        }
        
        guard let color = trackerCoreData.colorHex else {
            throw StoreErrors.TrackrerStoreError.decodingErrorInvalidColor
        }
        
        guard let schedul = trackerCoreData.schedule as? [WeekDay] else {
            throw StoreErrors.TrackrerStoreError.decodingErrorInvalidSchedul
        }
        
        return Tracker(id: id, name: name, color: colorMarshalling.color(from: color), emoji: emoji, schedule: schedul)
    }
    
    func updateExistingTrackerRecord(trackerCoreData: TrackerCoreData, tracker: Tracker)  {
        trackerCoreData.id = tracker.id
        trackerCoreData.colorHex = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = tracker.schedule as NSObject
    }
    
    func save(context: NSManagedObjectContext) -> Result<Void, Error> {
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func searchTrackerCoreData(id: UUID) throws -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "\(TrackerCoreData.self)")
        request.returnsObjectsAsFaults = false
        guard let keyPath = (\TrackerCoreData.id)._kvcKeyPathString
        else { throw StoreErrors.TrackrerStoreError.getTrackerError }
        request.predicate = NSPredicate(format: "%K == %@", keyPath, id as CVarArg)
        return try context.fetch(request).first
    }
}

//MARK: - TrackerStoreProtocol
extension TrackerStore: TrackerStoreProtocol {
    func addNewTracker(_ tracker: Tracker, nameCategory: String) -> Result<Void, Error> {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "\(TrackerCategoryCoreData.self)")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCategoryCoreData.nameCategory),
                                        nameCategory as CVarArg)
        do {
            if let category = try context.fetch(request).first {
                let trackerCoreData = TrackerCoreData(context: context)
                updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
                category.addToTrakers(trackerCoreData)
                return save(context: context)
            }
        } catch {
            return .failure(error)
        }
        return save(context: context)
    }
     
    func updateTracker(tracker: Tracker) -> Result<Void, Error> {
        do {
            if let trackerCoreData = try searchTrackerCoreData(id: tracker.id) {
                updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
                return save(context: context)
            }
        } catch {
            return .failure(error)
        }
        return save(context: context)
    }
    
    func deleteTracker(_ id: UUID) -> Result<Void, Error> {
        do {
            if let trackerCoreData = try searchTrackerCoreData(id: id) {
                context.delete(trackerCoreData)
                return save(context: context)
            }
        } catch {
            return .failure(error)
        }
        return save(context: context)
    }
    
    func getTrackers(_ objects: [TrackerCoreData]) -> Result<[Tracker], Error> {
        do {
            let trackers = try objects.map({ try tracker(from: $0) })
            return .success(trackers)
        } catch {
            return .failure(error)
        }
    }
    
    func addPinnedCategory(_ id: UUID, pinnedCategory: PinnCategoryCoreData) -> Result<Void, Error> {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "\(TrackerCoreData.self)")
        request.returnsObjectsAsFaults = false
        guard let keyPath = (\TrackerCoreData.id)._kvcKeyPathString
        else { return .failure(StoreErrors.TrackrerStoreError.getTrackerError) }
        request.predicate = NSPredicate(format: "%K == %@", keyPath, id as CVarArg)
        do {
            if let trackerCoreData = try searchTrackerCoreData(id: id) {
                pinnedCategory.addToTracker(trackerCoreData)
                pinnedCategory.trackerId = id
                
                return save(context: context)
            }
        } catch {
            return .failure(error)
        }
        return save(context: context)
    }
}

