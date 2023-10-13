//
//  CategoriesTableViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit

fileprivate let iconButton = "IconButtonCell"
fileprivate let nameImageSelected = "selected"
fileprivate let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
fileprivate let cornerRadiusViewCell = CGFloat(16)

//MARK: - GreateCategoriesTableViewCell
final class GreateCategoriesTableViewCell: UITableViewCell {
    private lazy var nameCategoriLableView: UILabel = {
        let nameCategoriLableView = UILabel()
        nameCategoriLableView.font = lableFont
        nameCategoriLableView.textColor = .blackDay
        
        return nameCategoriLableView
    }()
    
    private lazy var selectedImage: UIImageView = {
        let selectedImage = UIImageView()
        let image = UIImage(named: nameImageSelected)
        selectedImage.image = image
        selectedImage.backgroundColor = .clear
        selectedImage.isHidden = false
        
        return selectedImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundNight
        layer.cornerRadius = cornerRadiusViewCell
        layer.masksToBounds = true
        setupLable()
        setupSelectedImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GreateCategoriesTableViewCell {
    //MARK: - Configuration
    func config(text: String) {
        nameCategoriLableView.text = text
    }
    
    func showSelectedImage(flag: Bool) {
        selectedImage.isHidden = flag
    }
    
    //MARK: - SetupUI
    private func setupLable() {
        nameCategoriLableView.translatesAutoresizingMaskIntoConstraints = false
        nameCategoriLableView.backgroundColor = .clear
        contentView.addSubview(nameCategoriLableView)
        
        NSLayoutConstraint.activate([
            nameCategoriLableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameCategoriLableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupSelectedImage() {
        contentView.addSubview(selectedImage)
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
