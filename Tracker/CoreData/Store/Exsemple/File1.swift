////
////  TrackerViewController.swift
////  Tracker
////
////  Created by Григорий Машук on 29.09.23.
////
//
//import UIKit
//
//enum StoreError: Error {
//    case modelNotFound
//    case failedToLoadPersistentContainer(Error)
//    case failedToRecordModel(Error)
//    case failedToDeleteModel(Error)
//    case failedToUpdateModel(Error)
//}
//
//final class TrackersViewController: UIViewController {
//    private struct ConstantsTrackerVc {
//        static let adButtonImageName = "Add"
//        static let imageStar = "Star"
//        static let imageNothingFound = "NothingFound"
//        
//        static let headerText = "Трекеры"
//        static let labelStabText = "Что будем отслеживать?"
//        static let labelNothingFoundText = "Ничего не найдено"
//        static let placeholderSearch = "Поиск"
//        static let textCancel = "Отменить"
//        static let forKeyTextCancel = "cancelButtonText"
//        static let rusLocale = "ru_Ru"
//        
//        static let datePickerCornerRadius = CGFloat(8)
//        static let heightCollectionView = CGFloat(148)
//        
//        static let fontLableTextStab = UIFont.systemFont(ofSize: 12, weight: .medium)
//        static let fontLabelHeader = UIFont.boldSystemFont(ofSize: 34)
//    }
//
//    private var flagStab: Bool = false
//    private var categories: [TrackerCategory] = []
//    private var completedTrackers: Set<TrackerRecord> = []
//    private var currentDate: Date { datePicker.date }
//    private var visibleCategories: [TrackerCategory] = []
//    
//    private lazy var trackerRecordStore: TrackerRecordStoreProtocol = {
//        let treckerRecordStore = TrackerRecordStore()
//
//        return treckerRecordStore
//    }()
//
//    private lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
//        let trackerCategoryStore = TrackerCategoryStore()
//        trackerCategoryStore.delegate = self
//        
//        return trackerCategoryStore
//    }()
//
//    private lazy var trackerStore: TrackerStoreProtocol = {
//        let trackerStore = TrackerStore()
//        
//        return trackerStore
//    }()
//    
//    private lazy var horisontalStack: UIStackView = {
//        let horisontalStack = UIStackView()
//        horisontalStack.axis = .horizontal
//        horisontalStack.alignment = .center
//        
//        return horisontalStack
//    }()
//    
//    private lazy var averageStack: UIStackView = {
//        let averageStack = UIStackView()
//        averageStack.backgroundColor = .clear
//        averageStack.axis = .vertical
//        averageStack.translatesAutoresizingMaskIntoConstraints = false
//        
//        return averageStack
//    }()
//    
//    private lazy var verticalStack: UIStackView = {
//        let verticalStack = UIStackView()
//        verticalStack.axis = .vertical
//        verticalStack.translatesAutoresizingMaskIntoConstraints = false
//        
//        return verticalStack
//    }()
//    
//    private lazy var datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .compact
//        datePicker.locale = Locale(identifier: ConstantsTrackerVc.rusLocale)
//        datePicker.calendar.firstWeekday = 2
//        datePicker.layer.cornerRadius = ConstantsTrackerVc.datePickerCornerRadius
//        datePicker.layer.masksToBounds = true
//        datePicker.addTarget(self, action: #selector(actionForTapDatePicker), for: .valueChanged)
//        
//        return datePicker
//    }()
//    
//    private lazy var lableHeader: UILabel = {
//        let lableHeader = UILabel()
//        lableHeader.text = ConstantsTrackerVc.headerText
//        lableHeader.font = ConstantsTrackerVc.fontLabelHeader
//        lableHeader.textColor = .blackDay
//        lableHeader.translatesAutoresizingMaskIntoConstraints = false
//        lableHeader.backgroundColor = .clear
//        
//        return lableHeader
//    }()
//    
//    private lazy var trackerCollectionView: TrackerCollectionView = {
//        let trackerCollectionView = greateTrackerCollectionView()
//        trackerCollectionView.backgroundColor = .clear
//        trackerCollectionView.showsVerticalScrollIndicator = false
//        registerCellAndHeader(collectionView: trackerCollectionView)
//        
//        return trackerCollectionView
//    }()
//    
//    private lazy var imageViewStab: UIImageView = {
//        let imageViewStab = UIImageView()
//        imageViewStab.isHidden = true
//        
//        return imageViewStab
//    }()
//    
//    private lazy var lableTextStab: UILabel = {
//        let lableTextStab = UILabel()
//        lableTextStab.font = ConstantsTrackerVc.fontLableTextStab
//        lableTextStab.isHidden = true
//        
//        return lableTextStab
//    }()
//    
//    private lazy var contentView: UIView = {
//        let contentView = UIView()
//        contentView.backgroundColor = .clear
//        
//        return contentView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        completedTrackers = trackerRecordStore.treckersRecords
//        categories = trackerCategoryStore.treckerCategory
//        visibleCategories = categories
//        view.backgroundColor = .white
//        setupUIElement()
//        showListTrackersForDay(trackerCategory: categories)
//    }
//}
//
//extension TrackersViewController {
//    //MARK: - обработка событий
//    @objc
//    private func actionForTapDatePicker(sender: UIDatePicker) {
//        chengeStab(text: ConstantsTrackerVc.labelStabText, nameImage: ConstantsTrackerVc.imageStar)
//        showListTrackersForDay(trackerCategory: categories)
//    }
//    
//    @objc
//    private func didTapLeftNavBarItem() {
//        let greateVC = EventSelectionViewController()
//        greateVC.delegate = self
//        greateVC.modalPresentationStyle = .formSheet
//        present(greateVC, animated: true)
//    }
//    
//    private func showMessageErrorAlert(message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
//            alert.dismiss(animated: true)
//        }
//        alert.addAction(action)
//    }
//    
//    //MARK: - Логика
//    
//    //метод показа трекеров после фильтрации по дням
//    private func showListTrackersForDay(trackerCategory: [TrackerCategory]) {
//        let listCategories = filterListTrackersWeekDay(trackerCategory: trackerCategory, date: currentDate)
//        updateTrackerCollectionView(trackerCategory: listCategories)
//    }
//    
//    //метод обновления коллекции
//    private func updateTrackerCollectionView(trackerCategory: [TrackerCategory]) {
//        visibleCategories = trackerCategory
//        showStabView(flag: !trackerCategory.isEmpty)
//        trackerCollectionView.reloadData()
//    }
//    
//    //метод изменения заглушки
//    private func chengeStab(text: String, nameImage: String) {
//        lableTextStab.text = text
//        imageViewStab.image = UIImage(named: nameImage)
//    }
//    
//    //метод сравнения дней недели
//    private func comparisonWeekDays(date: Date, day: WeekDay) -> Bool {
//        FormatDate.shared.greateWeekDayInt(date: date) == day.rawValue
//    }
//    
//    //метод отфильтровывает трекеры по заданному дню недели
//    private func filterListTrackersWeekDay(trackerCategory: [TrackerCategory], date: Date) -> [TrackerCategory] {
//        var listCategories: [TrackerCategory] = []
//        for cat in 0..<trackerCategory.count {
//            let currentCategori = trackerCategory[cat]
//            var trackers: [Tracker] = []
//            for tracker in 0..<trackerCategory[cat].arrayTrackers.count {
//                let listWeekDay = trackerCategory[cat].arrayTrackers[tracker].schedule
//                for day in 0..<listWeekDay.count {
//                    if comparisonWeekDays(date: date, day: listWeekDay[day]) {
//                        let tracker = trackerCategory[cat].arrayTrackers[tracker]
//                        trackers.append(tracker)
//                        break
//                    }
//                }
//            }
//            if !trackers.isEmpty {
//                let trackerCat = TrackerCategory(nameCategory: currentCategori.nameCategory, arrayTrackers: trackers)
//                listCategories.append(trackerCat)
//            }
//        }
//        return listCategories
//    }
//    
//    //метод отфильтровывает трекеры по названию
//    private func filterListTrackersName(trackerCategory: [TrackerCategory], word: String) -> [TrackerCategory] {
//        let listCategories: [TrackerCategory] = trackerCategory
//        var newCategories: [TrackerCategory] = []
//        let searchString = word.lowercased()
//        listCategories.forEach { categori in
//            var newTrackers: [Tracker] = []
//            categori.arrayTrackers.forEach { tracker in
//                if tracker.name.lowercased().hasPrefix(searchString) {
//                    newTrackers.append(tracker)
//                }}
//            if !newTrackers.isEmpty {
//                let newCategorie = TrackerCategory(nameCategory: categori.nameCategory, arrayTrackers: newTrackers)
//                newCategories.append(newCategorie)
//            }
//        }
//        return newCategories
//    }
//    
//    //функция для сравнения двух дат, вернет true, если дата больше или равна текущей
//    func dateComparison(date: Date, currentDate: Date) -> Bool {
//        let result = Calendar.current.compare(date, to: currentDate, toGranularity: .day)
//        var flag: Bool
//        switch result {
//        case .orderedAscending:
//            flag = false
//        case .orderedSame:
//            flag = true
//        case .orderedDescending:
//            flag = true
//        }
//        return flag
//    }
//    
//    //метод показа/скрытия заглушки
//    private func showStabView(flag: Bool) {
//        [imageViewStab, lableTextStab].forEach { $0.isHidden = flag }
//    }
//    
//    //метод создания кастомной CollectionView
//    private func greateTrackerCollectionView() -> TrackerCollectionView {
//        let params = GeometricParams(cellCount: 2, leftInset: 0, rightInset: 0, cellSpacing: 12)
//        let layout = UICollectionViewFlowLayout()
//        let trackerCollectionView = TrackerCollectionView(frame: .zero,
//                                                          collectionViewLayout: layout,
//                                                          params: params)
//        return trackerCollectionView
//    }
//    
//    private func registerCellAndHeader(collectionView: TrackerCollectionView) {
//        collectionView.register(TrackersCollectionViewCell.self,
//                                forCellWithReuseIdentifier: "\(TrackersCollectionViewCell.self)")
//        collectionView.register(HeaderReusableView.self,
//                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                                withReuseIdentifier: "\(HeaderReusableView.self)")
//    }
//    
//    //MARK: - SetupUI
//    private func setupUIElement() {
//        setupVerticalSteck()
//        setupContentView()
//        setupStabView()
//        setupNavBarItem()
//    }
//    
//    private func setupNavBarItem() {
//        guard let navBar = navigationController?.navigationBar,
//              let topItem = navBar.topItem
//        else { return }
//        topItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: ConstantsTrackerVc.adButtonImageName),
//                                                    style: .plain, target: self,
//                                                    action: #selector(didTapLeftNavBarItem))
//        
//        topItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
//        topItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
//        topItem.leftBarButtonItem?.tintColor = .blackDay
//        navBar.backgroundColor = .clear
//        
//        navigationItem.title = ConstantsTrackerVc.headerText
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        let searcheController = UISearchController(searchResultsController: nil)
//        searcheController.searchResultsUpdater = self
//        searcheController.obscuresBackgroundDuringPresentation = false
//        searcheController.hidesNavigationBarDuringPresentation = false
//        navigationItem.searchController = searcheController
//        searcheController.searchBar.placeholder = ConstantsTrackerVc.placeholderSearch
//        searcheController.searchBar.resignFirstResponder()
//        searcheController.searchBar.returnKeyType = .search
//        searcheController.searchBar.setValue(ConstantsTrackerVc.textCancel, forKey: ConstantsTrackerVc.forKeyTextCancel)
//        
//    }
//    
//    private func setupContentView() {
//        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(trackerCollectionView)
//        
//        NSLayoutConstraint.activate([
//            trackerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            trackerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            trackerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            trackerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        ])
//        
//        trackerCollectionView.delegate = self
//        trackerCollectionView.dataSource = self
//    }
//    
//    private func setupVerticalSteck() {
//        view.addSubview(verticalStack)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = .clear
//        verticalStack.addArrangedSubview(contentView)
//        
//        NSLayoutConstraint.activate([
//            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//    }
//    
//    private func setupStabView() {
//        [imageViewStab, lableTextStab].forEach {
//            contentView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            $0.backgroundColor = .clear
//        }
//        
//        NSLayoutConstraint.activate([
//            imageViewStab.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            imageViewStab.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            
//            lableTextStab.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            lableTextStab.topAnchor.constraint(equalTo: imageViewStab.bottomAnchor, constant: 10)
//        ])
//    }
//}
//
////MARK: - UICollectionViewDataSource
//extension TrackersViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        visibleCategories[section].arrayTrackers.count
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        visibleCategories.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackersCollectionViewCell.self)",
//                                                            for: indexPath) as? TrackersCollectionViewCell
//        else { return UICollectionViewCell() }
//        cell.delegate = self
//        let tracker = categories[indexPath.section].arrayTrackers[indexPath.row]
//        let dateComparison = Calendar.current.compare(Date(), to: currentDate, toGranularity: .day)
//        switch dateComparison {
//        case .orderedAscending:
//            cell.isEnableAddButton(flag: false)
//            cell.updateBackgraundAddButton(isHidden: false)
//        case .orderedSame:
//            cell.isEnableAddButton(flag: true)
//            cell.updateBackgraundAddButton(isHidden: true)
//        case .orderedDescending:
//            cell.isEnableAddButton(flag: true)
//            cell.updateBackgraundAddButton(isHidden: true)
//        }
//        
//        do {
//            let count = try trackerRecordStore.loadTrackerRecord(id: tracker.id)
//            let isComplited = completedTrackers.contains (where: { $0.id == tracker.id && Calendar.current.isDate(currentDate, equalTo: $0.date, toGranularity: .day)})
//            cell.config(tracker: tracker, count: count, isComplited: isComplited)
//        }
//        catch {
//            let errorCount = TrackrerRecordStoreError.loadTrackerRecord(error)
//            showMessageErrorAlert(message: "\(errorCount)")
//        }
//        
//        return cell
//    }
//}
//
////MARK: - UICollectionViewDelegateFlowLayout
//extension TrackersViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let availableWidth = collectionView.frame.width - trackerCollectionView.params.paddingWidth
//        let cellWidth = availableWidth / CGFloat(trackerCollectionView.params.cellCount)
//        let sizeCell = CGSize(width: cellWidth, height: ConstantsTrackerVc.heightCollectionView)
//        
//        return sizeCell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 10, left: trackerCollectionView.params.leftInset,
//                     bottom: 16, right: trackerCollectionView.params.rightInset)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let indexPath = IndexPath(row: visibleCategories.count, section: section)
//        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//        
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
//            supplementary.label.text = categories[indexPath.section].nameCategory
//            return supplementary
//        default:
//            return UICollectionReusableView()
//        }
//    }
//}
//
////MARK: - TrackersCollectionViewCellDelegate
//extension TrackersViewController: TrackersCollectionViewCellDelegate {
//    func didTrackerCompleted(_ cell: UICollectionViewCell) {
//        guard let trackerCell = cell as? TrackersCollectionViewCell,
//              let indexPath = trackerCollectionView.indexPath(for: trackerCell)
//        else { return }
//        /* делаем проверку. Сравниваем свойство currentDate с текущей датой, если currentDate
//         больше чем текучая дата,отмечать трекер выполненным нельзя, выходим из функции */
////        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
//        let tracker = trackerCategoryStore.treckerCategory[indexPath.section]
//            .arrayTrackers[indexPath.row]
//        let recordTracker = completedTrackers.first(where: { $0.id == tracker.id &&
//            Calendar.current.isDate($0.date, inSameDayAs: currentDate) })
//        updateCompleted(recordTracker: recordTracker,
//                        cell: trackerCell,
//                        indexPath: indexPath,
//                        flag: recordTracker == nil,
//                        tracker: tracker)
//    }
//    
//    private func updateCompleted(recordTracker: TrackerRecord?,
//                                 cell: TrackersCollectionViewCell,
//                                 indexPath: IndexPath,
//                                 flag: Bool,
//                                 tracker: Tracker) {
//        if let recordTracker {
//            do {
//                try trackerRecordStore.deleteTrackerRecord(recordTracker)
//            } catch {
//                let deleteError = StoreError.failedToRecordModel(error)
//                showMessageErrorAlert(message: "\(deleteError)")
//            }
//            completedTrackers.remove(recordTracker)
//            trackerCollectionView.reloadItems(at: [indexPath])
//            return
//        }
//        let newTracker = TrackerRecord(id: tracker.id, date: currentDate)
//        do {
//            try trackerRecordStore.addNewTrackerRecord(newTracker)
//        } catch {
//            let recordError = StoreError.failedToRecordModel(error)
//            showMessageErrorAlert(message: "\(recordError)")
//        }
//        completedTrackers.insert(newTracker)
//        trackerCollectionView.reloadItems(at: [indexPath])
//    }
//}
//
////MARK: - UISearchResultsUpdating
//extension TrackersViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let word = searchController.searchBar.text else { return }
//        print(word)
//        if !word.isEmpty {
//            let newCategories = filterListTrackersName(trackerCategory: categories, word: word)
//            
//            updateTrackerCollectionView(trackerCategory: newCategories)
//            print(newCategories.count)
//        }
//        chengeStab(text: ConstantsTrackerVc.labelNothingFoundText, nameImage: ConstantsTrackerVc.imageNothingFound)
//        
//        if !searchController.isActive {
//            showListTrackersForDay(trackerCategory: categories)
//        }
//    }
//}
//
////MARK: - EventSelectionViewControllerDelegate
//extension TrackersViewController: EventSelectionViewControllerDelegate {
//    func eventSelectionViewController(vc: UIViewController, nameCategories: String, tracker: Tracker) {
//        for (index, value) in visibleCategories.enumerated() {
//            if value.nameCategory.lowercased() == nameCategories.lowercased() {
//                let categoryIndexPath = IndexPath(item: 0, section: index)
//                do {
//                    try trackerCategoryStore.addNewTracker(tracker, indexPath: categoryIndexPath)
//                } catch {
//                    let updateError = StoreError.failedToUpdateModel(error)
//                    showMessageErrorAlert(message: "\(updateError)")
//                }
//            }
//            return
//        }
//        do {
//            try trackerCategoryStore.addNewCategory(nameCategory: nameCategories, tracker: tracker)
//        } catch {
//            let addError = StoreError.failedToRecordModel(error)
//            showMessageErrorAlert(message: "\(addError)")
//        }
//    }
//    
//    func eventSelectionViewControllerDidCancel(_ vc: EventSelectionViewController) {
//        vc.dismiss(animated: false)
//    }
//}
//
////MARK: - TrackerCategoryStoreDelegate
//extension TrackersViewController: TrackerCategoryStoreDelegate {
//    func store(_ trackerStore: TrackerCategoryStore) {
//        print(visibleCategories[0].arrayTrackers.count)
//        visibleCategories = trackerCategoryStore.treckerCategory
//        categories = visibleCategories
//        print(visibleCategories[0].arrayTrackers.count)
//        showListTrackersForDay(trackerCategory: categories)
//    }
//}
