//
//  GreateTrackersViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 30.09.23.
//

import UIKit



//MARK: - EventSelectionViewControllerDelegate
protocol EventSelectionViewControllerDelegate: AnyObject {
    func eventSelectionViewController(vc: UIViewController, categories: [TrackerCategory])
    func eventSelectionViewControllerDidCancel(_ vc: EventSelectionViewController)
}

//MARK: - EventSelectionViewController
final class EventSelectionViewController: UIViewController {
    private struct ConstantsEventVc {
        static let texGreatetLabelName = "Создание трекера"
        static let textFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let cornerRadius = CGFloat(16)
        static let lableGreateImage = UIColor(named: "blackDay")
    }
    
    weak var delegate: EventSelectionViewControllerDelegate?
    
    private lazy var labelGreate: UILabel = {
        let label = UILabel()
        label.text = ConstantsEventVc.texGreatetLabelName
        label.font = ConstantsEventVc.textFont
        label.backgroundColor = .clear
        label.textColor = ConstantsEventVc.lableGreateImage
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = setupButton(text: .habit, font: ConstantsEventVc.textFont, cornerRadius: ConstantsEventVc.cornerRadius)
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        
        return habitButton
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let irregularEventButton = setupButton(text: .irregularEvent, font: ConstantsEventVc.textFont, cornerRadius: ConstantsEventVc.cornerRadius)
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLableGreate()
        setupStackView()
    }
}

private extension EventSelectionViewController {
    //MARK: - Обработка событий
    @objc
    func didTapHabitButton() {
        let greateVC = greateTrackerVC()
        greateVC.reverseIsSchedul()
        present(greateVC, animated: true)
    }
    
    @objc
    func didTapIrregularEventButton() {
        let greateVC = greateTrackerVC()
        present(greateVC, animated: true)
    }
    
    func greateTrackerVC() -> GreateTrackerViewController {
        let greateVC = GreateTrackerViewController()
        greateVC.delegate = self
        greateVC.modalPresentationStyle = .formSheet
        return greateVC
    }
    
    //MARK: - SetupUI
    func setupButton(text: NameEvent, font: UIFont, cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text.name, for: .normal)
        button.titleLabel?.textColor = UIColor.whiteDay
        button.backgroundColor = UIColor.blackDay
        button.titleLabel?.font = font
        button.layer.cornerRadius = cornerRadius ?? CGFloat(0)
        button.layer.masksToBounds = cornerRadius == nil ? false : true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func setupLableGreate() {
        view.addSubview(labelGreate)
        
        NSLayoutConstraint.activate([
            labelGreate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelGreate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelGreate.heightAnchor.constraint(equalToConstant: labelGreate.font.pointSize)
        ])
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        [habitButton, irregularEventButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}

//MARK: - GreateTrackerViewControllerDelegate
extension EventSelectionViewController: GreateTrackerViewControllerDelegate {
    func greateTrackerViewController(vc: UIViewController, categories: [TrackerCategory]) {
        delegate?.eventSelectionViewController(vc: self, categories: categories)
    }
    
    func greateTrackerViewControllerDidCancel(_ vc: GreateTrackerViewController) {
        vc.dismiss(animated: false)
        delegate?.eventSelectionViewControllerDidCancel(self)
    }
}
