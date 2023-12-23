//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Григорий Машук on 17.10.23.
//

import Foundation
import CoreData

protocol TrackerCategoryStoreProtocol {
    func addCategory(_ nameCategory: String) -> Result<Void, Error>
    func getListTrackerCategoryCoreData() -> [TrackerCategoryCoreData]?
    func deleteCategory(nameCategory: String) -> Result<Void, Error>
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeCategory(trackerCategoryStore: TrackerCategoryStoreProtocol)
}

//MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    private let textFixed = NSLocalizedString("textFixed", comment: "")
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    private lazy var fetchedCategoryResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        let sortPinned = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.isPinned, ascending: true)
        let sortName = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.nameCategory, ascending: true)
        request.sortDescriptors = [sortPinned, sortName]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                                 managedObjectContext: context,
                                                                 sectionNameKeyPath: #keyPath(TrackerCategoryCoreData.nameCategory),
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

private extension TrackerCategoryStore {
    func save(context: NSManagedObjectContext) -> Result<Void, Error> {
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

//MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addCategory(_ nameCategory: String) -> Result<Void, Error> {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.nameCategory = nameCategory
        categoryCoreData.isPinned = nameCategory == textFixed ? false : true
        return save(context: context)
    }
    
    func getListTrackerCategoryCoreData() -> [TrackerCategoryCoreData]? {
        fetchedCategoryResultController.fetchedObjects
    }
    
    func deleteCategory(nameCategory: String) -> Result<Void, Error> {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "\(TrackerCategoryCoreData.self)")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.nameCategory), nameCategory as CVarArg)
        do {
            if let category = try context.fetch(request).first {
                context.delete(category)
                return save(context: context)
            }
        } catch {
            return .failure(error)
        }
        return save(context: context)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let delegate
        else { return }
        delegate.storeCategory(trackerCategoryStore: self)
    }
}
