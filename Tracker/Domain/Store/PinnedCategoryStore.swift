//
//  PinnedCategoryStore.swift
//  Tracker
//
//  Created by Марина Машук on 11.12.23.
//

import Foundation
import CoreData

protocol PinnedCategoryStoreProtocol {
    func addPinnedCategory(_ nameCategory: String) -> Result<PinnCategoryCoreData, Error>
    func deleteAndGetPinnedCategory(_ id: UUID) -> Result<String?, Error>
}

protocol PinnedCategoryStoreDelegate: AnyObject {
    func storePinnedCategory(trackerCategoryStore: PinnedCategoryStoreProtocol)
}

//MARK: - TrackerStore
final class PinnedCategoryStore: NSObject {
    weak var delegate: PinnedCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = AppDelegate.container.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

private extension PinnedCategoryStore {
    func save(context: NSManagedObjectContext) -> Result<Void, Error> {
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

extension PinnedCategoryStore: PinnedCategoryStoreProtocol {
    func addPinnedCategory(_ nameCategory: String) -> Result<PinnCategoryCoreData, Error> {
        let pinnCategoryCoreData = PinnCategoryCoreData(context: context)
        pinnCategoryCoreData.nameCategory = nameCategory
        do {
            try context.save()
            return .success(pinnCategoryCoreData)
        }
        catch { return .failure(error) }
    }
    
    func deleteAndGetPinnedCategory(_ id: UUID) -> Result<String?, Error> {
        let request = NSFetchRequest<PinnCategoryCoreData>(entityName: "\(PinnCategoryCoreData.self)")
        request.returnsObjectsAsFaults = false
        guard let keyPath = (\PinnCategoryCoreData.trackerId)._kvcKeyPathString
        else { return .failure(StoreErrors.TrackrerStoreError.getTrackerError) }
        request.predicate = NSPredicate(format: "%K == %@", keyPath, id as CVarArg)
        do {
            if let pinnCategoryCoreData = try context.fetch(request).first {
                let nameCategory = pinnCategoryCoreData.nameCategory
                pinnCategoryCoreData.nameCategory = nil
                pinnCategoryCoreData.trackerId = nil
                let _ = save(context: context)
                return .success(nameCategory)
            }
        } catch {
            return .failure(error)
        }
        return .failure(StoreErrors.TrackrerStoreError.getTrackerError)
    }
}
