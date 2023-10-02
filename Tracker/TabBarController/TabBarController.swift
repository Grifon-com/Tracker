//
//  File.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

final class TabBarController: UITabBarController {
    private enum Constants {
        static let tabBarImageTrecker =  "tabBarTracker"
        static let tabBarImageStatistic = "tabBarStatistic"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        
        viewControllers = [
            generateViewController(vc: trackerViewController, imageName: Constants.tabBarImageTrecker),
            generateViewController(vc: statisticViewController, imageName: Constants.tabBarImageStatistic)
        ]
    }
}

private extension TabBarController {
    func generateViewController(vc: UIViewController, imageName: String) -> UIViewController {
        vc.tabBarItem.image = UIImage(named: imageName)
        return vc
    }
}
