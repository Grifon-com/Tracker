//
//  GreateTrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 3.10.23.
//

import UIKit

//MARK: - GreateTrackerViewControllerDelegate
protocol GreateTrackerViewControllerDelegate: AnyObject {
    func greateTrackerViewController(vc: UIViewController, categories: [TrackerCategory])
    func greateTrackerViewControllerDidCancel(_ vc: GreateTrackerViewController)
}

//MARK: - GreateTrackerViewController
final class GreateTrackerViewController: UIViewController{
    private struct ConstantsGreateVc {
        static let newHabit = "Новая привычка"
        static let newIrregular = "Новое нерегулярное событие"
        static let placeholderTextField = "Введите название трекера"
        static let textCancelButton = "Отменить"
        static let textGreateButton = "Создать"
        static let characterLimit = "Ограничение 38 символов"
        static let everyDay = "Каждый день"
        static let emptyString = ""
        
        static let restrictionsTextField = 38
        static let numberOfLinesRestrictionsTextField = 1
        
        static let textFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let greateNameTextFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let stackSpacing = CGFloat(10)
        static let spacingVerticalStack = CGFloat(24)
        static let leftIndentTextField = CGFloat(12)
        
        static let insertSeparatorTableView = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        static let cornerRadius = CGFloat(16)
        static let borderWidthButton = CGFloat(1)
    }
    
    private let recordManager: RecordManagerProtocol = RecordManagerStab.shared
    weak var delegate: GreateTrackerViewControllerDelegate?
    
    private var isSchedul: Bool = true
    private var listSettings: [ChoiceParametrs] { isSchedul ? [.category] : [.category, .schedule] }
    private let dataSection: [String] = ["Emoji", "Цвет"]
    
    //данные для создания трекера
    private var schedule: [WeekDay] = [] {
        didSet { checkingForEmptiness() }
    }
    private var color: [UIColor] = [.colorSelection4]
    private var nameNewCategori: String = "Важное"
    //TODO: -
    private var nameTracker: String = ""
    
    private lazy var newHabitLabel: UILabel = {
        let newHabitLabel = UILabel()
        newHabitLabel.text = isSchedul ? ConstantsGreateVc.newIrregular : ConstantsGreateVc.newHabit
        newHabitLabel.textColor = .blackDay
        newHabitLabel.font = ConstantsGreateVc.textFont
        newHabitLabel.textAlignment = .center
        newHabitLabel.backgroundColor = .clear
        
        return newHabitLabel
    }()
    
    private lazy var greateNameTextField: UITextField = {
        let greateNameTextField = UITextField()
        greateNameTextField.placeholder = ConstantsGreateVc.placeholderTextField
        greateNameTextField.font = ConstantsGreateVc.greateNameTextFieldFont
        greateNameTextField.indent(size: ConstantsGreateVc.leftIndentTextField)
        greateNameTextField.backgroundColor = .backgroundNight
        greateNameTextField.layer.cornerRadius = ConstantsGreateVc.cornerRadius
        greateNameTextField.layer.masksToBounds = true
        greateNameTextField.clearButtonMode = .whileEditing
        greateNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        greateNameTextField.delegate = self
        
        return greateNameTextField
    }()
    
    private lazy var characterRestrictionsView: UILabel = {
        let characterRestrictionsView = UILabel()
        characterRestrictionsView.backgroundColor = .clear
        characterRestrictionsView.font = ConstantsGreateVc.greateNameTextFieldFont
        characterRestrictionsView.text = ConstantsGreateVc.characterLimit
        characterRestrictionsView.textColor = .redDay
        characterRestrictionsView.numberOfLines = ConstantsGreateVc.numberOfLinesRestrictionsTextField
        characterRestrictionsView.textAlignment = .center
        characterRestrictionsView.isHidden = true
        
        return characterRestrictionsView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = ConstantsGreateVc.stackSpacing
        
        return stackView
    }()
    
