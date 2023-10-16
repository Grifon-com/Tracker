//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

final class TrackersViewController: UIViewController {
    private struct ConstantsTrackerVc {
        static let adButtonImageName = "Add"
        static let imageStar = "Star"
        static let imageNothingFound = "NothingFound"
        
        static let headerText = "Трекеры"
        static let labelStabText = "Что будем отслеживать?"
        static let labelNothingFoundText = "Ничего не найдено"
        static let placeholderSearch = "Поиск"
        static let textCancel = "Отменить"
        static let forKeyTextCancel = "cancelButtonText"
        static let rusLocale = "ru_Ru"
        
        static let datePickerCornerRadius = CGFloat(8)
        static let heightCollectionView = CGFloat(148)
        
        static let fontLableTextStab = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let fontLabelHeader = UIFont.boldSystemFont(ofSize: 34)
    }
    
    private let recordManager: RecordManagerProtocol = RecordManagerStab.shared
    
    private var flafStab: Bool = false
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date { datePicker.date }
    private var visibleCategories: [TrackerCategory] = []
    
    private let date = Date()
    
    private lazy var horisontalStack: UIStackView = {
        let horisontalStack = UIStackView()
        horisontalStack.axis = .horizontal
        horisontalStack.alignment = .center
        
        return horisontalStack
    }()
    
    private lazy var averageStack: UIStackView = {
        let averageStack = UIStackView()
        averageStack.backgroundColor = .clear
        averageStack.axis = .vertical
        averageStack.translatesAutoresizingMaskIntoConstraints = false
        
        return averageStack
    }()
    
    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: ConstantsTrackerVc.rusLocale)
        datePicker.calendar.firstWeekday = 2
        datePicker.layer.cornerRadius = ConstantsTrackerVc.datePickerCornerRadius
        datePicker.layer.masksToBounds = true
        datePicker.addTarget(self, action: #selector(actionForTapDatePicker), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var lableHeader: UILabel = {
        let lableHeader = UILabel()
        lableHeader.text = ConstantsTrackerVc.headerText
        lableHeader.font = ConstantsTrackerVc.fontLabelHeader
        lableHeader.textColor = .blackDay
        lableHeader.translatesAutoresizingMaskIntoConstraints = false
        lableHeader.backgroundColor = .clear
        
        return lableHeader
    }()
    
    lazy var trackerCollectionView: TrackerCollectionView = {
        let trackerCollectionView = greateTrackerCollectionView()
        trackerCollectionView.backgroundColor = .clear
        trackerCollectionView.showsVerticalScrollIndicator = false
        registerCellAndHeader(collectionView: trackerCollectionView)
        
        return trackerCollectionView
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        imageViewStab.isHidden = true
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.font = ConstantsTrackerVc.fontLableTextStab
        lableTextStab.isHidden = true
        
        return lableTextStab
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIElement()
        categories = recordManager.getCategories()
        showListTrackersForDay(trackerCategory: categories)
    }
}

extension TrackersViewController {
    //MARK: - обработка событий
    @objc
    private func actionForTapDatePicker(sender: UIDatePicker) {
        chengeStab(text: ConstantsTrackerVc.labelStabText, nameImage: ConstantsTrackerVc.imageStar)
        showListTrackersForDay(trackerCategory: categories)
    }
    
    @objc
    private func didTapLeftNavBarItem() {
        let greateVC = EventSelectionViewController()
        greateVC.delegate = self
        greateVC.modalPresentationStyle = .formSheet
        present(greateVC, animated: true)
    }
    
    //MARK: - Логика
    
    //метод показа трекеров после фильтрации по дням
    private func showListTrackersForDay(trackerCategory: [TrackerCategory]) {
        let listCategories = filterListTrackersWeekDay(trackerCategory: trackerCategory, date: currentDate)
        updateTrackerCollectionView(trackerCategory: listCategories)
    }
    
    //метод обновления коллекции
    private func updateTrackerCollectionView(trackerCategory: [TrackerCategory]) {
        visibleCategories = trackerCategory
        showStabView(flag: !trackerCategory.isEmpty)
        trackerCollectionView.reloadData()
    }
    
    //метод изменения заглушки
    private func chengeStab(text: String, nameImage: String) {
        lableTextStab.text = text
        imageViewStab.image = UIImage(named: nameImage)
    }
    
    //метод сравнения дней недели
    private func comparisonWeekDays(date: Date, day: WeekDay) -> Bool {
        FormatDate.shared.greateWeekDayInt(date: date) == day.rawValue
    }
    
