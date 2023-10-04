//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

private enum ConstantsTrackerCell {
    static let adButtonImageName = "Add"
    
    static let cornerRadiusColorView = CGFloat(16)
    static let borderWidthColorView = CGFloat(1)
    
    static let fontLabelEmoji = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let fontTextLable = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let fontLableDayCounter = UIFont.systemFont(ofSize: 12, weight: .medium)
    
    static let sizeLableView = CGSize(width: 34, height: 34)
    static let sizeAddButton = CGSize(width: 34, height: 34)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = ConstantsTrackerCell.cornerRadiusColorView
        view.layer.borderWidth = ConstantsTrackerCell.borderWidthColorView
        view.layer.borderColor = (UIColor.backgroundNight).cgColor
        //MARK: - Delete
        view.backgroundColor = .green
        
        return view
    }()
    
    lazy var lableEmoji: UILabel = {
        let lableEmoji = UILabel()
        lableEmoji.font = ConstantsTrackerCell.fontLabelEmoji
        lableEmoji.layer.cornerRadius = ConstantsTrackerCell.cornerRadiusColorView
        lableEmoji.layer.masksToBounds = true
        lableEmoji.backgroundColor = .backgroundNight
        lableEmoji.textAlignment = .center
        
        return lableEmoji
    }()
    
    var nameTrackerLabel: UILabel = {
        let nameTrackerLabel = UILabel()
        nameTrackerLabel.numberOfLines = 2
        nameTrackerLabel.font = ConstantsTrackerCell.fontTextLable
        nameTrackerLabel.textColor = .white
        nameTrackerLabel.textAlignment = .justified
        
        return nameTrackerLabel
    }()
    
    lazy var lableDayCounter: UILabel = {
        let lableDayCounter = UILabel()
        lableDayCounter.textColor = .blackDay
        lableDayCounter.font = ConstantsTrackerCell.fontLableDayCounter
        lableDayCounter.text = "\(0) дней"
        
        return lableDayCounter
    }()
    
    lazy var addButton: UIButton = {
        let addButton = UIButton()
        let image = UIImage(named: ConstantsTrackerCell.adButtonImageName)
        addButton.setImage(image, for: .normal)
        addButton.imageView?.tintColor = .white
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = ConstantsTrackerCell.sizeAddButton.width / 2
        addButton.layer.masksToBounds = true
        
        return addButton
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
        setupColorView()
        
        setupVerticallStack()
        setupHorisontalStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackersCollectionViewCell {
    func endingWordDay(number: Int) -> String {
        switch (number % 10) {
        case 1: return "\(number) день"
        case 2: return "\(number) дня"
        case 3: return "\(number) дня"
        case 4: return "\(number) дня"
        default: return "\(number) дней"
        }
    }
}

private extension TrackersCollectionViewCell {
    func setupVerticallStack() {
        contentView.addSubview(verticalStack)
        [colorView, horisontalStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupHorisontalStack() {
        [lableDayCounter, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horisontalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
        lableDayCounter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        lableDayCounter.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
        
        addButton.heightAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeAddButton.height),
        addButton.widthAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeAddButton.width),
        addButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func setupColorView() {
        [lableEmoji, nameTrackerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            colorView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            lableEmoji.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            lableEmoji.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            lableEmoji.heightAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeLableView.height),
            lableEmoji.widthAnchor.constraint(equalToConstant: ConstantsTrackerCell.sizeLableView.width),
            
            nameTrackerLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameTrackerLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
    }
}
