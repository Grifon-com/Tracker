//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Григорий Машук on 17.10.23.
//

import UIKit
import CoreData

enum TrackrerCategoryStoreError: Error {
    case decodingErrorInvalidNameCategori
}

enum TrackrerStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidId
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedul
}

enum NSSetError: Error {
    case transformationErrorInvalid
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore, indexPath: IndexPath)
}

protocol TrackerCategoryStoreProtocol {
    func addNewCategory(nameCategory: String, tracker: Tracker) throws
    func addNewTracker(_ tracker: Tracker, category: TrackerCategory) throws
    
    
    func trackersCategoryResult(trackerCategoryCoreData: [TrackerCategoryCoreData]) -> [TrackerCategory]
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    
    private var indexPathCategory: IndexPath?
    
    weak var delegate: TrackerCategoryStoreDelegate?

    convenience override init() {
        let context = AppDelegate.container.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerCategoryStore {
    func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let nameCategory = trackerCategoryCoreData.nameCategory else {
            throw TrackrerCategoryStoreError.decodingErrorInvalidNameCategori
        }

        guard let arrayTrackersCoreData = trackerCategoryCoreData.trakers?.allObjects as? [TrackerCoreData] else { throw NSSetError.transformationErrorInvalid }

        let arrayTrackers = try arrayTrackersCoreData.map ({ try self.tracker(from: $0) })

        return TrackerCategory(nameCategory: nameCategory, arrayTrackers: arrayTrackers)
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackrerStoreError.decodingErrorInvalidId
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
    
    func updateExistingTrackerRecord(trackerCoreData: TrackerCoreData, tracker: Tracker) throws {
        trackerCoreData.id = tracker.id
        trackerCoreData.colorHex = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = tracker.schedule as NSObject
    }
}


//MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addNewCategory(nameCategory: String, tracker: Tracker) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.nameCategory = nameCategory
        let trackerCoreDate = TrackerCoreData(context: context)
        try updateExistingTrackerRecord(trackerCoreData: trackerCoreDate, tracker: tracker)
        categoryCoreData.addToTrakers(trackerCoreDate)
        try context.save()
    }
    
    func addNewTracker(_ tracker: Tracker, category: TrackerCategory) throws {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCategoryCoreData.nameCategory),
                                        category.nameCategory as CVarArg)
        let category = try context.fetch(request).first
        let trackerCoreData = TrackerCoreData(context: context)
        try updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
        trackerCoreData.category = category
        try context.save()
    }
    
    func trackersCategoryResult(trackerCategoryCoreData: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        guard let treckerCategory = try? trackerCategoryCoreData.map ({ try self.category(from: $0) })
        else { return [] }
        
        return treckerCategory
    }
}
    
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        indexPathCategory = IndexPath()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let delegate,
              let indexPathCategory
        else { return }
        delegate.store(self, indexPath: indexPathCategory)
        self.indexPathCategory = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            indexPathCategory = indexPath
            print(indexPath.section)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            indexPathCategory = indexPath
            print(indexPath.section)
        case .update:
            guard let indexPath = newIndexPath else { fatalError() }
            indexPathCategory = indexPath
        case .move:
            break
        @unknown default:
            fatalError()
        }
    }
}


