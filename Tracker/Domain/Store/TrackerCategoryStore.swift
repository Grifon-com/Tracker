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

protocol TrackerCategoryStoreProtocol {
    func addNewCategory(nameCategory: String, trackerCoreData: TrackerCoreData) throws
    func addCategory(_ nameCategory: String) throws 
}

//MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    
    private var indexPathCategory: IndexPath?

    convenience override init() {
        let context = AppDelegate.container.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

//MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addNewCategory(nameCategory: String, trackerCoreData: TrackerCoreData) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.nameCategory = nameCategory
        categoryCoreData.addToTrakers(trackerCoreData)
        try context.save()
    }
    
    func addCategory(_ nameCategory: String) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.nameCategory = nameCategory
        try context.save()
    }
}


