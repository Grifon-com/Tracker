//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    var emojiLable: UILabel = {
        let emojiLable = UILabel()
        emojiLable.font = UIFont.boldSystemFont(ofSize: 32)
        emojiLable.backgroundColor = .clear
        emojiLable.translatesAutoresizingMaskIntoConstraints = false
        
        return emojiLable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmojiLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiCollectionViewCell {
    private func setupEmojiLable() {
        addSubview(emojiLable)
        
        NSLayoutConstraint.activate([
            emojiLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLable.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
