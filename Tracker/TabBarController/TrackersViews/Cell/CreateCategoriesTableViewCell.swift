//
//  CreateCategoriesTableViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit

//MARK: - CreateCategoriesTableViewCell
final class CreateCategoriesTableViewCell: UITableViewCell {    
    private struct ConstantsGreateCell {
        static let iconButton = "IconButtonCell"
        static let nameImageSelected = "selected"
        static let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    private lazy var nameCategoriLableView: UILabel = {
        let nameCategoriLableView = UILabel()
        nameCategoriLableView.font = ConstantsGreateCell.lableFont
        nameCategoriLableView.textColor = .blackDay
        
        return nameCategoriLableView
    }()
    
    private lazy var selectedImage: UIImageView = {
        let selectedImage = UIImageView()
        let image = UIImage(named: ConstantsGreateCell.nameImageSelected)
        selectedImage.image = image
        selectedImage.backgroundColor = .clear
        selectedImage.isHidden = true
        
        return selectedImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.masksToBounds = true
        setupLable()
        setupSelectedImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.cornerRadius = 0
    }
}

extension CreateCategoriesTableViewCell {
    //MARK: - Config
    func config(model: CreateCategoryCellModel) {
        nameCategoriLableView.text = model.text
        backgroundColor = model.color
    }
    
    func showSelectedImage(flag: Bool) {
        selectedImage.isHidden = flag
    }
    
    func setupCornerRadius(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
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
