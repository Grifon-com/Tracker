//
//  File.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

//MARK: - TabBarController
final class TabBarController: UITabBarController {
    private enum Constants {
        static let tabBarImageTrecker =  "tabBarTracker"
        static let tabBarImageStatistic = "tabBarStatistic"
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        
        viewControllers = [
            generateViewController(vc: trackerNavigationController, imageName: Constants.tabBarImageTrecker),
            generateViewController(vc: statisticNavigationController, imageName: Constants.tabBarImageStatistic)
        ]
    }
}

//MARK: - TabBarController
private extension TabBarController {
    func generateViewController(vc: UIViewController, imageName: String) -> UIViewController {
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        return vc
    }
    
    func setupTabBar() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.grayDay.cgColor
        tabBar.clipsToBounds = true
    }
}
