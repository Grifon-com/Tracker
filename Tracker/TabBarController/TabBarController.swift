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
    
    func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .clear
        self.tabBar.standardAppearance = appearance
    }
}



//final class TabBarViewController: UITabBarController {
//    private struct Constanstants {
//        static let tabBarImageList = "tab_editorial_active"
//        static let tabBarImageProfile = "tab_profile_active"
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .clear
//
//        let appearance = UITabBarAppearance()
//        UITabBar.appearance().standardAppearance = appearance
//        appearance.backgroundColor = .ypBlack
//
//        view.backgroundColor = .ypBlack
//        let tabBar = UITabBar.self
//        tabBar.appearance().tintColor = .ypWhite
//
//        let imagesListViewController = ImagesListViewController()
//        let imagesListService = ImagesListService.shared
//        let imagesListHelper = ImagesListHelper()
//        let imagesListViewControllerPresenter = ImagesListViewControllerPresenter(imagesListService: imagesListService,
//                                                                                  imagesListHelper: imagesListHelper)
//        imagesListViewControllerPresenter.view = imagesListViewController
//        imagesListViewController.presenter = imagesListViewControllerPresenter
//
//        let profileViewController = ProfileViewController()
//        let tokenStorage = OAuth2TokenKeychainStorage()
//        let cleanManager = CleanManager(tokenStorage: tokenStorage)
//        let profileService = ProfileService.shared
//        let profileViewControllerPresenter = ProfileViewControllerPresenter(cleanmanager: cleanManager,
//                                                                            profileService: profileService)
//        profileViewControllerPresenter.view = profileViewController
//        profileViewController.presenter = profileViewControllerPresenter
//
//        self.viewControllers = [
//            generateVC(viewController: imagesListViewController,
//                       title: nil,
//                       image: UIImage(named: Constanstants.tabBarImageList)),
//            generateVC(viewController: profileViewController,
//                       title: nil,
//                       image: UIImage(named: Constanstants.tabBarImageProfile))]
//
//    }
//}
//
////MARK: - GenerateVC
//private extension TabBarViewController {
//    func generateVC(viewController: UIViewController, title: String?, image: UIImage?) -> UIViewController {
//        viewController.tabBarItem.title = title
//        viewController.tabBarItem.image = image
//
//        return viewController
//    }
//}