    private lazy var selectionTableView: UITableView = {
        let selectionTableView = UITableView()
        selectionTableView.dataSource = self
        selectionTableView.allowsSelection = false
        selectionTableView.backgroundColor = .clear
        selectionTableView.isScrollEnabled = false
        selectionTableView.separatorStyle = isSchedul ? .none : .singleLine
        selectionTableView.separatorInset = ConstantsGreateVc.insertSeparatorTableView
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
        cancelButton.layer.cornerRadius = ConstantsGreateVc.cornerRadius
        cancelButton.layer.borderWidth = ConstantsGreateVc.borderWidthButton
        cancelButton.layer.borderColor = UIColor.redDay.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle(ConstantsGreateVc.textCancelButton , for: .normal)
        cancelButton.setTitleColor(.redDay, for: .normal)
        cancelButton.titleLabel?.font = ConstantsGreateVc.textFont
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private lazy var greateButton: UIButton = {
        let greateButton = UIButton()
        greateButton.layer.cornerRadius = ConstantsGreateVc.cornerRadius
        greateButton.layer.masksToBounds = true
        greateButton.backgroundColor = .grayDay
        greateButton.setTitle(ConstantsGreateVc.textGreateButton, for: .normal)
        greateButton.titleLabel?.textColor = .redDay
        greateButton.titleLabel?.font = ConstantsGreateVc.textFont
        greateButton.isEnabled = false
        greateButton.addTarget(self, action: #selector(didTapGreateButton) , for: .touchUpInside)
        
        return greateButton
    }()
    
    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = ConstantsGreateVc.stackSpacing
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupUIElement()
        schedule = isSchedul ? recordManager.getWeekDay() : []
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
        let oldCategories = recordManager.getCategories()
        let categories = greateNewCategori(categories: oldCategories)
        delegate?.greateTrackerViewController(vc: self, categories: categories)
        delegate?.greateTrackerViewControllerDidCancel(self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > ConstantsGreateVc.restrictionsTextField {
            characterRestrictionsView.isHidden = false
            textField.text = nameTracker.firstUppercased
            return
        }
        nameTracker = text.firstUppercased
        checkingForEmptiness()
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
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
            stringListDay = ConstantsGreateVc.everyDay
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
    private func greateNewCategori(categories: [TrackerCategory]) -> [TrackerCategory] {
        var newCategories: [TrackerCategory] = []
        let tracker = greateNewTracker()
        var trackers: [Tracker] = []
        categories.forEach { oldCategori in
            oldCategori.arrayTrackers.forEach { oldTracker in
                trackers.append(oldTracker)
            }
            trackers.append(tracker)
            let categori = TrackerCategory(nameCategori: oldCategori.nameCategori, arrayTrackers: trackers)
            newCategories.append(categori)
            
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
        [greateNameTextField, characterRestrictionsView].forEach {
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
        let secondarySchedulText = jonedSchedule(schedule: schedule)
        cell.delegate = self
        switch listSettings[indexPath.row] {
        case .category:
            cell.configCell(choice: listSettings[indexPath.row])
            cell.configSecondaryLableShedule(secondaryText: nameNewCategori)
        case .schedule:
            cell.configCell(choice: listSettings[indexPath.row])
            cell.configSecondaryLableShedule(secondaryText: secondarySchedulText)
        }
        return cell
    }
}

//MARK: - UITextFieldDelegate
extension GreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        greateNameTextField.resignFirstResponder()
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
            greateCategoriViewController.delegate = self
            presentViewController(vc: greateCategoriViewController, modalStyle: .formSheet)
        case .schedule:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            presentViewController(vc: scheduleViewController, modalStyle: .formSheet)
        }
    }
    
    func presentViewController(vc: UIViewController, modalStyle: UIModalPresentationStyle) {
        vc.modalPresentationStyle = modalStyle
        present(vc, animated: true)
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
