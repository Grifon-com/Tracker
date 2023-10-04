//
//  GreateTrackerTableViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

fileprivate let iconButton = "IconButtonCell"
fileprivate let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
fileprivate let choiceButtonSize = CGSize(width: 44, height: 44)
fileprivate let cornerRadiusViewCell = CGFloat(16)

class GreateTrackerTableViewCell: UITableViewCell {
    var lableView: UILabel = {
        let lableView = UILabel()
        lableView.font = lableFont
        lableView.textColor = .blackDay
        
        return lableView
    }()
    
    var choiceButton: UIButton = {
        let frame = CGRect(origin: .zero, size: choiceButtonSize)
        let choiceButton = UIButton(frame: frame)
        let image = UIImage(named: iconButton)
        choiceButton.setImage(image, for: .normal)
        choiceButton.imageView?.tintColor = .blueDay
        
        return choiceButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        backgroundColor = .backgroundNight
        layer.cornerRadius = cornerRadiusViewCell
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GreateTrackerTableViewCell {
    private func setupCell() {
        [lableView, choiceButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            lableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            lableView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            choiceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            choiceButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func configCell(choice: ChoiceParametrs) {
        lableView.text = choice.name
    }
}
