//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func editTracker(vc: TrackersViewController, editTracker: Tracker, nameCategory: String, indexPath: IndexPath)
}

//MARK: - TrackersViewController
final class TrackersViewController: UIViewController {
    private struct ConstantsTrackerVc {
        static let adButtonImageName = "Add"
        static let isPinnedImage = "isPinned"
        static let imageStar = "Star"
        static let imageNothingFound = "NothingFound"
        static let forKeyTextCancel = "cancelButtonText"
        
        static let headerText = NSLocalizedString("headerText", comment: "")
        static let labelStabText = NSLocalizedString("labelStabText", comment: "")
        static let labelNothingFoundText = NSLocalizedString("labelNothingFoundText", comment: "")
        static let placeholderSearch = NSLocalizedString("placeholderSearch", comment: "")
        static let textCancel = NSLocalizedString("textCancel", comment: "")
        static let textFix = NSLocalizedString("textFix", comment: "")
        static let textUnpin = NSLocalizedString("textUnpin", comment: "")
        static let textEdit = NSLocalizedString("textEdit", comment: "")
        static let textDelete = NSLocalizedString("textDelete", comment: "")
        static let textFixed = NSLocalizedString("textFixed", comment: "")
        
        static let datePickerCornerRadius = CGFloat(8)
        static let heightCollectionView = CGFloat(148)
        
        static let fontLableTextStab = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let fontLabelHeader = UIFont.boldSystemFont(ofSize: 34)
        
        static let firstWeekday = 2
    }
    
    weak var delegate: TrackersViewControllerDelegate?
    private var viewModel: TrackerViewModelProtocol?
    private let handler = HandlerResultType()
    
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
        datePicker.calendar.firstWeekday = ConstantsTrackerVc.firstWeekday
        datePicker.layer.cornerRadius = ConstantsTrackerVc.datePickerCornerRadius
        datePicker.layer.masksToBounds = true
        datePicker.locale = .current
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
    
    private lazy var trackerCollectionView: TrackerCollectionView = {
        let trackerCollectionView = greateTrackerCollectionView()
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
        trackerCollectionView.backgroundColor = .clear
        trackerCollectionView.showsVerticalScrollIndicator = false
        trackerCollectionView.allowsMultipleSelection = false
        registerCellAndHeader(collectionView: trackerCollectionView)
        
        return trackerCollectionView
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        imageViewStab.image = UIImage(named: ConstantsTrackerVc.imageStar)
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.text = ConstantsTrackerVc.labelStabText
        lableTextStab.font = ConstantsTrackerVc.fontLableTextStab
        
        return lableTextStab
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        
        return contentView
    }()
    
    init(viewModel: TrackerViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIElement()
        viewModel = TrackerViewModel()
        bind()
        guard let viewModel = viewModel as? TrackerViewModel else { return }
        viewModel.getShowListTrackersForDay(date: datePicker.date)
        guard let visibleCategories = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)
        else { return }
        self.showStabView(flag: !visibleCategories.isEmpty)
    }
}

private extension TrackersViewController {
    func bind() {
        guard let viewModel = viewModel as? TrackerViewModel else { return }
        viewModel.$category.bind { [weak self] _ in
            guard let self else { return }
            viewModel.getShowListTrackersForDay(date: self.datePicker.date)
        }
        
        viewModel.$indexPath.bind { [weak self] indexPath in
            guard let self else { return }
            self.trackerCollectionView.reloadItems(at: [indexPath])
        }
        
        viewModel.$visibleCategory.bind { [weak self] result in
            guard let self,
                  let cat = handler.resultTypeHandlerGetValue(result)
            else { return }
            self.showStabView(flag: !cat.isEmpty)
            self.trackerCollectionView.reloadData()
        }
    }
    
    //MARK: - обработка событий
    @objc
    func actionForTapDatePicker() {
        guard let viewModel else { return }
        chengeStab(text: ConstantsTrackerVc.labelStabText, nameImage: ConstantsTrackerVc.imageStar)
        viewModel.getShowListTrackersForDay(date: datePicker.date)
        
    }
    
    @objc
    func didTapLeftNavBarItem() {
        let greateVC = EventSelectionViewController()
        greateVC.delegate = self
        greateVC.modalPresentationStyle = .formSheet
        present(greateVC, animated: true)
    }
    
