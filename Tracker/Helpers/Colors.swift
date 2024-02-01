//
//  Colors.swift
//  Tracker
//
//  Created by Григорий Машук on 21.12.23.
//

import UIKit

final class Colors {
    lazy var viewBackground = UIColor.systemBackground
    
    lazy var buttonDisabledColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.blackDay
        } else {
            return UIColor.whiteDay
        }
    }
    
    lazy var buttonEventColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.blackDay
        } else {
            return UIColor.whiteDay
        }
    }
    
    lazy var whiteBlackItemColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    lazy var placeholder = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.grayDay
        } else {
            return UIColor.placeholder
        }
    }
}
