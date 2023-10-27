//
//  TrackerCategoryStoreUpdate.swift
//  Tracker
//
//  Created by Григорий Машук on 25.10.23.
//

import Foundation

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        static func == (lhs: TrackerCategoryStoreUpdate.Move, rhs: TrackerCategoryStoreUpdate.Move) -> Bool {
           return lhs.newIndex.item == rhs.newIndex.item && lhs.newIndex.section == rhs.newIndex.section &&
            lhs.oldIndex.item == rhs.oldIndex.item && lhs.oldIndex.section == rhs.oldIndex.section
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(oldIndex.item)
            hasher.combine(oldIndex.section)
            hasher.combine(newIndex.item)
            hasher.combine(newIndex.section)
            }
        
        let oldIndex: (item: Int, section: Int)
        let newIndex: (item: Int, section: Int)
        
    }
    let insertedIndexes: (item: IndexSet, section: IndexSet)
    let deletedIndexes: (item: IndexSet, section: IndexSet)
    let updatedIndexes: (item: IndexSet, section: IndexSet)
    let movedIndexes: Set<Move>
}
