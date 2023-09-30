//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

private enum ConstantsTrackerCell {
    static let cornerRadiusView = CGFloat(16)
    static let fontLabelEmoji = CGFloat(16)
    static let heightLableView = CGFloat(24)
    static let widhtLableView = CGFloat(24)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    private lazy var view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = ConstantsTrackerCell.cornerRadiusView
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var lableEmoji: UILabel = {
        let size = CGSize(width: ConstantsTrackerCell.widhtLableView, height: ConstantsTrackerCell.heightLableView)
        let frame = CGRect(origin: .zero, size: size)
        let lable = UILabel(frame: frame)
        lable.font = UIFont.systemFont(ofSize: ConstantsTrackerCell.fontLabelEmoji, weight: .medium)
        lable.layer.cornerRadius = ConstantsTrackerCell.heightLableView / 2
        lable.layer.masksToBounds = true
        lable.backgroundColor = UIColor.backgroundDay
        //MARK: - Delete
        lable.text = "T"
        
        return lable
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private lazy var lableDayCounter: UILabel = {
        let lable = UILabel()
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
