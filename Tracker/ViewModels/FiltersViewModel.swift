//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Григорий Машук on 17.12.23.
//

import Foundation

protocol FiltersViewModelProtocol {
    var filtersState: [FiltersState] { get }
    func getSelectFilter() -> String?
    func setSelectFilter(selectFilter: String)
    func comparison(filter: String) -> Bool 
}

final class FiltersViewModel {
    let filtersState: [FiltersState] = [.allTrackers, .toDayTrackers, .completed, .notCompleted]
    
    @UserDefaultsBacked<String>(key: UserDefaultKeys.selectFilter.rawValue)
    private var selectFilter: String?
}

extension FiltersViewModel: FiltersViewModelProtocol {
    func getSelectFilter() -> String? {
        selectFilter
    }
    
    func setSelectFilter(selectFilter: String) {
        self.selectFilter = selectFilter
    }
    
    func comparison(filter: String) -> Bool {
        guard let selectFilter else { return true }
        return filter != selectFilter
    }
}
