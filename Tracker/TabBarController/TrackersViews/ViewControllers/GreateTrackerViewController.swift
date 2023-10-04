//
//  GreateTrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 3.10.23.
//

import UIKit

private enum ConfigurationGreateVC {
    static let newHabitName = "Новая привычка"
    static let placeholderTextField = "Введите название трекера"
    static let textCancelButton = "Отменить"
    static let textGreateButton = "Создать"
    
    static let textButtonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let textNewHabitFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let greateNameTextFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let stackButtonSpacing = CGFloat(10)
    static let spacingVerticalStack = CGFloat(24)
    static let leftIndentTextField = CGFloat(12)
    
    static let cornerRadius = CGFloat(16)
    static let borderWidthButton = CGFloat(1)
}

final class GreateTrackerViewController: UIViewController, UITableViewDelegate {
    
    private let dataSourceTableView: [ChoiceParametrs] = [.category, .schedule]
    
    private lazy var newHabitLabel: UILabel = {
        let newHabitLabel = UILabel()
        newHabitLabel.text = ConfigurationGreateVC.newHabitName
        newHabitLabel.textColor = .blackDay
        newHabitLabel.font = ConfigurationGreateVC.textNewHabitFont
        newHabitLabel.textAlignment = .center
        newHabitLabel.backgroundColor = .clear
        
        return newHabitLabel
    }()
    
    private lazy var greateNameTextField: UITextField = {
        let greateNameTextField = UITextField()
        greateNameTextField.placeholder = ConfigurationGreateVC.placeholderTextField
        greateNameTextField.font = ConfigurationGreateVC.greateNameTextFieldFont
        greateNameTextField.indent(size: ConfigurationGreateVC.leftIndentTextField)
        greateNameTextField.backgroundColor = .backgroundNight
        greateNameTextField.layer.cornerRadius = ConfigurationGreateVC.cornerRadius
        greateNameTextField.layer.masksToBounds = true
        
        return greateNameTextField
    }()
    
    private lazy var selectionTableView: UITableView = {
        let selectionTableView = UITableView()
        selectionTableView.dataSource = self
        selectionTableView.backgroundColor = .clear
        selectionTableView.register(GreateTrackerTableViewCell.self, forCellReuseIdentifier: "\(GreateTrackerTableViewCell.self)")
        
        return selectionTableView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "\(EmojiCollectionViewCell.self)")
        emojiCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        
        return emojiCollectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "\(ColorCollectionViewCell.self)")
        emojiCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        
        return colorCollectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.cornerRadius = ConfigurationGreateVC.cornerRadius
        cancelButton.layer.borderWidth = ConfigurationGreateVC.borderWidthButton
        cancelButton.layer.borderColor = UIColor.redDay.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle(ConfigurationGreateVC.textCancelButton , for: .normal)
        cancelButton.setTitleColor(.redDay, for: .normal)
        cancelButton.titleLabel?.font = ConfigurationGreateVC.textButtonFont
        cancelButton.addTarget(self, action: #selector(didDismiss), for: .allTouchEvents)
        
        return cancelButton
    }()
    
    private lazy var greateButton: UIButton = {
        let greateButton = UIButton()
        greateButton.layer.cornerRadius = ConfigurationGreateVC.cornerRadius
        greateButton.layer.masksToBounds = true
        greateButton.backgroundColor = .grayDay
        greateButton.setTitle(ConfigurationGreateVC.textGreateButton, for: .normal)
        greateButton.titleLabel?.textColor = .redDay
        greateButton.titleLabel?.font = ConfigurationGreateVC.textButtonFont
        
        return greateButton
    }()
    
    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = ConfigurationGreateVC.stackButtonSpacing
        buttonStack.distribution = .fillEqually
        
        return buttonStack
    }()
    
    private lazy var verticalSteck: UIStackView = {
        let verticalSteck = UIStackView()
        verticalSteck.spacing = ConfigurationGreateVC.spacingVerticalStack
        verticalSteck.translatesAutoresizingMaskIntoConstraints = false
        verticalSteck.axis = .vertical
        
        return verticalSteck
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtonStack()
        setupElement()
    }
}

private extension GreateTrackerViewController {
    @objc
    func didDismiss() {
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarVC = TabBarController()
        window.rootViewController = tabBarVC
    }
    
    func setupElement() {
        view.addSubview(verticalSteck)
        [newHabitLabel, greateNameTextField, selectionTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalSteck.addArrangedSubview($0)
        }
        NSLayoutConstraint.activate([
            verticalSteck.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalSteck.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalSteck.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            newHabitLabel.heightAnchor.constraint(equalToConstant: 57),
            greateNameTextField.heightAnchor.constraint(equalToConstant: 75),
            selectionTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupButtonStack() {
        view.addSubview(buttonStack)
        [cancelButton, greateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension GreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourceTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreateTrackerTableViewCell.self)") as? GreateTrackerTableViewCell else { return UITableViewCell() }
        cell.configCell(choice: dataSourceTableView[indexPath.row])

        return cell
    }
}


