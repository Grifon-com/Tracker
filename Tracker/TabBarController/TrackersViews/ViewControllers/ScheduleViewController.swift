//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

fileprivate let scheduleLableText = "Расписание"
fileprivate let readyButtonText = "Готово"
fileprivate let spacingVerticalStack = CGFloat(20)
fileprivate let cornerRadiusReadyButton = CGFloat(16)
fileprivate let scheduleLableFont = UIFont.systemFont(ofSize: 16, weight: .medium)

final class ScheduleViewController: UIViewController {
    private let weekDay: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private lazy var scheduleLable: UILabel = {
        let scheduleLable = UILabel()
        scheduleLable.text = scheduleLableText
        scheduleLable.font = scheduleLableFont
        scheduleLable.textColor = .blueDay
        scheduleLable.backgroundColor = .clear
        
        return scheduleLable
    }()
    
    private lazy var weekDayTableView: UITableView = {
        let weekDayTableView = UITableView()
        weekDayTableView.dataSource = self
        weekDayTableView.backgroundColor = .clear
        
        return weekDayTableView
    }()
    
    private lazy var readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.layer.cornerRadius = cornerRadiusReadyButton
        readyButton.layer.masksToBounds = true
        readyButton.backgroundColor = .blackDay
        readyButton.setTitle(readyButtonText, for: .normal)
        readyButton.titleLabel?.textColor = .whiteDay
        
        return readyButton
    }()
    
    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = spacingVerticalStack
        verticalStack.backgroundColor = .clear
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ScheduleViewController {
    func setupVerticalStack() {
        view.addSubview(verticalStack)
        [scheduleLable, weekDayTableView, readyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
 
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}
