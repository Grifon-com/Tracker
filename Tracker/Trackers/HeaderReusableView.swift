//
//  HeaderReusableView.swift
//  Tracker
//
//  Created by Марина Машук on 1.10.23.
//

import UIKit

private enum ConstantsReusebleView {
    static let fontLableSize = CGFloat(19)
    static let numberOfLinesLable = 1
}

final class HeaderReusableView: UICollectionReusableView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: ConstantsReusebleView.fontLableSize)
        label.textColor = .blackDay
        label.textAlignment = .left
        label.numberOfLines = ConstantsReusebleView.numberOfLinesLable
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HeaderReusableView {
    func setupLable() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}
