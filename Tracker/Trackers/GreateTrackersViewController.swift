//
//  GreateTrackersViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 30.09.23.
//

import UIKit

private enum Constants {
    static let texGreatetLabelName = "Создание трекера"
    static let textHabit = "Привычка"
    static let textIrregularEvent = "Нерегулярное событие"
    
    static let labeFontlSize = CGFloat(16)
    static let labelCornerRadius = CGFloat(16)
}

final class GreateTrackersViewController: UIViewController {
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
    
    private lazy var labelHabit: UILabel = {
        setupLable(text: Constants.textHabit, fontSize: Constants.labeFontlSize, cornerRadius: Constants.labelCornerRadius)
    }()
    
    private lazy var labelIrregularEvent: UILabel = {
        setupLable(text: Constants.textIrregularEvent, fontSize: Constants.labeFontlSize, cornerRadius: Constants.labelCornerRadius)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLableGreate()
        setupStackView()
    }
}

private extension GreateTrackersViewController {
    func setupLable(text: String, fontSize: CGFloat, cornerRadius: CGFloat? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = UIColor.whiteDay
        label.backgroundColor = UIColor.blackDay
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.layer.cornerRadius = cornerRadius ?? CGFloat(0)
        label.layer.masksToBounds = cornerRadius == nil ? false : true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        [labelHabit, labelIrregularEvent].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            labelHabit.heightAnchor.constraint(equalToConstant: 60),
            labelIrregularEvent.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    
}

