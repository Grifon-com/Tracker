//
//  GreateTrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 3.10.23.
//

import UIKit

fileprivate let newHabit = "Новая привычка"
fileprivate let newIrregular = "Новое нерегулярное событие"
fileprivate let placeholderTextField = "Введите название трекера"
fileprivate let textCancelButton = "Отменить"
fileprivate let textGreateButton = "Создать"
fileprivate let characterLimit = "Ограничение 38 символов"
fileprivate let everyDay = "Каждый день"
fileprivate let emptyString = ""

fileprivate let restrictionsTextField = 38
fileprivate let numberOfLinesRestrictionsTextField = 1
    
fileprivate let textFont = UIFont.systemFont(ofSize: 16, weight: .medium)
fileprivate let greateNameTextFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
fileprivate let stackSpacing = CGFloat(10)
fileprivate let spacingVerticalStack = CGFloat(24)
fileprivate let leftIndentTextField = CGFloat(12)
    
fileprivate let cornerRadius = CGFloat(16)
fileprivate let borderWidthButton = CGFloat(1)

//MARK: - GreateTrackerViewControllerDelegate
protocol GreateTrackerViewControllerDelegate: AnyObject {
    func greateTrackerViewController(vc: UIViewController, categories: [TrackerCategory])
    func greateTrackerViewControllerDidCancel(_ vc: GreateTrackerViewController)
}

//MARK: - GreateTrackerViewController
final class GreateTrackerViewController: UIViewController, UITableViewDelegate {
    private let recordManager: RecordManagerProtocol = RecordManagerStab()
    weak var delegate: GreateTrackerViewControllerDelegate?
    
    private var isSchedul: Bool = true
    private var listSettings: [ChoiceParametrs] { isSchedul ? [.category] : [.category, .schedule] }
    
    //данные для создания трекера
    private var schedule: [WeekDay] = [] {
        didSet { checkingForEmptiness() }
    }
    private let color: [UIColor] = [.colorSelection14]
    private var nameNewCategori: String = "Как сдать 14 спринт"
    //TODO: -
    private var nameTracker: String = ""
    
    private lazy var newHabitLabel: UILabel = {
        let newHabitLabel = UILabel()
        newHabitLabel.text = isSchedul ? newIrregular : newHabit
        newHabitLabel.textColor = .blackDay
        newHabitLabel.font = textFont
        newHabitLabel.textAlignment = .center
        newHabitLabel.backgroundColor = .clear
        
        return newHabitLabel
    }()
    
    private lazy var greateNameTextField: UITextField = {
        let greateNameTextField = UITextField()
        greateNameTextField.placeholder = placeholderTextField
        greateNameTextField.font = greateNameTextFieldFont
        greateNameTextField.indent(size: leftIndentTextField)
        greateNameTextField.backgroundColor = .backgroundNight
        greateNameTextField.layer.cornerRadius = cornerRadius
        greateNameTextField.layer.masksToBounds = true
        greateNameTextField.clearButtonMode = .whileEditing
        greateNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        greateNameTextField.delegate = self
        
        return greateNameTextField
    }()
    
    private lazy var restrictionsView: UILabel = {
        let restrictionsView = UILabel()
        restrictionsView.backgroundColor = .clear
        restrictionsView.font = greateNameTextFieldFont
        restrictionsView.text = characterLimit
        restrictionsView.textColor = .redDay
        restrictionsView.numberOfLines = numberOfLinesRestrictionsTextField
        restrictionsView.textAlignment = .center
        restrictionsView.isHidden = true
        
        return restrictionsView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = stackSpacing
        
        return stackView
    }()
    
    private lazy var selectionTableView: UITableView = {
        let selectionTableView = UITableView()
        selectionTableView.dataSource = self
        selectionTableView.allowsSelection = false
        selectionTableView.backgroundColor = .clear
        selectionTableView.isScrollEnabled = false
        selectionTableView.separatorStyle = isSchedul ? .none : .singleLine
        selectionTableView.register(GreateTrackerTableViewCell.self, forCellReuseIdentifier: "\(GreateTrackerTableViewCell.self)")
        
        return selectionTableView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "\(EmojiCollectionViewCell.self)")
        emojiCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        emojiCollectionView.backgroundColor = .blueDay
        
        return emojiCollectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "\(ColorCollectionViewCell.self)")
        emojiCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        colorCollectionView.backgroundColor = .blueDay
        
        return colorCollectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.cornerRadius = cornerRadius
        cancelButton.layer.borderWidth = borderWidthButton
        cancelButton.layer.borderColor = UIColor.redDay.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle(textCancelButton , for: .normal)
        cancelButton.setTitleColor(.redDay, for: .normal)
        cancelButton.titleLabel?.font = textFont
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .allTouchEvents)
        
        return cancelButton
    }()
    
    private lazy var greateButton: UIButton = {
        let greateButton = UIButton()
        greateButton.layer.cornerRadius = cornerRadius
        greateButton.layer.masksToBounds = true
        greateButton.backgroundColor = .grayDay
        greateButton.setTitle(textGreateButton, for: .normal)
        greateButton.titleLabel?.textColor = .redDay
        greateButton.titleLabel?.font = textFont
        greateButton.isEnabled = false
        greateButton.addTarget(self, action: #selector(didTapGreateButton) , for: .allTouchEvents)
        
        return greateButton
    }()
    
    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = stackSpacing
        buttonStack.distribution = .fillEqually
        
        return buttonStack
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIElement()
        schedule = isSchedul ? recordManager.weekDay : []
    }
}