    //метод изменения заглушки
    func chengeStab(text: String, nameImage: String) {
        lableTextStab.text = text
        imageViewStab.image = UIImage(named: nameImage)
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
    func showStabView(flag: Bool) {
        [imageViewStab, lableTextStab].forEach { $0.isHidden = flag }
    }
    
    //метод создания кастомной CollectionView
    func greateTrackerCollectionView() -> TrackerCollectionView {
        let params = GeometricParams(cellCount: 2, leftInset: .zero, rightInset: .zero, cellSpacing: 12)
        let layout = UICollectionViewFlowLayout()
        let trackerCollectionView = TrackerCollectionView(frame: .zero,
                                                          collectionViewLayout: layout,
                                                          params: params)
        return trackerCollectionView
    }
    
    func registerCellAndHeader(collectionView: TrackerCollectionView) {
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: "\(TrackersCollectionViewCell.self)")
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(HeaderReusableView.self)")
    }
    
    //MARK: - SetupUI
    func setupUIElement() {
        setupVerticalSteck()
        setupContentView()
        setupStabView()
        setupNavBarItem()
    }
    
    func setupNavBarItem() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem
        else { return }
        topItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: ConstantsTrackerVc.adButtonImageName),
                                                    style: .plain, target: self,
                                                    action: #selector(didTapLeftNavBarItem))
        
        topItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        topItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: .zero, left: -10, bottom: .zero, right: .zero)
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
    
    func setupContentView() {
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerCollectionView)
        
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupVerticalSteck() {
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
    
    func setupStabView() {
        [imageViewStab, lableTextStab].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            imageViewStab.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewStab.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lableTextStab.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lableTextStab.topAnchor.constraint(equalTo: imageViewStab.bottomAnchor, constant: 10)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel as? TrackerViewModel,
              let itemsCount = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)?[section].arrayTrackers.count
        else { return .zero }
        return itemsCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = viewModel as? TrackerViewModel,
              let sectionCount = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)?.count
        else { return .zero }
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackersCollectionViewCell.self)",
                                                            for: indexPath) as? TrackersCollectionViewCell,
              let viewModel = viewModel as? TrackerViewModel,
              let visibleCategories = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)
        else { return UICollectionViewCell() }
        cell.delegate = self
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        let dateComparison = Calendar.current.compare(Date(), to: datePicker.date, toGranularity: .day)
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
        cell.setPinned(flag: visibleCategories[indexPath.section].isPinned)
        handler.resultTypeHandler(viewModel.loadTrackerRecord(id: tracker.id)) { [weak self] count in
            guard let self,
                  let isComplited = self.handler.resultTypeHandlerGetValue(viewModel.getIsComplited(tracker: tracker,
                                                                                                    date: self.datePicker.date))
            else { return }
            let updateModel = UpdateTracker(count: count, flag: isComplited)
            cell.config(tracker: tracker)
            cell.updateLableCountAndImageAddButton(updateModel)
        }
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfiguration configuration: UIContextMenuConfiguration,
                        highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = trackerCollectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell
        else { return nil }
        let previewTarget = UIPreviewTarget(container: self.trackerCollectionView, center: cell.center)
        return .init(view: cell.getView(), parameters: UIPreviewParameters(), target: previewTarget)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first,
              let viewModel = viewModel as? TrackerViewModel,
              let visibleCategories = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)
        else { return nil }
        let selectorCategory = visibleCategories[indexPath.section]
        let selectedTracker = selectorCategory.arrayTrackers[indexPath.row]
        let firstContextText = !selectorCategory.isPinned ? ConstantsTrackerVc.textUnpin : ConstantsTrackerVc.textFix
        let secondContentText = ConstantsTrackerVc.textEdit
        let thirdContentText = ConstantsTrackerVc.textDelete
        return UIContextMenuConfiguration(actionProvider:  { _ in
            return UIMenu(children: [
                UIAction(title: firstContextText) { [weak self] _ in
                    guard let self,
                          let cat = self.handler.resultTypeHandlerGetValue(viewModel.getCategory())
                    else { return }
                    if selectorCategory.isPinned {
                        handler.resultTypeHandler(viewModel.addPinnedCategory(id: selectedTracker.id, nameCategory: selectorCategory.nameCategory)) {}
                        self.handler.resultTypeHandler(viewModel.deleteTracker(selectedTracker.id)) {}
                        let filterNameCategory = cat.filter { $0.nameCategory == ConstantsTrackerVc.textFixed }
                        if let _ = filterNameCategory.first?.nameCategory {
                            self.handler.resultTypeHandler(viewModel.addNewTracker(selectedTracker, nameCategory: ConstantsTrackerVc.textFixed)) {}
                        } else {
                            self.handler.resultTypeHandler(viewModel.addCategory(nameCategory: ConstantsTrackerVc.textFixed)) {}
                            self.handler.resultTypeHandler(viewModel.addNewTracker(selectedTracker, nameCategory: ConstantsTrackerVc.textFixed)) {}
                        }
                    } else {
                        if let nameCategory = handler.resultTypeHandlerGetValue(viewModel.deleteAndGetPinnedCategory(id: selectedTracker.id)) {
                            self.handler.resultTypeHandler(viewModel.deleteTracker(selectedTracker.id)) {}
                            if let category = handler.resultTypeHandlerGetValue(viewModel.category)?.filter({ $0.nameCategory == nameCategory }).first {
                                self.handler.resultTypeHandler(viewModel.addNewTracker(selectedTracker, nameCategory: category.nameCategory)) {}
                            } else {
                                guard let nameCategory else { return }
                                self.handler.resultTypeHandler(viewModel.addCategory(nameCategory: nameCategory)) {}
                                self.handler.resultTypeHandler(viewModel.addNewTracker(selectedTracker, nameCategory: nameCategory)) {}
                            }
                        }
                    }
                    guard handler.resultTypeHandlerGetValue(viewModel.category)?.filter ({ $0.nameCategory == ConstantsTrackerVc.textFixed }).first?.arrayTrackers.count == 0 else { return }
                    handler.resultTypeHandler(viewModel.deleteCategory(nameCategory: ConstantsTrackerVc.textFixed)) {}
                },
                UIAction(title: secondContentText) { [weak self] _ in
                    guard let self else { return }
                    let viewModel = CategoryViewModel()
                    let createTrackerVC = CreateTrackerViewController(viewModel: viewModel, updateTrackerDelegate: self, createTrackerDelegate: nil)
                    delegate = createTrackerVC
                    if selectedTracker.schedule.count != viewModel.regular.count {
                        createTrackerVC.reverseIsSchedul()
                    }
                    createTrackerVC.modalPresentationStyle = .fullScreen
                    present(createTrackerVC, animated: true) {
                        self.delegate?.editTracker(vc: self,
                                                   editTracker: selectedTracker,
                                                   nameCategory: selectorCategory.nameCategory, indexPath: indexPath)
                    }
                },
                UIAction(title: thirdContentText, attributes: .destructive) { _ in }
            ])
        })
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
        guard let viewModel = viewModel as? TrackerViewModel,
              let visibleCategories = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)
        else { return CGSize() }
        let indexPath = IndexPath(row: visibleCategories.count, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView,
                  let viewModel = viewModel as? TrackerViewModel,
                  let visibleCategories = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)
            else { return UICollectionReusableView() }
            supplementary.label.text = visibleCategories[indexPath.section].nameCategory
            return supplementary
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let word = searchController.searchBar.text,
              let viewModel
        else { return }
        if !word.isEmpty {
            guard let seachCategory = handler.resultTypeHandlerGetValue(viewModel.filterListTrackersName(word: word)) else { return }
            viewModel.getShowListTrackerSearchForName(seachCategory)
            return
        }
        
        if  word.isEmpty {
            viewModel.getShowListTrackersForDay(date: datePicker.date)
            chengeStab(text: ConstantsTrackerVc.labelNothingFoundText, nameImage: ConstantsTrackerVc.imageNothingFound)
        }
        
        if !searchController.isActive {
            viewModel.getShowListTrackersForDay(date: datePicker.date)
            chengeStab(text: ConstantsTrackerVc.labelStabText, nameImage: ConstantsTrackerVc.imageStar)
        }
    }
}

//MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func didTrackerCompleted(_ cell: UICollectionViewCell) {
        guard let trackerCell = cell as? TrackersCollectionViewCell,
              let indexPath = trackerCollectionView.indexPath(for: trackerCell),
              let viewModel = viewModel as? TrackerViewModel,
              let visibleCategories = handler.resultTypeHandlerGetValue(viewModel.visibleCategory)
        else { return }
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        viewModel.setIndexPath(indexPath)
        handler.resultTypeHandler(viewModel.updateCompletedTrackers(tracker: tracker, date: datePicker.date)) {}
    }
}

//MARK: - EventSelectionViewControllerDelegate
extension TrackersViewController: EventSelectionViewControllerDelegate {
    func eventSelectionViewController(vc: UIViewController, nameCategories: String, tracker: Tracker) {
        guard let viewModel else { return }
        handler.resultTypeHandler(viewModel.addNewTracker(tracker, nameCategory: nameCategories)) {}
    }
    
    func eventSelectionViewControllerDidCancel(_ vc: EventSelectionViewController) {
        vc.dismiss(animated: false)
    }
}

extension TrackersViewController: UpdateTrackerViewControllerDelegate {
    func trackerViewController(vc: UIViewController, nameCategory: String, tracker: Tracker) {
        guard let viewModel else { return }
        handler.resultTypeHandler(viewModel.updateTracker(tracker: tracker, nameCategory: nameCategory)) {}
    }
    
    func trackerViewControllerDidCancel(_ vc: CreateTrackerViewController) {
        vc.dismiss(animated: true)
    }
}
