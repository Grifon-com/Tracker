//
//  GreateTrackersViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 30.09.23.
//

import UIKit

private enum Constants {
    static let texGreatetLabelName = "Создание трекера"    
    static let labeFontlSize = CGFloat(16)
    static let labelCornerRadius = CGFloat(16)
    
    enum NameEvent {
        case habit
        case irregularEvent
        
        var name: String {
            switch self {
            case .habit:
                return "Привычка"
            case .irregularEvent:
                return "Нерегулярное событие"
            }
        }
    }
}

final class EventSelectionViewController: UIViewController {
    private lazy var labelGreate: UILabel = {
        let label = UILabel()
        label.text = Constants.texGreatetLabelName
        label.font = UIFont.systemFont(ofSize: Constants.labeFontlSize, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = UIColor(named: "Black [day]")
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
        let habitButton = setupLable(text: .habit, fontSize: Constants.labeFontlSize, cornerRadius: Constants.labelCornerRadius)
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .allTouchEvents)
        
        return habitButton
    }()
    
    private lazy var irregularEventButton: UIButton = {
        setupLable(text: .irregularEvent, fontSize: Constants.labeFontlSize, cornerRadius: Constants.labelCornerRadius)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLableGreate()
        setupStackView()
    }
}

private extension EventSelectionViewController {
    @objc
    func didTapHabitButton() {
        let greateVC = GreateTrackerViewController()
        greateVC.modalPresentationStyle = .formSheet
        present(greateVC, animated: true)
    }
    
    func setupLable(text: Constants.NameEvent, fontSize: CGFloat, cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text.name, for: .normal)
        button.titleLabel?.textColor = UIColor.whiteDay
        button.backgroundColor = UIColor.blackDay
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
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

