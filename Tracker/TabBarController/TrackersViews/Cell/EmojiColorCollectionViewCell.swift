//
//  EmojiColorCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

//MARK: - ColorCollectionViewCell
final class EmojiColorCollectionViewCell: UICollectionViewCell {
    var emojiView: UILabel = {
        let emojiView = UILabel()
        emojiView.textAlignment = .center
        emojiView.layer.cornerRadius = 8
        emojiView.layer.masksToBounds = true
        emojiView.backgroundColor = .clear
        emojiView.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        
        return emojiView
    }()
    
    var contentColorView: UIView = {
        let contentColorView = UIView()
        contentColorView.layer.masksToBounds = true
        contentColorView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentColorView
    }()
    
    var colorView: UIView = {
        let colorView = UIView()
        colorView.backgroundColor = .clear
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 8
        
        return colorView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiColorCollectionViewCell {
    //MARK: - Config
    func configEmoji(emoji: String) {
        emojiView.text = emoji
    }
    
    func configColor(color: UIColor) {
        colorView.backgroundColor = color
    }
    //MARK: - Selected
    func emojiSelection(isBackground: Bool) {
        emojiView.backgroundColor = isBackground ? .grayDay : .clear
    }
    
    func colorSelection(color: UIColor, flag: Bool) {
        contentColorView.layer.cornerRadius = flag ? 8 : 0
        contentColorView.layer.borderWidth = flag ? 3 : 0
        contentColorView.layer.masksToBounds = flag
        contentColorView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    //MARK: - SetupUI
    private func setupColorView() {
        addSubview(emojiView)
        addSubview(contentColorView)
        contentColorView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            emojiView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiView.heightAnchor.constraint(equalToConstant: 52),
            emojiView.widthAnchor.constraint(equalToConstant: 52),
            contentColorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentColorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentColorView.heightAnchor.constraint(equalToConstant: 52),
            contentColorView.widthAnchor.constraint(equalToConstant: 52),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}
