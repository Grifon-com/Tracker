//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

private enum Constants {
    static let adButtonImageName = "Add"
    static let imageViewImageName = "Star"
    
    static let labelHeaderText = "Трекеры"
    static let labelStabText = "Что будем отслеживать?"
    
    static let labelTextSize = CGFloat(34)
    static let datePickerCornerRadius = CGFloat(8)
}

final class TrackersViewController: UIViewController {
    private let params = GeometricParams(cellCount: 2,
                                         leftInset: 16,
                                         rightInset: 16,
                                         cellSpacing: 16)
    
    private lazy var horisontalStack: UIStackView = {
        let horisontalStack = UIStackView()
        horisontalStack.axis = .horizontal
        horisontalStack.distribution = .equalSpacing
        
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
        addButton.backgroundColor = .clear
        let image = UIImage(named: Constants.adButtonImageName)
        addButton.setImage(image, for: .normal)
        
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.layer.cornerRadius = Constants.datePickerCornerRadius
        datePicker.layer.masksToBounds = true
        
        return datePicker
    }()
    
    private lazy var lableHeader: UILabel = {
        let lableHeader = UILabel()
        lableHeader.text = Constants.labelHeaderText
        lableHeader.font = UIFont.boldSystemFont(ofSize: Constants.labelTextSize)
        lableHeader.textColor = .blackDay
        
        return lableHeader
    }()
    
    private lazy var seerchTextField: UISearchTextField = {
        let seerchText = UISearchTextField()
        seerchText.delegate = self
        
        return seerchText
    }()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let trackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        trackerCollectionView.backgroundColor = .clear
        registerCellAndHeader(collectionView: trackerCollectionView)
        
        return trackerCollectionView
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        let image = UIImage(named: Constants.imageViewImageName)
        imageViewStab.image = image
        imageViewStab.isHidden = true
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.text = Constants.labelStabText
        lableTextStab.font = UIFont.systemFont(ofSize: 12)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupStabView(flag: true)
    }
}

private extension TrackersViewController {
    func endingWordDay(number: Int) -> String {
        switch (number % 10) {
        case 1: return "\(number) день"
        case 2: return "\(number) дня"
        case 3: return "\(number) дня"
        case 4: return "\(number) дня"
        default: return "\(number) дней"
        }
    }
    
    func registerCellAndHeader(collectionView: UICollectionView) {
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "\(TrackersCollectionViewCell.self)")
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
    }
    
    @objc
    func addHabitorEvent() {
        let greateVC = GreateTrackersViewController()
        greateVC.modalPresentationStyle = .formSheet
        tabBarController?.tabBar.barTintColor = .black
        present(greateVC, animated: true)
    }
    
    func setupHorisontalStack() {
        [addButton, datePicker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horisontalStack.addArrangedSubview($0)
        }
        
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
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
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            lableHeader.bottomAnchor.constraint(equalTo: seerchTextField.topAnchor, constant: -6),
            lableHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            seerchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            seerchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupStabView(flag: Bool) {
        [imageViewStab, lableTextStab].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            $0.isHidden = flag
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
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackersCollectionViewCell.self)", for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
        cell.colorView.backgroundColor = .colorSelection12
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: 148)
        
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: UITextFieldDelegate {
    
}
