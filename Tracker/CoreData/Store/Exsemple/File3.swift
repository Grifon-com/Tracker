////
////  TreckerStore.swift
////  Tracker
////
////  Created by Григорий Машук on 17.10.23.
////
//
//import Foundation
//import CoreData
//
//
////TODO: - sprint_16
//protocol TrackerStoreProtocol {
//    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker
//    func trackers(_ objects: [TrackerCoreData]) throws -> [Tracker]
//    func newTracker(tracker: Tracker) throws -> TrackerCoreData
//    func deleteTracker(_ trackerCoreData: TrackerCoreData) throws
//    func update(_ trackerCoreData: TrackerCoreData, tracker: Tracker) throws
//}
//
//protocol TrackerStoreDelegate: AnyObject {
//    func store(trackerStore: TrackerStore, update: TrackerCategoryStoreUpdate)
//}
//
//final class TrackerStore: NSObject {
//    private let context: NSManagedObjectContext
//    private let colorMarshalling = UIColorMarshalling()
//    
//    weak var delegate: TrackerStoreDelegate?
////
////    private var insertedIndexes: IndexSet?
////    private var deletedIndexes: IndexSet?
////    private var updateIndexes: IndexSet?
////    private var moveIndexes: Set<TrackerCategoryStoreUpdate.Move>?
//    
//    convenience override init() {
//        let context = AppDelegate.container.viewContext
//        self.init(context: context)
//    }
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
//        let request = TrackerCoreData.fetchRequest()
//        request.sortDescriptors = [
//            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
//        ]
//        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
////        fetchedResultController.delegate = self
//        try? fetchedResultController.performFetch()
//        
//        return fetchedResultController
//    }()
//}
//
//extension TrackerStore {
//    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
//        guard let id = trackerCoreData.id else {
//            throw TrackrerStoreError.decodingErrorInvalidId
//        }
//        
//        guard let name = trackerCoreData.name else {
//            throw  TrackrerStoreError.decodingErrorInvalidName
//        }
//        
//        guard let emoji = trackerCoreData.emoji else {
//            throw TrackrerStoreError.decodingErrorInvalidEmoji
//        }
//        
//        guard let color = trackerCoreData.colorHex else {
//            throw TrackrerStoreError.decodingErrorInvalidColor
//        }
//        
//        guard let schedul = trackerCoreData.schedule as? [WeekDay] else {
//            throw TrackrerStoreError.decodingErrorInvalidSchedul
//        }
//        
//        return Tracker(id: id, name: name, color: colorMarshalling.color(from: color), emoji: emoji, schedule: schedul)
//    }
//    
//    private func updateExistingTrackerRecord(trackerCoreData: TrackerCoreData, tracker: Tracker) throws {
//        trackerCoreData.id = tracker.id
//        trackerCoreData.colorHex = colorMarshalling.hexString(from: tracker.color)
//        trackerCoreData.emoji = tracker.emoji
//        trackerCoreData.name = tracker.name
//        trackerCoreData.schedule = tracker.schedule as NSObject
//        try context.save()
//    }
//}
//
//extension TrackerStore: TrackerStoreProtocol {
//    func newTracker(tracker: Tracker) throws -> TrackerCoreData {
//        let trackerCoreData = TrackerCoreData(context: context)
//        try updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
//        
//        return trackerCoreData
//    }
//    
//    func deleteTracker(_ trackerCoreData: TrackerCoreData) throws {
//        context.delete(trackerCoreData)
//    }
//    
//    func update(_ trackerCoreData: TrackerCoreData, tracker: Tracker) throws {
//        try updateExistingTrackerRecord(trackerCoreData: trackerCoreData, tracker: tracker)
//    }
//    
//    func trackers(_ objects: [TrackerCoreData]) throws -> [Tracker] {
//            guard let trackers = try? objects.map({try tracker(from: $0) })
//            else { return [] }
//            
//            return trackers
//        }
//}
//
////extension TrackerStore: NSFetchedResultsControllerDelegate {
////    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        insertedIndexes = IndexSet()
////        deletedIndexes = IndexSet()
////        updateIndexes = IndexSet()
////        moveIndexes = Set<TrackerCategoryStoreUpdate.Move>()
////    }
////
////    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        guard let delegate,
////              let insertedIndexes,
////              let deletedIndexes,
////              let updateIndexes,
////              let moveIndexes
////        else { return }
////        let trackerCategoryStoreUpdate = TrackerCategoryStoreUpdate(insertedIndexes: insertedIndexes,
////                                                                    deletedIndexes: deletedIndexes,
////                                                                    updatedIndexes: updateIndexes,
////                                                                    movedIndexes: moveIndexes)
////        delegate.store(trackerStore: self, update: trackerCategoryStoreUpdate)
////        self.insertedIndexes = nil
////        self.deletedIndexes = nil
////        self.updateIndexes = nil
////        self.moveIndexes = nil
////    }
////
////    func controller(
////            _ controller: NSFetchedResultsController<NSFetchRequestResult>,
////            didChange anObject: Any,
////            at indexPath: IndexPath?,
////            for type: NSFetchedResultsChangeType,
////            newIndexPath: IndexPath?
////    ) {
////        switch type {
////        case .insert:
////            guard let indexPath = newIndexPath else { fatalError() }
////            insertedIndexes?.insert(indexPath.item)
////        case .delete:
////            guard let indexPath else { fatalError() }
////            deletedIndexes?.insert(indexPath.item)
////        case .move:
////            guard let oldIndexPath = indexPath, let newIndexPath else { fatalError() }
////            moveIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
////        case .update:
////            guard let indexPath else { fatalError() }
////            updateIndexes?.insert(indexPath.item)
////        @unknown default:
////            fatalError()
////        }
////    }
////}
////