extension GreateTrackerViewController {
    //MARK: - Обработка событий    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }

    @objc
    private func didTapGreateButton() {
        let categories = greateNewCategori(categories: recordManager.categories, nameCategori: nameNewCategori)
        delegate?.greateTrackerViewController(vc: self, categories: categories)
        delegate?.greateTrackerViewControllerDidCancel(self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > restrictionsTextField {
            restrictionsView.isHidden = false
            textField.text = nameTracker
            return
        }
        nameTracker = text
        checkingForEmptiness()
    }
    
    //MARK: - Логика
    //метод активации/деактивации greateButton
    private func isActivGreateButton(flag: Bool) {
        greateButton.isEnabled = flag
        greateButton.backgroundColor = flag ? .blackDay : .grayDay
    }
    
    //метод ссоздания текста для вторичной строки в ячейке "shedul"
    private func jonedSchedule(schedule: [WeekDay]) -> String {
        var stringListDay: String
        if schedule.count == 7 {
            stringListDay = everyDay
            return stringListDay
        }
        let listDay = schedule.map { $0.briefWordDay }
        stringListDay = listDay.joined(separator: ",")
        
        return stringListDay
    }
    
    //метод создания трекера
    private func greateNewTracker() -> Tracker {
        let tracker = Tracker(name: nameTracker, color: .colorSelection12, emoji: "🍏", schedule: schedule)
        return tracker
    }
    
    //медод создания нового массива категорий c новым созданным трекером
    private func greateNewCategori(categories: [TrackerCategory], nameCategori: String) -> [TrackerCategory] {
        var newCategories: [TrackerCategory] = []
        let tracker = greateNewTracker()
        var trackers: [Tracker] = []
        categories.forEach { oldCategori in
            oldCategori.arrayTrackers.forEach { tracker in
                trackers.append(tracker)
            }
            if nameCategori == oldCategori.nameCategori {
                trackers.append(tracker)
                let ctegori = TrackerCategory(nameCategori: oldCategori.nameCategori, arrayTrackers: trackers)
                newCategories.append(ctegori)
            } else {
                let newCategori = TrackerCategory(nameCategori: nameCategori, arrayTrackers: [tracker])
                newCategories.append(newCategori)
            }
        }
        return newCategories
    }
    
    //метод проверки свойств на пустоту
    private func checkingForEmptiness() {
        let flag = !schedule.isEmpty && !nameTracker.isEmpty && !color.isEmpty ? true : false
        isActivGreateButton(flag: flag)
    }
    
    //метод изменения свойства isSchedul
    func reverseIsSchedul() {
        isSchedul = isSchedul ? !isSchedul : isSchedul
    }
    
    //MARK: - SetupUI
    func setupUIElement() {
        setupButtonStack()
        setupContentView()
        setupNewHabitLabel()
        setupScrollView()
        setupStackView()
        setupSelectionTableView()
    }
    
    func setupNewHabitLabel() {
        view.addSubview(newHabitLabel)
        newHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newHabitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupButtonStack() {
        view.addSubview(buttonStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [cancelButton, greateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func setupSelectionTableView() {
        NSLayoutConstraint.activate([
            selectionTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 34),
            selectionTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectionTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: newHabitLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor)
        ])
    }
    
    func setupStackView() {
        [greateNameTextField, restrictionsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            greateNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        [stackView, selectionTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

//MARK: - UITableViewDataSource
extension GreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreateTrackerTableViewCell.self)") as? GreateTrackerTableViewCell else { return UITableViewCell() }
        let secondaryText = jonedSchedule(schedule: schedule)
        cell.delegate = self
        switch listSettings[indexPath.row] {
        case .category:
            cell.configCell(choice: listSettings[indexPath.row])
        case .schedule:
            cell.configCell(choice: listSettings[indexPath.row])
            cell.configSecondaryLableShedule(secondaryText: secondaryText)
        }
        return cell
    }
}

//MARK: - UITextFieldDelegate
extension GreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: - GreateTrackerTableViewCellDelegate
extension GreateTrackerViewController: GreateTrackerTableViewCellDelegate {
    func trackerTableViewCellDidTapChoiceButton(cell: UITableViewCell) {
        guard let greateTrackerTableViewCell = cell as? GreateTrackerTableViewCell,
              let indexPath = selectionTableView.indexPath(for: greateTrackerTableViewCell)
        else { return }
        switch listSettings[indexPath.row] {
        case .category:
        let greateCategoriViewController = GreateCategoriesViewController()
            greateCategoriViewController.modalPresentationStyle = .formSheet
            greateCategoriViewController.delegate = self
            present(greateCategoriViewController, animated: true)
        case .schedule:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.modalPresentationStyle = .formSheet
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        }
    }
}

//MARK: - ScheduleViewControllerDelegate
extension GreateTrackerViewController: ScheduleViewControllerDelegate {
    func daysOfWeek(viewController: UIViewController, listDays: [WeekDay]) {
        guard let _ = viewController as? ScheduleViewController else { return }
        schedule = listDays
        selectionTableView.reloadData()
    }
}

//MARK: - GreateCategoriesViewControllerDelegate
extension GreateTrackerViewController: GreateCategoriesViewControllerDelegate {
    func greateCategoriesViewController(vc: UIViewController, nameCategori: String) {
        //TODO: - Sprint_15
        nameNewCategori = nameCategori
    }
    
    func greateCategoriesViewControllerDidCancel(vc: GreateCategoriesViewController) {
        vc.dismiss(animated: true)
    }
}
