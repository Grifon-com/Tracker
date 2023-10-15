//
//  GreateTrackerTableViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit


//MARK: - GreateTrackerTableViewCellDelegate
protocol GreateTrackerTableViewCellDelegate: AnyObject {
    func trackerTableViewCellDidTapChoiceButton(cell: UITableViewCell)
}

//MARK: - GreateTrackerTableViewCell
class GreateTrackerTableViewCell: UITableViewCell {
    private struct ConstantsGreateCell {
        static let iconButton = "IconButtonCell"
        static let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let choiceButtonSize = CGSize(width: 44, height: 44)
        static let cornerRadiusViewCell = CGFloat(16)
    }
    
    weak var delegate: GreateTrackerTableViewCellDelegate?
    
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
    
    private lazy var choiceButton: UIButton = {
        let frame = CGRect(origin: .zero, size:  ConstantsGreateCell.choiceButtonSize)
        let choiceButton = UIButton(frame: frame)
        let image = UIImage(named:  ConstantsGreateCell.iconButton)
        choiceButton.setImage(image, for: .normal)
        choiceButton.imageView?.tintColor = .blueDay
        choiceButton.addTarget(self, action: #selector(didTapChoiceButton), for: .touchUpInside)
        
        return choiceButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        choiceButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(choiceButton)
        choiceButton.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            choiceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            choiceButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            choiceButton.heightAnchor.constraint(equalToConstant: 44),
            choiceButton.widthAnchor.constraint(equalToConstant: 44),
            contentView.heightAnchor.constraint(equalToConstant: 75)
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
    
    @objc
    private func didTapChoiceButton() {
        delegate?.trackerTableViewCellDidTapChoiceButton(cell: self)
    }
}
