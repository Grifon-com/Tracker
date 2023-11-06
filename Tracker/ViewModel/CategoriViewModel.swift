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
    
    var listNameCategory: [String] = []
    
    private var model: DataProvider?
    
    init() {
        model = DataProvider(delegate: self)
        category = model?.trackerCategory ?? []
        model?.delegate = self
    }
}

extension CategoriViewModel {
    func addCategory(nameCategory: String) throws {
        guard let model else { return }
        try model.addCategory(nameCategory: nameCategory)
    }
    
    func selectСategory(indexPath: IndexPath) {
        selectNameCategory = listNameCategory[indexPath.row]
    }
    
    func createNameCategory(indexPath: IndexPath) -> String {
        category[indexPath.row].nameCategory
    }
    
    func createListNameCategory() {
        listNameCategory = category.map { $0.nameCategory }
    }
}

//MARK: - DataProviderDelegate
extension CategoriViewModel: DataProviderDelegate {
    func storeCategory(dataProvider: DataProvider, indexPath: IndexPath) {
        category = dataProvider.trackerCategory
    }
}
