//
//  EmojiColorCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

//MARK: - ColorCollectionViewCell
final class EmojiColorCollectionViewCell: UICollectionViewCell {
    private struct ConstantsCell {
        static let cornerRadius = CGFloat(8)
        static let borderWidth = CGFloat(3)
        static let font = UIFont.systemFont(ofSize: 32, weight: .medium)
        static let alfaComponent = CGFloat(0.3)
    }
    
    private var emojiView: UILabel = {
        let emojiView = UILabel()
        emojiView.textAlignment = .center
        emojiView.layer.cornerRadius = ConstantsCell.cornerRadius
        emojiView.layer.masksToBounds = true
        emojiView.backgroundColor = .clear
        emojiView.font = ConstantsCell.font
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        
        return emojiView
    }()
    
    private var contentColorView: UIView = {
        let contentColorView = UIView()
        contentColorView.layer.masksToBounds = true
        contentColorView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentColorView
    }()
    
    private var colorView: UIView = {
        let colorView = UIView()
        colorView.backgroundColor = .clear
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = ConstantsCell.cornerRadius
        
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
        contentColorView.layer.cornerRadius = flag ? ConstantsCell.cornerRadius : 0
        contentColorView.layer.borderWidth = flag ? ConstantsCell.borderWidth : 0
        contentColorView.layer.masksToBounds = flag
        contentColorView.layer.borderColor = color.withAlphaComponent(ConstantsCell.alfaComponent).cgColor
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
