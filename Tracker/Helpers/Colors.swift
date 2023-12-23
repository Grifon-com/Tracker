//
//  Colors.swift
//  Tracker
//
//  Created by Григорий Машук on 21.12.23.
//

import UIKit

final class Colors {
    let viewBackground = UIColor.systemBackground
    
    let buttonDisabledColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.lightGray
        } else {
            return UIColor(red: 0.8, green: 0.5, blue: 0.8, alpha: 1)
        }
    }
    
    let whiteBlackItemColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}