    //метод отфильтровывает трекеры по заданному дню недели
    private func filterListTrackersWeekDay(trackerCategory: [TrackerCategory], date: Date) -> [TrackerCategory] {
        var listCategories: [TrackerCategory] = []
        for cat in 0..<trackerCategory.count {
            let currentCategori = trackerCategory[cat]
            var trackers: [Tracker] = []
            for tracker in 0..<trackerCategory[cat].arrayTrackers.count {
                let listWeekDay = trackerCategory[cat].arrayTrackers[tracker].schedule
                for day in 0..<listWeekDay.count {
                    if comparisonWeekDays(date: date, day: listWeekDay[day]) {
                        let tracker = trackerCategory[cat].arrayTrackers[tracker]
                        trackers.append(tracker)
                        break
                    }
                }
            }
            if !trackers.isEmpty {
                let trackerCat = TrackerCategory(nameCategori: currentCategori.nameCategori, arrayTrackers: trackers)
                listCategories.append(trackerCat)
            }
        }
        return listCategories
    }
    
    //метод отфильтровывает трекеры по названию
    private func filterListTrackersName(trackerCategory: [TrackerCategory], word: String) -> [TrackerCategory] {
        let listCategories: [TrackerCategory] = trackerCategory
        var newCategories: [TrackerCategory] = []
        let searchString = word.lowercased()
        listCategories.forEach { categori in
            var newTrackers: [Tracker] = []
            categori.arrayTrackers.forEach { tracker in
                if tracker.name.lowercased().hasPrefix(searchString) {
                    newTrackers.append(tracker)
                }}
            if !newTrackers.isEmpty {
                let newCategorie = TrackerCategory(nameCategori: categori.nameCategori, arrayTrackers: newTrackers)
                newCategories.append(newCategorie)
            }
        }
        return newCategories
    }
    
    //функция для сравнения двух дат, вернет true, если дата больше или равна текущей
    func dateComparison(date: Date, currentDate: Date) -> Bool {
        let result = Calendar.current.compare(date, to: currentDate, toGranularity: .day)
        var flag: Bool
        switch result {
        case .orderedAscending:
            flag = false
        case .orderedSame:
            flag = true
        case .orderedDescending:
            flag = true
        }
        return flag
    }
    
    //метод показа/скрытия заглушки
    private func showStabView(flag: Bool) {
        [imageViewStab, lableTextStab].forEach { $0.isHidden = flag }
    }
    
    //метод создания кастомной CollectionView
    private func greateTrackerCollectionView() -> TrackerCollectionView {
        let params = GeometricParams(cellCount: 2,
                                     leftInset: 0,
                                     rightInset: 0,
                                     cellSpacing: 12)
        let layout = UICollectionViewFlowLayout()
        let trackerCollectionView = TrackerCollectionView(frame: .zero,
                                                          collectionViewLayout: layout,
                                                          params: params)
        return trackerCollectionView
    }
    
