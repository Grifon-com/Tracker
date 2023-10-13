//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 4.10.23.
//

import UIKit

fileprivate let scheduleLableText = "Расписание"
fileprivate let doneButtonText = "Готово"
fileprivate let spacingVerticalStack = CGFloat(20)
fileprivate let cornerRadiusUIElement = CGFloat(16)
fileprivate let heightCell = CGFloat(75)
fileprivate let separatorInsetTableView = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
fileprivate let scheduleLableFont = UIFont.systemFont(ofSize: 16, weight: .medium)

protocol ScheduleViewControllerDelegate: AnyObject {
    func daysOfWeek(viewController: UIViewController, listDays:[WeekDay])
}

//MARK: - ScheduleViewController
final class ScheduleViewController: UIViewController {
    private let weekDay: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    weak var delegate: ScheduleViewControllerDelegate?
    private var listWeekDay: [WeekDay] = []
    
    private lazy var scheduleLable: UILabel = {
        let scheduleLable = UILabel()
        scheduleLable.text = scheduleLableText
        scheduleLable.font = scheduleLableFont
        scheduleLable.textColor = .blackDay
        scheduleLable.backgroundColor = .clear
        scheduleLable.textAlignment = .center
        
        return scheduleLable
    }()
    
    private lazy var weekDayTableView: UITableView = {
        let weekDayTableView = UITableView()
        weekDayTableView.dataSource = self
        weekDayTableView.delegate = self
        weekDayTableView.backgroundColor = .clear
        weekDayTableView.separatorInset = separatorInsetTableView
        weekDayTableView.register(WeekDayTableViewCell.self, forCellReuseIdentifier: "\(WeekDayTableViewCell.self)")
        
        return weekDayTableView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .allTouchEvents)
        doneButton.layer.cornerRadius = cornerRadiusUIElement
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = .blackDay
        doneButton.setTitle(doneButtonText, for: .normal)
        doneButton.titleLabel?.textColor = .whiteDay
        
        return doneButton
    }()
    
    private var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.backgroundColor = .clear
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupContentSteck()
    }
}


private extension ScheduleViewController {
    //MARK: - Обработка событий
    @objc
    func didTapDoneButton() {
        guard let delegate else { return }
        //передаем список дней для поля "schedule" при создании трекера
        delegate.daysOfWeek(viewController: self, listDays: listWeekDay)
        dismiss(animated: true)
    }
    
    //MARK: - Логика
    //метод обновления списка listWeekDay в зависимости от положения переключателя в яцейке weekDayTableView
    func updateListWeekDay(flag: Bool, day: WeekDay) {
        if flag {
            var listDay: [WeekDay] = []
            listDay = listWeekDay
            listDay.append(day)
            listWeekDay = listDay
        } else {
            var listDay: [WeekDay] = []
            listDay = listWeekDay
            guard let index = listDay.firstIndex(of: day) else { return }
            listDay.remove(at: index)
            listWeekDay = listDay
        }
    }
    
    //MARK: - SetupUI
    func setupContentSteck() {
        view.addSubview(contentStackView)
        [scheduleLable, weekDayTableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.addArrangedSubview($0)
        }
        contentStackView.setCustomSpacing(38, after: scheduleLable)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(WeekDayTableViewCell.self)") as? WeekDayTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.config(nameDay: weekDay[indexPath.row])
        
        if weekDay[indexPath.row] == weekDay.first {
            cell.setupCornerRadius(cornerRadius: cornerRadiusUIElement,
                                   maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            
        }
        if weekDay[indexPath.row] == weekDay.last {
            cell.setupCornerRadius(cornerRadius: cornerRadiusUIElement,
                                   maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightCell
    }
}

//MARK: - WeekDayTableViewCellDelegate
extension ScheduleViewController: WeekDayTableViewCellDelegate {
    func addDayInListkDay(cell: UITableViewCell, flag: Bool) {
        guard let cell = cell as? WeekDayTableViewCell,
              let indexPath = weekDayTableView.indexPath(for: cell)
        else { return }
        let day = weekDay[indexPath.row]
        updateListWeekDay(flag: flag, day: day)
        //TODO: - Sprin_15
    }
}

