//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 30.10.23.
//

import UIKit

//MARK: - OnboardingPageViewController
final class OnboardingPageViewController: UIPageViewController {
    private struct ConstantsOnboardingPageViewController {
        static let textLableOneVC = "Отслеживайте только то, что хотите"
        static let textLableTwoVC = "Даже если это не литры воды и йога"
        
        static let imageNameOneVC = "onePage"
        static let imageNameTwoVC = "twoPage"
    }
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .blackDay.withAlphaComponent(0.3)
        
        return pageControl
    }()
    
    private let pages: [OnboardingViewController] = {
        let tabBarViewController = TabBarController()
        
        let oneViewController = OnboardingViewController()
        let onboardingModelOneVC = Onboarding(imageName: ConstantsOnboardingPageViewController.imageNameOneVC,
                                              textLable: ConstantsOnboardingPageViewController.textLableOneVC)
        oneViewController.config(model: onboardingModelOneVC)
        
        let twoViewController = OnboardingViewController()
        let onboardingModelTwoVC = Onboarding(imageName: ConstantsOnboardingPageViewController.imageNameTwoVC,
                                              textLable: ConstantsOnboardingPageViewController.textLableTwoVC)
        twoViewController.config(model: onboardingModelTwoVC)
        
        return [oneViewController, twoViewController]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        setupPageControl()
    }
}

private extension OnboardingPageViewController {
    func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
    }
    
    func showTabBarViewController() {
        let tabBarViewController = TabBarController()
        present(tabBarViewController, animated: true)
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let onboardingViewController = viewController as? OnboardingViewController,
              let viewControllerIndex = pages.firstIndex(of: onboardingViewController)
        else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let onboardingViewController = viewController as? OnboardingViewController,
              let viewControllerIndex = pages.firstIndex(of: onboardingViewController)
        else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? OnboardingViewController,
              let currentIndex = pages.firstIndex(of: currentViewController) else { return }
        pageControl.currentPage = currentIndex
    }
}
