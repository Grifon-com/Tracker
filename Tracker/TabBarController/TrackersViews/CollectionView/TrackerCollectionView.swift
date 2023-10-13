//
//  TrackerCollectionView.swift
//  Tracker
//
//  Created by Григорий Машук on 3.10.23.
//

import UIKit

//MARK: - TrackerCollectionView
final class TrackerCollectionView: UICollectionView {
    var params: GeometricParams
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, params: GeometricParams) {
        self.params = params
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

