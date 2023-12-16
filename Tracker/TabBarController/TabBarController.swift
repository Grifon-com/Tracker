//
//  File.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

//MARK: - TabBarController
final class TabBarController: UITabBarController {
    private struct ConstantsTabBar {
        static let tabBarImageTrecker =  "tabBarTracker"
        static let tabBarImageStatistic = "tabBarStatistic"
        
        static let tabBarTitleTrecker = NSLocalizedString("trackers", comment: "")
        static let tabBarTitleStatistic = NSLocalizedString("statistics", comment: "")
        
        static let insertImage = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        let trackerViewController = TrackersViewController(viewModel: TrackerViewModel())
        let statisticViewController = StatisticViewController()
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        
        viewControllers = [
            generateViewController(vc: trackerNavigationController,
                                   imageName: ConstantsTabBar.tabBarImageTrecker,
                                   title: ConstantsTabBar.tabBarTitleTrecker,
                                   insert: ConstantsTabBar.insertImage),
            
            generateViewController(vc: statisticNavigationController,
                                   imageName: ConstantsTabBar.tabBarImageStatistic,
                                   title: ConstantsTabBar.tabBarTitleStatistic,
                                   insert: ConstantsTabBar.insertImage)
        ]
    }
}

//MARK: - Setup
private extension TabBarController {
    func generateViewController(vc: UIViewController,
                                imageName: String,
                                title: String,
                                insert: UIEdgeInsets ) -> UIViewController
    {
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.title = title
        vc.tabBarItem.imageInsets = insert
        
        return vc
    }
    
    func setupTabBar() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.grayDay.cgColor
        tabBar.clipsToBounds = true
    }
}
