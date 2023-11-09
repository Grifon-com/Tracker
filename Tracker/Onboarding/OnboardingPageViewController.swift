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
        static let textLableTwoVC = "Даже если это не литры воды и йога"
        static let imageNameTwoVC = "twoPage"
        static let numberOfPages = 2
        static let currentPage = 0
    }
    
    private var currentIndex: Int = 1
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = ConstantsOnboardingPageViewController.numberOfPages
        pageControl.currentPage = ConstantsOnboardingPageViewController.currentPage
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .blackDay.withAlphaComponent(0.3)
        
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
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let twoViewControllers = OnboardingViewController()
        let onboardingModelTwoVC = Onboarding(imageName: ConstantsOnboardingPageViewController.imageNameTwoVC,
                                              textLable: ConstantsOnboardingPageViewController.textLableTwoVC)
        twoViewControllers.config(model: onboardingModelTwoVC)
        if currentIndex == ConstantsOnboardingPageViewController.numberOfPages {
            return nil
        }
        currentIndex += 1
        
        return twoViewControllers
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageControl.currentPage = pageControl.currentPage == 1 ? 0 : 1
    }
}
