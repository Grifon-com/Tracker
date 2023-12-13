//
//  TreckerRecordStore.swift
//  Tracker
//
//  Created by Григорий Машук on 17.10.23.
//

import Foundation
import CoreData

protocol TrackerRecordStoreProtocol {
    func updateTrackerRecord(_ trackerRecord: TrackerRecord) -> Result<Void, Error>
    func loadTrackerRecord(id: UUID) -> Result<Int, Error>
    func treckersRecordsResult() -> Result<Set<TrackerRecord>, Error> 
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func trackerRecordStore(trackerRecordStore: TrackerRecordStoreProtocol)
}

//MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext

    private lazy var fetchedTrackerRecordResultController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                                 managedObjectContext: context,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        
        return fetchedResultController
    }()
    
    convenience override init() {
        let context = AppDelegate.container.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

private extension TrackerRecordStore {
    func save(context: NSManagedObjectContext) -> Result<Void, Error> {
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func trackerRecord(from trackerRecordCoreDate: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreDate.trackerId else {
            throw StoreErrors.TrackrerRecordStoreError.decodingErrorInvalidId
        }
        guard let date = trackerRecordCoreDate.date else {
            throw StoreErrors.TrackrerRecordStoreError.decodingErrorInvalidDate
        }
        let trackerRecord = TrackerRecord(id: id, date: date)
        
        return trackerRecord
    }
    
    func updateExistingTrackerRecord(_ trackerRecordCoreData: TrackerRecordCoreData, trackerRecord: TrackerRecord) {
        trackerRecordCoreData.trackerId = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
    }
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) -> Result<Void, Error> {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        updateExistingTrackerRecord(trackerRecordCoreData, trackerRecord: trackerRecord)
        return save(context: context)
    }
    
    func deleteTrackerRecord(_ trackerRecordCoreData: TrackerRecordCoreData) -> Result<Void, Error> {
        context.delete(trackerRecordCoreData)
        return save(context: context)
    }
}

//MARK: - TrackerRecordStoreProtocol
extension TrackerRecordStore: TrackerRecordStoreProtocol {
    func treckersRecordsResult() -> Result<Set<TrackerRecord>, Error> {
        guard let trackerRecordsCoreData = fetchedTrackerRecordResultController.fetchedObjects
        else { return .failure(StoreErrors.TrackrerRecordStoreError.loadTrackerRecord) }
        do {
            let trackerRecord = try trackerRecordsCoreData.map ({ try self.trackerRecord(from: $0) })
            return .success(Set(trackerRecord))
        } catch {
            return .failure(error)
        }
    }
    
    func updateTrackerRecord(_ trackerRecord: TrackerRecord) -> Result<Void, Error> {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "\(TrackerRecordCoreData.self)")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                        #keyPath(TrackerRecordCoreData.date),
                                        trackerRecord.date as CVarArg,
                                        #keyPath(TrackerRecordCoreData.trackerId),
                                        trackerRecord.id as CVarArg)
        do {
            let trackers = try context.fetch(request)
            if let tracker = trackers.first {
                return deleteTrackerRecord(tracker)
            } else {
                return addNewTrackerRecord(trackerRecord)
            }
        }
        catch {
            return .failure(error)
        }
    }
    
    func loadTrackerRecord(id: UUID) -> Result<Int, Error> {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "\(TrackerRecordCoreData.self)")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerRecordCoreData.trackerId),
                                        id as CVarArg)
        do {
            let countTrackers = try context.fetch(request).count
            return .success(countTrackers)
        } catch {
            return .failure(error)
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let delegate else { return }
        delegate.trackerRecordStore(trackerRecordStore: self)
    }
}
