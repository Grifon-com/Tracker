//
//  CategoriViewModel.swift
//  Tracker
//
//  Created by Григорий Машук on 2.11.23.
//

import Foundation

protocol TrackerViewModelProtocol {
    var category: Result<[TrackerCategory], Error> { get }
    var visibleCategory: Result<[TrackerCategory], Error> { get }
    func getCategory() -> Result<[TrackerCategory], Error> 
    func deleteTracker(_ id: UUID) -> Result<Void, Error>
    func addCategory(nameCategory: String) -> Result<Void, Error>
    func deleteCategory(nameCategory: String) -> Result<Void, Error>
    
    func treckersRecordsResult() -> Result<Set<TrackerRecord>, Error>
    func loadTrackerRecord(id: UUID) -> Result<Int, Error>
    func updateCompletedTrackers(tracker: Tracker, date: Date) -> Result<Void, Error>
    
    func addNewTracker(_ tracker: Tracker, nameCategory: String) -> Result<Void, Error>
    func updateTracker(tracker: Tracker, nameCategory: String) -> Result<Void, Error>
    
    func getShowListTrackersForDay(date: Date)
    func getShowListTrackerSearchForName(_ searchCategory: [TrackerCategory])
    func filterListTrackersName(word: String) -> Result<[TrackerCategory], Error>
    
    func setIndexPath(_ indexPath: IndexPath)
    
    func addPinnedCategory(id: UUID, nameCategory: String)  -> Result<Void, Error>
    func deleteAndGetPinnedCategory(id: UUID) -> Result<String?, Error>
}

//MARK: - ViewModel
final class TrackerViewModel {
    private let textFixed = NSLocalizedString("textFixed", comment: "")
    
    @Observable<Result<[TrackerCategory], Error>> private(set) var category: Result<[TrackerCategory], Error>
    @Observable<IndexPath> private(set) var indexPath: IndexPath
    @Observable<Result<[TrackerCategory], Error>> private(set) var visibleCategory: Result<[TrackerCategory], Error>
    @UserDefaultsBacked<String>(key: "select_name_category") private var selectNameCategory: String?
    
    private var completedTrackers: Result<Set<TrackerRecord>, Error>
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol
    private let trackerRecordStore: TrackerRecordStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    private let pinnedCategoryStore: PinnedCategoryStoreProtocol
    
    convenience init() {
        let trackerCategoryStore = TrackerCategoryStore()
        let trackerRecordStore = TrackerRecordStore()
        let trackerStore = TrackerStore()
        let pinnedCategoryStore = PinnedCategoryStore()
        self.init(trackerCategoryStore: trackerCategoryStore,
                  trackerRecordStore: trackerRecordStore,
                  trackerStore: trackerStore,
                  pinnedCategoryStore: pinnedCategoryStore,
                  category: .success([]),
                  completedTrackers: .success(Set()),
                  visibleCategory: .success([]),
                  indexPath: IndexPath())
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        category = getCategory()
        completedTrackers = treckersRecordsResult()
    }
    
    init(trackerCategoryStore: TrackerCategoryStoreProtocol,
         trackerRecordStore: TrackerRecordStoreProtocol,
         trackerStore: TrackerStoreProtocol,
         pinnedCategoryStore: PinnedCategoryStoreProtocol,
         category: Result<[TrackerCategory], Error>,
         completedTrackers: Result<Set<TrackerRecord>, Error>,
         visibleCategory: Result<[TrackerCategory], Error>,
         indexPath: IndexPath)
    {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.trackerStore = trackerStore
        self.pinnedCategoryStore = pinnedCategoryStore
        self.category = category
        self.completedTrackers = completedTrackers
        self.visibleCategory = visibleCategory
        self.indexPath = indexPath
    }
}
//MARK: - Extension
private extension TrackerViewModel {
    func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let nameCategory = trackerCategoryCoreData.nameCategory else {
            throw StoreErrors.TrackrerCategoryStoreError.decodingErrorInvalidNameCategori
        }
        guard let arrayTrackersCoreData = trackerCategoryCoreData.trakers?.allObjects as? [TrackerCoreData]
        else { throw StoreErrors.NSSetError.transformationErrorInvalid }
        let result = trackerStore.getTrackers(arrayTrackersCoreData)
        switch result {
        case .success(let trackers):
            return TrackerCategory(nameCategory: nameCategory,
                                   arrayTrackers: trackers,
                                   isPinned: trackerCategoryCoreData.isPinned)
        case .failure(let error):
            throw error
        }
    }
    
    func comparisonWeekDays(date: Date, day: WeekDay) -> Bool {
        FormatDate.shared.greateWeekDayInt(date: date) == day.rawValue
    }
    
    func filterListTrackersWeekDay(trackerCategory: [TrackerCategory], date: Date) -> [TrackerCategory] {
        var listCategories: [TrackerCategory] = []
        for cat in .zero..<trackerCategory.count {
            let currentCategori = trackerCategory[cat]
            var trackers: [Tracker] = []
            for tracker in .zero..<trackerCategory[cat].arrayTrackers.count {
                let listWeekDay = trackerCategory[cat].arrayTrackers[tracker].schedule
                for day in .zero..<listWeekDay.count {
                    if comparisonWeekDays(date: date, day: listWeekDay[day]) {
                        let tracker = trackerCategory[cat].arrayTrackers[tracker]
                        trackers.append(tracker)
                        break
                    }
                }
            }
            if !trackers.isEmpty {
                let trackerCat = TrackerCategory(nameCategory: currentCategori.nameCategory,
                                                 arrayTrackers: trackers,
                                                 isPinned: trackerCategory[cat].isPinned)
                listCategories.append(trackerCat)
            }
        }
        return listCategories
    }
    
    func updateTrackerRecord(_ trackerRecord: TrackerRecord) -> Result<Void, Error> {
        trackerRecordStore.updateTrackerRecord(trackerRecord)
    }
}

