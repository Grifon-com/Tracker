//
//  HeaderReusableView.swift
//  Tracker
//
//  Created by Григорий Машук on 1.10.23.
//

import UIKit

//MARK: - HeaderReusableView
final class HeaderReusableView: UICollectionReusableView {
    private struct ConstantsHeader {
        static let fontLable = UIFont.boldSystemFont(ofSize: 19)
        static let numberOfLinesLable = 1
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = ConstantsHeader.fontLable
        label.textColor = .blackDay
        label.numberOfLines = ConstantsHeader.numberOfLinesLable
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetupUI
private extension HeaderReusableView {
    func setupLable() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
