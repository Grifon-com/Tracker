//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

private enum ConstantsTrackerVC {
    static let adButtonImageName = "Add"
    static let imageViewImageName = "Star"
    
    static let labelHeaderText = "Трекеры"
    static let labelStabText = "Что будем отслеживать?"
    
    static let datePickerCornerRadius = CGFloat(8)
    static let heightCollectionView = CGFloat(148)
    
    static let fontLableTextStab = UIFont.systemFont(ofSize: 12)
    static let fontLabelHeader = UIFont.boldSystemFont(ofSize: 34)
}

final class TrackersViewController: UIViewController {
    private var categories: [TrackerCategory] = [TrackerCategory(header: "Еда", arrayCategory: [Tracker(name: "Приготовить еду ", color: .colorSelection11, emoji: "🍏"),
                                                                                                Tracker(name: "Одежда", color: .colorSelection15, emoji: "🍏")])]
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
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
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.addTarget(nil, action: #selector(addHabitorEvent), for: .allTouchEvents)
        let image = UIImage(named: ConstantsTrackerVC.adButtonImageName)
        addButton.setImage(image, for: .normal)
        
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.layer.cornerRadius = ConstantsTrackerVC.datePickerCornerRadius
        datePicker.layer.masksToBounds = true
        datePicker.addTarget(self, action: #selector(actionForTapDatePicker), for: .allEvents)
        
        return datePicker
    }()
    
    private lazy var lableHeader: UILabel = {
        let lableHeader = UILabel()
        lableHeader.text = ConstantsTrackerVC.labelHeaderText
        lableHeader.font = ConstantsTrackerVC.fontLabelHeader
        lableHeader.textColor = .blackDay
        
        return lableHeader
    }()
    
    private lazy var seerchTextField: UISearchTextField = {
        let seerchText = UISearchTextField()
        seerchText.delegate = self
        
        return seerchText
    }()
    
    private lazy var trackerCollectionView: TrackerCollectionView = {
        let trackerCollectionView = greateTrackerCollectionView()
        trackerCollectionView.backgroundColor = .clear
        registerCellAndHeader(collectionView: trackerCollectionView)
        
        return trackerCollectionView
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        let image = UIImage(named: ConstantsTrackerVC.imageViewImageName)
        imageViewStab.image = image
        imageViewStab.isHidden = true
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.text = ConstantsTrackerVC.labelStabText
        lableTextStab.font = ConstantsTrackerVC.fontLableTextStab
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
        setupVerticalSteck()
        setupHorisontalStack()
        setupContentView()
        setupStabView()
    }
}

private extension TrackersViewController {
    @objc
    func actionForTapDatePicker(sender: UIDatePicker) {
        let flag = Calendar.current.compare(currentDate, to: sender.date, toGranularity: .day)
        switch flag {
        case .orderedAscending:
            return
        case .orderedSame:
            print(sender.date)
        case .orderedDescending:
            return
        }
    }
    
    func showStabView(flag: Bool) {
        [imageViewStab, lableTextStab].forEach { $0.isHidden = flag }
    }
    
    func registerCellAndHeader(collectionView: UICollectionView) {
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: "\(TrackersCollectionViewCell.self)")
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(HeaderReusableView.self)")
    }
    
    @objc
    func addHabitorEvent() {
        let greateVC = EventSelectionViewController()
        greateVC.modalPresentationStyle = .formSheet
        tabBarController?.tabBar.barTintColor = .black
        present(greateVC, animated: true)
    }
    
    func greateTrackerCollectionView() -> TrackerCollectionView {
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
    
    func setupHorisontalStack() {
        [addButton, datePicker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horisontalStack.addArrangedSubview($0)
            $0.backgroundColor = .clear
        }
        addButton.leadingAnchor.constraint(equalTo: horisontalStack.leadingAnchor, constant: -10).isActive = true
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
        
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
    }
    
    func setupVerticalSteck() {
        view.addSubview(verticalStack)
        [horisontalStack, lableHeader, seerchTextField, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            verticalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        verticalStack.setCustomSpacing(6, after: lableHeader)
    }
    
    func setupStabView() {
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

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].arrayCategory.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackersCollectionViewCell.self)", for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
        let tracker = categories[indexPath.section].arrayCategory[indexPath.row]
        cell.colorView.backgroundColor = tracker.color
        cell.lableEmoji.text = tracker.emoji
        cell.addButton.backgroundColor = tracker.color
        cell.nameTrackerLabel.text = tracker.name
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - trackerCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(trackerCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: ConstantsTrackerVC.heightCollectionView)
        
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: trackerCollectionView.params.leftInset,
                     bottom: 16, right: trackerCollectionView.params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            supplementary.label.text = categories[indexPath.section].header
            print(categories[indexPath.section].header)
            return supplementary
        default:
           return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: categories.count, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: UITextFieldDelegate {
    
}
