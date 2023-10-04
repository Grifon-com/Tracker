//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        return colorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorCollectionViewCell {
    private func setupColorView() {
        addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
