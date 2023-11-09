//
//  CategoriViewModel.swift
//  Tracker
//
//  Created by Григорий Машук on 2.11.23.
//

import UIKit

//MARK: - CategoriViewModel
final class CategoriViewModel {
    @Observable<[TrackerCategory]> private(set) var category = []
    @UserDefaultsBacked<String?>(key: "select_name_category") var selectNameCategory
    @Observable<IndexPath> private(set) var categoryIndexPath = IndexPath()
    
    private var model: DataProvider?
    
    init() {
        model = DataProvider(delegate: self)
        category = model?.trackerCategory ?? []
    }
}

extension CategoriViewModel {
    func addCategory(nameCategory: String) throws {
        guard let model else { return }
        try model.addCategory(nameCategory: nameCategory)
    }
    
    func selectСategory(at index: Int) {
        selectNameCategory = category[index].nameCategory
    }
    
    func createNameCategory(at index: Int) -> String {
        category[index].nameCategory
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        category[index].nameCategory != selectNameCategory
    }
}

//MARK: - DataProviderDelegate
extension CategoriViewModel: DataProviderDelegate {
    func storeCategory(dataProvider: DataProvider, indexPath: IndexPath) {
        category = dataProvider.trackerCategory
        categoryIndexPath = indexPath
    }
}
