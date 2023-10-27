////
////  DomainStore.swift
////  Tracker
////
////  Created by Григорий Машук on 22.10.23.
////

import Foundation
import CoreData

protocol DataProviderDelegate: AnyObject {
    func storeTracker(_ store: DataProvider, didUpdate update: TrackerCategoryStoreUpdate)
    func storeCategory(_ at: DataProvider, indexPath: IndexPath)
}

protocol DataProviderprotocol {
    var trackerCategory: [TrackerCategory] { get }
    var treckersRecords: Set<TrackerRecord> { get }
    
    func addTracker(_ category: TrackerCategory, tracker: Tracker) throws
    func addNewCategory(_ nameCategori: String, tracker: Tracker) throws
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws
    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws
    func loadTrackerRecord(id: UUID) throws -> Int
}

final class DataProvider: NSObject {
    weak var delegate: DataProviderDelegate?
    
    private let context: NSManagedObjectContext
    
    private let trackerStore: TrackerStoreProtocol
    private let trackerCategoryStore: TrackerCategoryStoreProtocol
    private let trackerRecordStore: TrackerRecordStore
        
    private var indexPathCategory: IndexPath?
    
    private var insertedIndexes: (item: IndexSet, section: IndexSet)?
    private var deletedIndexes: (item: IndexSet, section: IndexSet)?
    private var updateIndexes: (item: IndexSet, section: IndexSet)?
    private var moveIndexes: Set<TrackerCategoryStoreUpdate.Move>?
    
    init(_ delegate: DataProviderDelegate) throws {
        let context = AppDelegate.container.viewContext
        self.delegate = delegate
        self.context = context
        self.trackerStore = TrackerStore()
        self.trackerCategoryStore = TrackerCategoryStore()
        self.trackerRecordStore = TrackerRecordStore()
    }
    
    private lazy var fetchedTrackerResultController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        
        return fetchedResultController
    }()
    
    private lazy var fetchedCategoryResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.nameCategory, ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                                 managedObjectContext: context,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        
        return fetchedResultController
    }()
    
    private lazy var fetchedTrackerRecordResultController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequst = TrackerRecordCoreData.fetchRequest()
        fetchRequst.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequst, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultController.performFetch()
        
        return fetchedResultController
    }()
}

private extension DataProvider {
    func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let nameCategory = trackerCategoryCoreData.nameCategory else {
            throw TrackrerCategoryStoreError.decodingErrorInvalidNameCategori
        }
        
        guard let arrayTrackersCoreData = trackerCategoryCoreData.trakers?.allObjects as? [TrackerCoreData] else { throw NSSetError.transformationErrorInvalid }
        
        let arrayTrackers = try arrayTrackersCoreData.map ({ try self.trackerStore.tracker(from: $0) })
        
        return TrackerCategory(nameCategory: nameCategory, arrayTrackers: arrayTrackers)
    }
}

//MARK: - DataProviderprotocol
extension DataProvider: DataProviderprotocol {
    var treckersRecords: Set<TrackerRecord>  {
        guard let objects = fetchedTrackerRecordResultController.fetchedObjects
        else { return [] }
        let treckersRecords = trackerRecordStore.treckersRecordsResult(trackerRecordsCoreData: objects)
        return treckersRecords
    }
    
    var trackerCategory: [TrackerCategory] {
        guard let objects = fetchedCategoryResultController.fetchedObjects
        else { return [] }
        let treckerCategory = trackerCategoryStore.trackersCategoryResult(trackerCategoryCoreData: objects)
        
        return treckerCategory
    }
    
    func addTracker(_ category: TrackerCategory, tracker: Tracker) throws {
        fetchedCategoryResultController.delegate = nil
        let _ = fetchedTrackerResultController.fetchedObjects
        try trackerStore.addNewTracker(tracker, category: category)
    }
    
    func addNewCategory(_ nameCategori: String, tracker: Tracker) throws {
        try trackerCategoryStore.addNewCategory(nameCategory: nameCategori, tracker: tracker)
    }
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        try trackerRecordStore.addNewTrackerRecord(trackerRecord)
    }
    
    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        try trackerRecordStore.deleteTrackerRecord(trackerRecord)
    }
    
    func loadTrackerRecord(id: UUID) throws -> Int {
        try trackerRecordStore.loadTrackerRecord(id: id)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension DataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == fetchedTrackerResultController {
            insertedIndexes = (IndexSet(), IndexSet())
            deletedIndexes = (IndexSet(), IndexSet())
            updateIndexes = (IndexSet(), IndexSet())
            moveIndexes = Set<TrackerCategoryStoreUpdate.Move>()
        }
        
        if controller == fetchedCategoryResultController {
            indexPathCategory = IndexPath()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == fetchedTrackerResultController {
            guard let delegate,
                  let insertedIndexes,
                  let deletedIndexes,
                  let updateIndexes,
                  let moveIndexes
            else { return }
            delegate.storeTracker(self, didUpdate: TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updateIndexes,
                movedIndexes: moveIndexes))
            self.insertedIndexes = nil
            self.deletedIndexes = nil
            self.updateIndexes = nil
            self.moveIndexes = nil
        }
        
        if controller == fetchedCategoryResultController {
            guard let delegate,
            let indexPathCategory
            else { return }
            delegate.storeCategory(self, indexPath: indexPathCategory)
            self.indexPathCategory = nil
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        if controller == fetchedTrackerResultController {
            switch type {
            case .insert:
                guard let indexPath = newIndexPath else { fatalError() }
                insertedIndexes?.item.insert(indexPath.item)
                insertedIndexes?.section.insert(indexPath.section)
            case .delete:
                guard let indexPath = indexPath else { fatalError() }
                deletedIndexes?.item.insert(indexPath.item)
                deletedIndexes?.item.insert(indexPath.section)
            case .update:
                guard let indexPath = newIndexPath else { fatalError() }
                updateIndexes?.item.insert(indexPath.item)
                updateIndexes?.item.insert(indexPath.section)
            case .move:
                guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
                moveIndexes?.insert(.init(oldIndex: (item: oldIndexPath.item,
                                                     section: oldIndexPath.section),
                                          newIndex: (item: newIndexPath.item,
                                                     section: newIndexPath.section)))
            @unknown default:
                fatalError()
            }
        }
        
        if controller == fetchedCategoryResultController {
            if case .insert = type {
                guard let indexPath = newIndexPath else { fatalError() }
                indexPathCategory = indexPath
            } 
        }
    }
}
