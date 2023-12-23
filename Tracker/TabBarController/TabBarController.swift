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
    
    private let colors = Colors()
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *),
             // Проверяем только изменение цветовой схемы
             traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
             if traitCollection.userInterfaceStyle == .dark {
                 tabBar.layer.borderColor = UIColor.black.cgColor
             } else {
                 tabBar.layer.borderColor = UIColor.grayDay.cgColor
             }
         }
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
        tabBar.clipsToBounds = true
    }
}