    private func registerCellAndHeader(collectionView: TrackerCollectionView) {
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: "\(TrackersCollectionViewCell.self)")
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(HeaderReusableView.self)")
    }
    
    //MARK: - SetupUI
    private func setupUIElement() {
        setupVerticalSteck()
        setupContentView()
        setupStabView()
        setupNavBarItem()
    }
    
    private func setupNavBarItem() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem
        else { return }
        topItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: ConstantsTrackerVc.adButtonImageName),
                                                    style: .plain, target: self,
                                                    action: #selector(didTapLeftNavBarItem))
        
        topItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        topItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        topItem.leftBarButtonItem?.tintColor = .blackDay
        navBar.backgroundColor = .clear
        
        navigationItem.title = ConstantsTrackerVc.headerText
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searcheController = UISearchController(searchResultsController: nil)
        searcheController.searchResultsUpdater = self
        searcheController.obscuresBackgroundDuringPresentation = false
        searcheController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searcheController
        searcheController.searchBar.placeholder = ConstantsTrackerVc.placeholderSearch
        searcheController.searchBar.resignFirstResponder()
        searcheController.searchBar.returnKeyType = .search
        searcheController.searchBar.setValue(ConstantsTrackerVc.textCancel, forKey: ConstantsTrackerVc.forKeyTextCancel)
        
    }
    
    private func setupContentView() {
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerCollectionView)
        
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
    }
    
    private func setupVerticalSteck() {
        view.addSubview(verticalStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        verticalStack.addArrangedSubview(contentView)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupStabView() {
        [imageViewStab, lableTextStab].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            imageViewStab.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewStab.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            lableTextStab.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lableTextStab.topAnchor.constraint(equalTo: imageViewStab.bottomAnchor, constant: 10)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].arrayTrackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackersCollectionViewCell.self)",
                                                            for: indexPath) as? TrackersCollectionViewCell
        else { return UICollectionViewCell() }
        cell.delegate = self
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        let dateComparison = Calendar.current.compare(Date(), to: currentDate, toGranularity: .day)
        switch dateComparison {
        case .orderedAscending:
            cell.isEnableAddButton(flag: false)
            cell.updateBackgraundAddButton(isHidden: false)
        case .orderedSame:
            cell.isEnableAddButton(flag: true)
            cell.updateBackgraundAddButton(isHidden: true)
        case .orderedDescending:
            cell.isEnableAddButton(flag: true)
            cell.updateBackgraundAddButton(isHidden: true)
        }
        
        let count = getCountIdForCompletedTrackers(id: tracker.id)
        let recordTracker = completedTrackers.first(where: { $0.id == tracker.id && equalityDates(lDate: currentDate, rDate: $0.date) })
        cell.config(tracker: tracker, count: count, isComplited: recordTracker != nil)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - trackerCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(trackerCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: ConstantsTrackerVc.heightCollectionView)
        
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: trackerCollectionView.params.leftInset,
                     bottom: 16, right: trackerCollectionView.params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: visibleCategories.count, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            supplementary.label.text = visibleCategories[indexPath.section].nameCategori
            return supplementary
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func didTrackerCompleted(_ cell: UICollectionViewCell) {
        guard let trackerCell = cell as? TrackersCollectionViewCell,
              let indexPath = trackerCollectionView.indexPath(for: trackerCell)
        else { return }
        /* делаем проверку. Сравниваем свойство currentDate с текущей датой, если currentDate
         больше чем текучая дата,отмечать трекер выполненным нельзя, выходим из функции */
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        let recordTracker = completedTrackers.first(where: { $0.id == tracker.id && equalityDates(lDate: currentDate, rDate: $0.date) })
        updateCompleted(recordTracker: recordTracker, cell: trackerCell, flag: recordTracker != nil, tracker: tracker)
    }
    
    private func updateCompleted(recordTracker: TrackerRecord?,
                                 cell: TrackersCollectionViewCell,
                                 flag: Bool,
                                 tracker: Tracker) {
        if let recordTracker,
           flag {
            completedTrackers.remove(recordTracker)
            let newCount = getCountIdForCompletedTrackers(id: tracker.id)
            cell.updateLableCountAndImageAddButton(count: newCount, flag: !flag)
            return
        }
        let newTracker = TrackerRecord(id: tracker.id, date: currentDate)
        completedTrackers.insert(newTracker)
        let newCount = getCountIdForCompletedTrackers(id: tracker.id)
        cell.updateLableCountAndImageAddButton(count: newCount, flag: !flag)
    }
    
    private func getCountIdForCompletedTrackers(id: UUID) -> Int {
        let countTrackerRecord = completedTrackers.filter { $0.id == id }
        let count = countTrackerRecord.count
        
        return count
    }
    
    func equalityDates(lDate: Date, rDate: Date?) -> Bool {
        guard let dateY = lDate.ignoringTime, let rDate ,let current = rDate.ignoringTime
        else { return false }
        let dateComparison = Calendar.current.compare(dateY , to: current, toGranularity: .day)
        if case .orderedSame = dateComparison {
            return true
        }
        return false
    }
}

//MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let word = searchController.searchBar.text else { return }
        if !word.isEmpty {
            let newCategories = filterListTrackersName(trackerCategory: categories, word: word)
            updateTrackerCollectionView(trackerCategory: newCategories)
        }
        chengeStab(text: ConstantsTrackerVc.labelNothingFoundText, nameImage: ConstantsTrackerVc.imageNothingFound)
        
        if !searchController.isActive {
            showListTrackersForDay(trackerCategory: categories)
        }
    }
}

//MARK: - EventSelectionViewControllerDelegate
extension TrackersViewController: EventSelectionViewControllerDelegate {
    func eventSelectionViewController(vc: UIViewController, categories: [TrackerCategory]) {
        self.categories = categories
        recordManager.updateCategories(newCategories: categories)
        showListTrackersForDay(trackerCategory: self.categories)
    }
    
    func eventSelectionViewControllerDidCancel(_ vc: EventSelectionViewController) {
        vc.dismiss(animated: false)
    }
}