//MARK: - TrackerViewModelProtocol
extension TrackerViewModel: TrackerViewModelProtocol {
    func deleteCategory(nameCategory: String) -> Result<Void, Error> {
        trackerCategoryStore.deleteCategory(nameCategory: nameCategory)
    }
    
    func deleteTracker(_ id: UUID) -> Result<Void, Error> {
        trackerStore.deleteTracker(id)
    }
    
    func addCategory(nameCategory: String) -> Result<Void, Error> {
        trackerCategoryStore.addCategory(nameCategory)
    }
    
//    func isCategorySelected(at index: Int) -> Result<Bool, Error> {
//        switch category {
//        case .success(let category):
//            return .success(category[index].nameCategory != selectNameCategory)
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
    
    func getCategory() -> Result<[TrackerCategory], Error> {
        let trackerCategoryCoreData = trackerCategoryStore.getListTrackerCategoryCoreData()
        guard let trackerCategoryCoreData else { return .failure(StoreErrors.TrackrerStoreError.getTrackerError) }
        do {
            let listCategory = try trackerCategoryCoreData.map ({ try category(from: $0) })
            return .success(listCategory)
        } catch {
            return .failure(error)
        }
    }
    
    func treckersRecordsResult() -> Result<Set<TrackerRecord>, Error> {
        trackerRecordStore.treckersRecordsResult()
    }
    
    func loadTrackerRecord(id: UUID) -> Result<Int, Error> {
        trackerRecordStore.loadTrackerRecord(id: id)
    }
    
    func addNewTracker(_ tracker: Tracker, nameCategory: String) -> Result<Void, Error> {
        let trackerCoreData = trackerStore.addNewTracker(tracker, nameCategory: nameCategory)
        return trackerCoreData
    }
    
    func updateTracker(tracker: Tracker, nameCategory: String) -> Result<Void, Error> {
        trackerStore.updateTracker(tracker: tracker, nameCategory: nameCategory)
    }
    
    func getShowListTrackersForDay(date: Date) {
        switch category {
        case .success(let trackerCategory):
            let filterList = filterListTrackersWeekDay(trackerCategory: trackerCategory, date: date)
            visibleCategory = .success(filterList)
        case .failure(let error):
            visibleCategory = .failure(error)
        }
    }
    
    func filterListTrackersName(word: String) -> Result<[TrackerCategory], Error> {
        var listCategories: [TrackerCategory] = []
        switch category {
        case .success(let cat):
            cat.forEach { category in
                let trackerList = category.arrayTrackers.filter { $0.name.lowercased().hasPrefix(word.lowercased()) }
                if !trackerList.isEmpty {
                    listCategories.append(TrackerCategory(nameCategory: category.nameCategory,
                                                          arrayTrackers: trackerList,
                                                          isPinned: category.isPinned))
                }
            }
            return .success(listCategories)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func updateCompletedTrackers(tracker: Tracker, date: Date) -> Result<Void, Error> {
        switch completedTrackers {
        case .success(let compTrack):
            if let recordTracker = compTrack.first(where: { $0.id == tracker.id &&
                Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                return updateTrackerRecord(recordTracker)
            }
            return updateTrackerRecord(TrackerRecord(id: tracker.id, date: date))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getShowListTrackerSearchForName(_ searchCategory: [TrackerCategory]) {
        visibleCategory = .success(searchCategory)
    }
    
    func getIsComplited(tracker: Tracker, date: Date) -> Result<Bool, Error>{
        switch completedTrackers {
        case .success(let compTrack):
            return .success(compTrack.contains (where: { $0.id == tracker.id && Calendar.current.isDate(date, equalTo: $0.date, toGranularity: .day)}))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func addPinnedCategory(id: UUID, nameCategory: String)  -> Result<Void, Error> {
        let pinnCategoryCoreData = pinnedCategoryStore.addPinnedCategory(nameCategory)
        switch pinnCategoryCoreData {
        case .success(let pinnCategoryCoreData):
            return trackerStore.addPinnedCategory(id, pinnedCategory: pinnCategoryCoreData)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func deleteAndGetPinnedCategory(id: UUID) -> Result<String?, Error> {
        pinnedCategoryStore.deleteAndGetPinnedCategory(id)
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension TrackerViewModel: TrackerCategoryStoreDelegate {
    func storeCategory(trackerCategoryStore: TrackerCategoryStoreProtocol) {
        category = getCategory()
    }
}

//MARK: - TrackerRecordStoreDelegate
extension TrackerViewModel: TrackerRecordStoreDelegate {
    func trackerRecordStore(trackerRecordStore: TrackerRecordStoreProtocol) {
        completedTrackers = trackerRecordStore.treckersRecordsResult()
        self.indexPath = indexPath
    }
}

//MARK: - TrackerStoreDelegate
extension TrackerViewModel: TrackerStoreDelegate {
    func updateTracker(_ trackerCoreData: TrackerStoreProtocol) {
        category = getCategory()
    }
}
