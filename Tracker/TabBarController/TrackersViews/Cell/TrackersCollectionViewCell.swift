//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

fileprivate let adButtonImageAdd = UIImage(named: "Add")
fileprivate let adButttonImageDone = UIImage(named: "Done")

fileprivate let cornerRadiusColorView = CGFloat(16)
fileprivate let borderWidthColorView = CGFloat(1)

fileprivate let fontLabelEmoji = UIFont.systemFont(ofSize: 16, weight: .medium)
fileprivate let fontTextLable = UIFont.systemFont(ofSize: 12, weight: .medium)
fileprivate let fontLableDayCounter = UIFont.systemFont(ofSize: 12, weight: .medium)

fileprivate let sizeLableView = CGSize(width: 34, height: 34)
fileprivate let sizeAddButton = CGSize(width: 34, height: 34)

//MARK: - TrackersCollectionViewCellDelegate
protocol TrackersCollectionViewCellDelegate: AnyObject {
    func didTrackerCompleted(_ cell: UICollectionViewCell, count: Int, flag: Bool)
}

//MARK: - TrackersCollectionViewCell
final class TrackersCollectionViewCell: UICollectionViewCell {
    private var count: Int = 0
    private var flag: Bool = false
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = cornerRadiusColorView
        colorView.layer.borderWidth = borderWidthColorView
        colorView.layer.borderColor = (UIColor.backgroundNight).cgColor
        
        return colorView
    }()
    
    lazy var lableEmoji: UILabel = {
        let lableEmoji = UILabel()
        lableEmoji.font = fontLabelEmoji
        lableEmoji.layer.cornerRadius = cornerRadiusColorView
        lableEmoji.layer.masksToBounds = true
        lableEmoji.backgroundColor = .backgroundNight
        lableEmoji.textAlignment = .center
        
        return lableEmoji
    }()
    
    lazy var nameTrackerLabel: UILabel = {
        let nameTrackerLabel = UILabel()
        nameTrackerLabel.numberOfLines = 2
        nameTrackerLabel.font = fontTextLable
        nameTrackerLabel.textColor = .white
        nameTrackerLabel.textAlignment = .justified
        
        return nameTrackerLabel
    }()
    
    lazy var lableDayCounter: UILabel = {
        let lableDayCounter = UILabel()
        lableDayCounter.textColor = .blackDay
        lableDayCounter.font = fontLableDayCounter
        lableDayCounter.text = "\(count) дней"
        
        return lableDayCounter
    }()
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        let image = adButtonImageAdd?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .whiteDay
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = sizeAddButton.width / 2
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .allEvents)
        
        return addButton
    }()
    
    private lazy var backgroundAddButtonView: UIView = {
        let backgroundAddButtonView = UIView()
        backgroundAddButtonView.isHidden = true
        backgroundAddButtonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundAddButtonView.layer.cornerRadius = sizeAddButton.width / 2
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
        delegate?.didTrackerCompleted(self, count: count, flag: flag)
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
    func updateLableCountAndImageAddButton(textLable: String, flag: Bool) {
        switch flag {
        case true:
            let image = adButttonImageDone?.withRenderingMode(.alwaysTemplate)
            addButton.setImage(image, for: .normal)
            lableDayCounter.text = textLable
            self.flag = flag
            backgroundAddButtonView.isHidden = true
        case false:
            let image = adButtonImageAdd?.withRenderingMode(.alwaysTemplate)
            addButton.setImage(image, for: .normal)
            lableDayCounter.text = textLable
            self.flag = flag
            backgroundAddButtonView.isHidden = true
        }
    }
    
    //метод добавляет фон на кнопку addButton
    func addBackgraundAddButton() {
        backgroundAddButtonView.isHidden = false
    }
    
    //метод удаляет фон на кнопку addButton
    func deleteBackgraundAddButton() {
        backgroundAddButtonView.isHidden = true
    }
    
    //метод конфигурации ячейки
    func config(tracker: Tracker) {
        colorView.backgroundColor = tracker.color
        lableEmoji.text = tracker.emoji
        addButton.backgroundColor = tracker.color
        nameTrackerLabel.text = tracker.name
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
        [lableDayCounter, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horisontalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            lableDayCounter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            lableDayCounter.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            
            addButton.heightAnchor.constraint(equalToConstant: sizeAddButton.height),
            addButton.widthAnchor.constraint(equalToConstant: sizeAddButton.width),
            addButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupBackgroundAddButtonView() {
        addButton.addSubview(backgroundAddButtonView)
        
        NSLayoutConstraint.activate([
            backgroundAddButtonView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            backgroundAddButtonView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            backgroundAddButtonView.heightAnchor.constraint(equalToConstant: sizeAddButton.height),
            backgroundAddButtonView.widthAnchor.constraint(equalToConstant: sizeAddButton.width)
        ])
    }
    
    private func setupColorView() {
        [lableEmoji, nameTrackerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            colorView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            lableEmoji.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            lableEmoji.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            lableEmoji.heightAnchor.constraint(equalToConstant: sizeLableView.height),
            lableEmoji.widthAnchor.constraint(equalToConstant: sizeLableView.width),
            
            nameTrackerLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameTrackerLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
    }
}
