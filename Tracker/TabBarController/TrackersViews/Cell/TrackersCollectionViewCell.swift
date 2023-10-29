//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

//MARK: - TrackersCollectionViewCellDelegate
protocol TrackersCollectionViewCellDelegate: AnyObject {
    func didTrackerCompleted(_ cell: UICollectionViewCell)
}

//MARK: - TrackersCollectionViewCell
final class TrackersCollectionViewCell: UICollectionViewCell {
    private struct ConstantsTrackerCell {
        static let addButtonImageAdd = "Add"
        static let adButttonImageDone = "Done"

        static let cornerRadiusColorView = CGFloat(16)
        static let borderWidthColorView = CGFloat(1)

        static let fontLabelEmoji = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let fontTextLable = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let fontLableDayCounter = UIFont.systemFont(ofSize: 12, weight: .medium)

        static let sizeLableView = CGSize(width: 34, height: 34)
        static let sizeAddButton = CGSize(width: 34, height: 34)
    }
    
    private var count: Int = 0
    private var isSelectedAddButton: Bool = false
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = ConstantsTrackerCell.cornerRadiusColorView
        colorView.layer.borderWidth = ConstantsTrackerCell.borderWidthColorView
        colorView.layer.borderColor = (UIColor.backgroundNight).cgColor
        
        return colorView
    }()
    
    lazy var emojiLable: UILabel = {
        let emojiLable = UILabel()
        emojiLable.font = ConstantsTrackerCell.fontLabelEmoji
        emojiLable.layer.cornerRadius = ConstantsTrackerCell.cornerRadiusColorView
        emojiLable.layer.masksToBounds = true
        emojiLable.backgroundColor = .backgroundNight
        emojiLable.textAlignment = .center
        
        return emojiLable
    }()
    
    lazy var nameTrackerLabel: UILabel = {
        let nameTrackerLabel = UILabel()
        nameTrackerLabel.numberOfLines = 2
        nameTrackerLabel.font = ConstantsTrackerCell.fontTextLable
        nameTrackerLabel.textColor = .white
        nameTrackerLabel.textAlignment = .justified
        
        return nameTrackerLabel
    }()
    
    lazy var dayCounterLable: UILabel = {
        let dayCounterLable = UILabel()
        dayCounterLable.textColor = .blackDay
        dayCounterLable.font = ConstantsTrackerCell.fontLableDayCounter
        dayCounterLable.text = "\(count) дней"
        
        return dayCounterLable
    }()
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        let image = UIImage(named: ConstantsTrackerCell.addButtonImageAdd)?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .whiteDay
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = ConstantsTrackerCell.sizeAddButton.width / 2
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return addButton
    }()
    
    private lazy var backgroundAddButtonView: UIView = {
        let backgroundAddButtonView = UIView()
        backgroundAddButtonView.isHidden = true
        backgroundAddButtonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundAddButtonView.layer.cornerRadius = ConstantsTrackerCell.sizeAddButton.width / 2
        backgroundAddButtonView.layer.masksToBounds = true
        backgroundAddButtonView.backgroundColor = .grayOpacity30
        
        return backgroundAddButtonView
    }()
    
    private lazy var horisontalStack: UIStackView = {
        let horisontalStack = UIStackView()
        horisontalStack.axis = .horizontal
        horisontalStack.alignment = .center
        horisontalStack.backgroundColor = .clear
        
        return horisontalStack
    }()
    
    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.backgroundColor = .clear
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackersCollectionViewCell {
    //MARK: - Обработка событий
    @objc
    private func didTapAddButton() {
        guard let delegate else { return }
            delegate.didTrackerCompleted(self)
    }
    
    //MARK: - Configuration
    //метод правильного окончания слова "день" в зависимости от значения count
    func endingWordDay(count: Int) -> String {
        var result: String
        switch (count % 10) {
        case 1: result = "\(count) день"
        case 2: result = "\(count) дня"
        case 3: result = "\(count) дня"
        case 4: result = "\(count) дня"
        default: result = "\(count) дней"
        }
        return result
    }
    
    //метод обновления счетчика выполнения трекера и imageButton
    func updateLableCountAndImageAddButton(count: Int, flag: Bool) {
        switch flag {
        case true:
            let image = UIImage(named: ConstantsTrackerCell.adButttonImageDone)?.withRenderingMode(.alwaysTemplate)
            addButton.setImage(image, for: .normal)
            self.count = count
            let textLable = endingWordDay(count: count)
            dayCounterLable.text = textLable
        case false:
            let image = UIImage(named: ConstantsTrackerCell.addButtonImageAdd)?.withRenderingMode(.alwaysTemplate)
            addButton.setImage(image, for: .normal)
            self.count = count
            let textLable = endingWordDay(count: count)
            dayCounterLable.text = textLable
        }
    }
    
    //метод удаляет фон на кнопку addButton
    func updateBackgraundAddButton(isHidden: Bool) {
        backgroundAddButtonView.isHidden = isHidden
    }
    
    func isEnableAddButton(flag: Bool) {
        addButton.isEnabled = flag
    }
    func setIsSelectedAddButton(flag: Bool) {
        isSelectedAddButton = flag
    }
    
    //метод конфигурации ячейки
    func config(tracker: Tracker, count: Int, isComplited: Bool) {
        colorView.backgroundColor = tracker.color
        emojiLable.text = tracker.emoji
        addButton.backgroundColor = tracker.color
        nameTrackerLabel.text = tracker.name
        updateLableCountAndImageAddButton(count: count, flag: isComplited)
    }
    
    //MARK: - SetupUI
    private func setupUIElement() {
        setupColorView()
        setupVerticallStack()
        setupHorisontalStack()
        setupBackgroundAddButtonView()
    }
    
    private func setupVerticallStack() {
        contentView.addSubview(verticalStack)
        [colorView, horisontalStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupHorisontalStack() {
        [dayCounterLable, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horisontalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayCounterLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCounterLable.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            
            addButton.heightAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeAddButton.height),
            addButton.widthAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeAddButton.width),
            addButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupBackgroundAddButtonView() {
        addButton.addSubview(backgroundAddButtonView)
        
        NSLayoutConstraint.activate([
            backgroundAddButtonView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            backgroundAddButtonView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            backgroundAddButtonView.heightAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeAddButton.height),
            backgroundAddButtonView.widthAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeAddButton.width)
        ])
    }
    
    private func setupColorView() {
        [emojiLable, nameTrackerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            colorView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            emojiLable.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLable.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLable.heightAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeLableView.height),
            emojiLable.widthAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeLableView.width),
            
            nameTrackerLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameTrackerLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
    }
}
