//
//  GreateTrackerTableViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

//MARK: - GreateTrackerTableViewCell
class GreateTrackerTableViewCell: UITableViewCell {
    private struct ConstantsGreateCell {
        static let iconButton = "IconButtonCell"
        static let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let choiceButtonSize = CGSize(width: 44, height: 44)
        static let cornerRadiusViewCell = CGFloat(16)
    }
    
    private lazy var lableView: UILabel = {
        let lableView = UILabel()
        lableView.font = ConstantsGreateCell.lableFont
        lableView.textColor = .blackDay
        
        return lableView
    }()
    
    private lazy var secondaryTextLable: UILabel = {
        let secondaryTextLable = UILabel()
        secondaryTextLable.font =  ConstantsGreateCell.lableFont
        secondaryTextLable.textColor = .grayDay
        secondaryTextLable.isHidden = true
        
        return secondaryTextLable
    }()
    
    private lazy var lableStackView: UIStackView = {
        let lableStackView = UIStackView()
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        lableStackView.axis = .vertical
        
        return lableStackView
    }()
    
    private lazy var clickImage: UIImageView = {
        let clickImage = UIImageView()
        let image = UIImage(named:  ConstantsGreateCell.iconButton)
        clickImage.image = image
        
        return clickImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUIElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GreateTrackerTableViewCell {
    //MARK: - SetupUI
    private func setupUIElement() {
        setupSelf()
        setupSteckView()
    }
    
    private func setupSelf() {
        backgroundColor = .backgroundNight
        layer.cornerRadius = ConstantsGreateCell.cornerRadiusViewCell
        layer.masksToBounds = true
        clickImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(clickImage)
        clickImage.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            clickImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            clickImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            clickImage.heightAnchor.constraint(equalToConstant: 24),
            clickImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupSteckView() {
        contentView.addSubview(lableStackView)
        [lableView, secondaryTextLable].forEach {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            lableStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            lableStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            lableStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    //MARK: - Configuration
    func configCell(choice: ChoiceParametrs) {
        lableView.text = choice.name
    }
    
    func configSecondaryLableShedule(secondaryText: String) {
        if !secondaryText.isEmpty {
            secondaryTextLable.text = secondaryText
            secondaryTextLable.isHidden = false
        }
    }
}
