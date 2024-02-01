//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 30.10.23.
//

import UIKit

//MARK: - OnboardingPageViewController
final class OnboardingPageViewController: UIPageViewController {
    private struct ConstantsOnboarding {
        static let imageNameTwoVC = "twoPage"
        static let numberOfPages = 2
        static let currentPage = 0
        static let pageIndicatorTintColor = UIColor.blackDay.withAlphaComponent(0.3)
    }
    
    private var currentIndex: Int = 1
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = ConstantsOnboarding.numberOfPages
        pageControl.currentPage = ConstantsOnboarding.currentPage
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = ConstantsOnboarding.pageIndicatorTintColor
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
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
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -134)
        ])
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let twoViewControllers = OnboardingViewController()
        let onboardingModelTwoVC = Onboarding(imageName: ConstantsOnboarding.imageNameTwoVC,
                                              textLable: Translate.textLableTwoVC)
        twoViewControllers.config(model: onboardingModelTwoVC)
        if currentIndex == ConstantsOnboarding.numberOfPages {
            return nil
        }
        currentIndex += 1
        
        return twoViewControllers
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        pageControl.currentPage = pageControl.currentPage == 1 ? 0 : 1
    }
}
