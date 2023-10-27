////
////  TreckerRecordStore.swift
////  Tracker
////
////  Created by Григорий Машук on 17.10.23.
////
//
//import Foundation
//import CoreData
//
//enum TrackrerRecordStoreError: Error {
//    case decodingErrorInvalidId
//    case decodingErrorInvalidDate
//    case loadTrackerRecord(Error)
//}
//
//protocol TrackerRecordStoreProtocol {
//    var treckersRecords: Set<TrackerRecord> { get }
//    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws
//    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws
//    func loadTrackerRecord(id: UUID) throws -> Int
//}
//
//protocol TrackerRecordStoreDelegate: AnyObject {
//    func store(_ trackerRecordStore: TrackerRecordStore)
//}
//
//final class TrackerRecordStore: NSObject {
//    private let context: NSManagedObjectContext
//
//    weak var delegate: TrackerRecordStoreDelegate?
//
//    private lazy var fetchedResultController: NSFetchedResultsController<TrackerRecordCoreData> = {
//        let fetchRequst = TrackerRecordCoreData.fetchRequest()
//        fetchRequst.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
//        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequst, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        try? fetchedResultController.performFetch()
//
//        return fetchedResultController
//    }()
//
//    convenience override init() {
//        let context = AppDelegate.container.viewContext
//        self.init(context: context)
//    }
//
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//}
//
//private extension TrackerRecordStore {
//    func trackerRecord(from trackerRecordCoreDate: TrackerRecordCoreData) throws -> TrackerRecord {
//        guard let id = trackerRecordCoreDate.trackerId else {
//            throw TrackrerRecordStoreError.decodingErrorInvalidId
//        }
//        guard let date = trackerRecordCoreDate.date else {
//            throw TrackrerRecordStoreError.decodingErrorInvalidDate
//        }
//        let trackerRecord = TrackerRecord(id: id, date: date)
//
//        return trackerRecord
//    }
//
//    func updateExistingTrackerRecord(_ trackerRecordCoreData: TrackerRecordCoreData, trackerRecord: TrackerRecord) {
//        trackerRecordCoreData.trackerId = trackerRecord.id
//        trackerRecordCoreData.date = trackerRecord.date
//    }
//}
//
////MARK: - TrackerRecordStoreProtocol
//extension TrackerRecordStore: TrackerRecordStoreProtocol {
//    var treckersRecords: Set<TrackerRecord> {
//        guard let objects = self.fetchedResultController.fetchedObjects,
//              let trackerRecord = try? objects.map ({ try self.trackerRecord(from: $0) })
//        else { return [] }
//
//        return Set(trackerRecord)
//        }
//
//    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
//        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
//        updateExistingTrackerRecord(trackerRecordCoreData, trackerRecord: trackerRecord)
//        try context.save()
//    }
//
//    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "\(TrackerRecordCoreData.self)")
//        request.returnsObjectsAsFaults = false
//        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
//                                        #keyPath(TrackerRecordCoreData.date),
//                                        trackerRecord.date as CVarArg,
//                                        #keyPath(TrackerRecordCoreData.trackerId),
//                                        trackerRecord.id as CVarArg)
//        let trackers = try context.fetch(request)
//        if let tracker = trackers.first {
//            context.delete(tracker)
//            try context.save()
//        }
//    }
//
//    func loadTrackerRecord(id: UUID) throws -> Int {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "\(TrackerRecordCoreData.self)")
//        request.returnsObjectsAsFaults = false
//        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as CVarArg)
//        let countTrackers = try context.fetch(request).count
//        print(countTrackers)
//        return countTrackers
//    }
//}
//
////MARK: - NSFetchedResultsControllerDelegate
//extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        guard let delegate else { return }
//        delegate.store(self)
//    }
//}
