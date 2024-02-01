//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Григорий Машук on 28.09.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    @UserDefaultsBacked<Bool>(key: UserDefaultKeys.isOnboarding.rawValue) private var isOnboarding
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabBarViewController = TabBarController()
        var rootViewController: UIViewController = tabBarViewController
        if isOnboarding == nil {
            let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll,
                                                            navigationOrientation: .horizontal)
            let oneWisibleVc = OnboardingViewController()
            let model = Onboarding(imageName: "onePage", textLable: Translate.textLable)
            oneWisibleVc.config(model: model)
            onboardingVC.setViewControllers([oneWisibleVc], direction: .forward, animated: true)
            rootViewController = onboardingVC
        }
        window?.makeKeyAndVisible()
        window?.rootViewController = rootViewController
        isOnboarding = true
    }
}

