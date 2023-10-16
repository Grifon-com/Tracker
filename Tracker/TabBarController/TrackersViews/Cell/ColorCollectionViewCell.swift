//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

//MARK: - ColorCollectionViewCell
final class ColorCollectionViewCell: UICollectionViewCell {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorCollectionViewCell {
    //MARK: - Config
    
    
    //MARK: - SetupUI
    private func setupColorView() {
       
    }
}
