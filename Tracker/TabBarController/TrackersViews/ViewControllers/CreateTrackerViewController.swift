//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 3.10.23.
//

import UIKit

//MARK: - CreateTrackerViewControllerDelegate
protocol CreateTrackerViewControllerDelegate: AnyObject {
    func createTrackerViewController(vc: UIViewController, nameCategories: String, tracker: Tracker)
    func createTrackerViewControllerDidCancel(_ vc: CreateTrackerViewController)
}

//MARK: - CreateTrackerViewController
final class CreateTrackerViewController: UIViewController{
    private struct ConstantsCreateVc {
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
        static let heightCollectionView = CGFloat(54)
        
        static let textFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let createNameTextFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let spacingButtonSpacing = CGFloat(10)
        static let spacingContentStack = CGFloat(24)
        static let leftIndentTextField = CGFloat(12)
        
        static let insertSeparatorTableView = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        static let cornerRadius = CGFloat(16)
        static let borderWidthButton = CGFloat(1)
    }
    
    private let recordManager: RecordManagerProtocol = RecordManagerStab.shared
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private var isSchedul: Bool = true
    private var listSettings: [ChoiceParametrs] { isSchedul ? [.category] : [.category, .schedule] }
    private let dataSection: [Header] = [.emoji, .color]
    private let emojies: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                   "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3,.colorSelection4,
                                     .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8,
                                     .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12,
                                     .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16,
                                     .colorSelection17, .colorSelection18]
    
    //данные для создания трекера
    private var schedule: [WeekDay] = [] {
        didSet { checkingForEmptiness() }
    }
    private var color: UIColor? {
        didSet { checkingForEmptiness() }
    }
    private var nameNewCategori: String = "Важное"
    //TODO: -
    private var nameTracker: String = ""
    private var emoji: String = "" {
        didSet { checkingForEmptiness() }
    }
    
    private lazy var newHabitLabel: UILabel = {
        let newHabitLabel = UILabel()
        newHabitLabel.text = isSchedul ? ConstantsCreateVc.newIrregular : ConstantsCreateVc.newHabit
        newHabitLabel.textColor = .blackDay
        newHabitLabel.font = ConstantsCreateVc.textFont
        newHabitLabel.textAlignment = .center
        newHabitLabel.backgroundColor = .clear
        
        return newHabitLabel
    }()
    
    private lazy var createNameTextField: UITextField = {
        let createNameTextField = UITextField()
        createNameTextField.placeholder = ConstantsCreateVc.placeholderTextField
        createNameTextField.font = ConstantsCreateVc.createNameTextFieldFont
        createNameTextField.indent(size: ConstantsCreateVc.leftIndentTextField)
        createNameTextField.backgroundColor = .backgroundNight
        createNameTextField.layer.cornerRadius = ConstantsCreateVc.cornerRadius
        createNameTextField.layer.masksToBounds = true
        createNameTextField.clearButtonMode = .whileEditing
        createNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        createNameTextField.delegate = self
        
        return createNameTextField
    }()
    
    private lazy var characterRestrictionsView: UILabel = {
        let characterRestrictionsView = UILabel()
        characterRestrictionsView.backgroundColor = .clear
        characterRestrictionsView.font = ConstantsCreateVc.createNameTextFieldFont
        characterRestrictionsView.text = ConstantsCreateVc.characterLimit
        characterRestrictionsView.textColor = .redDay
        characterRestrictionsView.numberOfLines = ConstantsCreateVc.numberOfLinesRestrictionsTextField
        characterRestrictionsView.textAlignment = .center
        characterRestrictionsView.isHidden = true
        
        return characterRestrictionsView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.backgroundColor = .clear
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = ConstantsCreateVc.spacingContentStack
        
        return contentStackView
    }()
    
    private lazy var selectionTableView: UITableView = {
        let selectionTableView = UITableView()
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
        selectionTableView.backgroundColor = .clear
        selectionTableView.isScrollEnabled = false
        selectionTableView.separatorStyle = isSchedul ? .none : .singleLine
        selectionTableView.separatorInset = ConstantsCreateVc.insertSeparatorTableView
        selectionTableView.register(CreateTrackerTableViewCell.self, forCellReuseIdentifier: "\(CreateTrackerTableViewCell.self)")
        
        return selectionTableView
    }()
    
    private lazy var emojiCollectionView: TrackerCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let params = GeometricParams(cellCount: 7, leftInset: 6, rightInset: 6, cellSpacing: 2)
        let emojiCollectionView = TrackerCollectionView(frame: .zero, collectionViewLayout: layout, params: params)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(EmojiColorCollectionViewCell.self, forCellWithReuseIdentifier: "\(EmojiColorCollectionViewCell.self)")
        emojiCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        emojiCollectionView.allowsMultipleSelection = false
        emojiCollectionView.backgroundColor = .clear
        emojiCollectionView.isScrollEnabled = false
        emojiCollectionView.scrollIndicatorInsets = .zero
        
        return emojiCollectionView
    }()
    
    private lazy var colorCollectionView: TrackerCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let params = GeometricParams(cellCount: 6, leftInset: 6, rightInset: 6, cellSpacing: 2)
        let colorCollectionView = TrackerCollectionView(frame: .zero, collectionViewLayout: layout, params: params)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(EmojiColorCollectionViewCell.self, forCellWithReuseIdentifier: "\(EmojiColorCollectionViewCell.self)")
        colorCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        colorCollectionView.allowsMultipleSelection = false
        colorCollectionView.backgroundColor = .clear
        colorCollectionView.isScrollEnabled = false
        colorCollectionView.scrollIndicatorInsets = .zero
        
        return colorCollectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.cornerRadius = ConstantsCreateVc.cornerRadius
        cancelButton.layer.borderWidth = ConstantsCreateVc.borderWidthButton
        cancelButton.layer.borderColor = UIColor.redDay.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle(ConstantsCreateVc.textCancelButton , for: .normal)
        cancelButton.setTitleColor(.redDay, for: .normal)
        cancelButton.titleLabel?.font = ConstantsCreateVc.textFont
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = ConstantsCreateVc.cornerRadius
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = .grayDay
        createButton.setTitle(ConstantsCreateVc.textGreateButton, for: .normal)
        createButton.titleLabel?.textColor = .redDay
        createButton.titleLabel?.font = ConstantsCreateVc.textFont
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(didTapGreateButton) , for: .touchUpInside)
        
        return createButton
    }()
    
    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = ConstantsCreateVc.spacingButtonSpacing
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
        scrollView.showsVerticalScrollIndicator = false

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

extension CreateTrackerViewController {
    //MARK: - Обработка событий
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapGreateButton() {
        guard let color, let delegate else { return }
        let tracker = Tracker(name: nameTracker, color: color, emoji: emoji, schedule: schedule)
        delegate.createTrackerViewController(vc: self, nameCategories: nameNewCategori, tracker: tracker)
        delegate.createTrackerViewControllerDidCancel(self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > ConstantsCreateVc.restrictionsTextField {
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
    private func isActivCreateButton(flag: Bool) {
        createButton.isEnabled = flag
        createButton.backgroundColor = flag ? .blackDay : .grayDay
    }
    
    //метод ссоздания текста для вторичной строки в ячейке "shedul"
    private func jonedSchedule(schedule: [WeekDay]) -> String {
        var stringListDay: String
        if schedule.count == 7 {
            stringListDay = ConstantsCreateVc.everyDay
            return stringListDay
        }
        let listDay = schedule.map { $0.briefWordDay }
        stringListDay = listDay.joined(separator: ",")
        
        return stringListDay
    }
    
    //метод создания трекера
    private func createNewTracker() -> Tracker {
        let tracker = Tracker(name: nameTracker, color: .colorSelection12, emoji: "🍏", schedule: schedule)
        return tracker
    }
    
    //медод создания нового массива категорий c новым созданным трекером
//    private func createNewCategori(categories: [TrackerCategory]) -> [TrackerCategory] {
//        var newCategories: [TrackerCategory] = []
//        let tracker = createNewTracker()
//        var trackers: [Tracker] = []
//        categories.forEach { oldCategori in
//            oldCategori.arrayTrackers.forEach { oldTracker in
//                trackers.append(oldTracker)
//            }
//            trackers.append(tracker)
//            let categori = TrackerCategory(nameCategory: oldCategori.nameCategory, arrayTrackers: trackers)
//            newCategories.append(categori)
//
//        }
//        return newCategories
//    }
    
    //метод проверки свойств на пустоту
    private func checkingForEmptiness() {
        let flag = !schedule.isEmpty && !nameTracker.isEmpty && color != nil && !emoji.isEmpty ? true : false
        isActivCreateButton(flag: flag)
    }
    
    //метод изменения свойства isSchedul
    func reverseIsSchedul() {
        isSchedul = isSchedul ? !isSchedul : isSchedul
    }
    
    func presentViewController(vc: UIViewController, modalStyle: UIModalPresentationStyle) {
        vc.modalPresentationStyle = modalStyle
        present(vc, animated: true)
    }
    //MARK: - SetupUI
    func setupUIElement() {
        setupNewHabitLabel()
        setupButtonStack()
        setupScrollView()
        setupStackView()
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
        [cancelButton, createButton].forEach {
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
        scrollView.addSubview(contentStackView)
        [createNameTextField, characterRestrictionsView, selectionTableView, emojiCollectionView, colorCollectionView].forEach {
            contentStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            createNameTextField.heightAnchor.constraint(equalToConstant: 75),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            selectionTableView.heightAnchor.constraint(equalToConstant: isSchedul ? 75 : 150)
        ])
    }
}

//MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CreateTrackerTableViewCell.self)") as? CreateTrackerTableViewCell else { return UITableViewCell() }
        let secondarySchedulText = jonedSchedule(schedule: schedule)
        switch listSettings[indexPath.row] {
        case .category:
            cell.configCell(choice: listSettings[indexPath.row])
            cell.configSecondaryLableShedule(secondaryText: nameNewCategori)
        case .schedule:
            cell.configCell(choice: listSettings[indexPath.row])
            cell.configSecondaryLableShedule(secondaryText: secondarySchedulText)
            tableView.separatorInset = UIEdgeInsets(top: 0, left: view.bounds.width, bottom: 0, right: 0)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch listSettings[indexPath.row] {
        case .category:
            let greateCategoriViewController = CreateCategoriesViewController()
            greateCategoriViewController.delegate = self
            presentViewController(vc: greateCategoriViewController, modalStyle: .formSheet)
        case .schedule:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            presentViewController(vc: scheduleViewController, modalStyle: .formSheet)
        }
    }
}

//MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createNameTextField.resignFirstResponder()
        return true
    }
}

//MARK: - ScheduleViewControllerDelegate
extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func daysOfWeek(viewController: UIViewController, listDays: [WeekDay]) {
        guard let _ = viewController as? ScheduleViewController else { return }
        schedule = listDays
        selectionTableView.reloadData()
    }
}

//MARK: - GreateCategoriesViewControllerDelegate
extension CreateTrackerViewController: CreateCategoriesViewControllerDelegate {
    func createCategoriesViewController(vc: UIViewController, nameCategori: String) {
        nameNewCategori = nameCategori
    }
    
    func createCategoriesViewControllerDidCancel(vc: CreateCategoriesViewController) {
        vc.dismiss(animated: true)
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int
        switch dataSection[section] {
        case .color:
            count = colors.count
        case .emoji:
            count = emojies.count
        }
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(EmojiColorCollectionViewCell.self)", for: indexPath) as? EmojiColorCollectionViewCell
        else { return UICollectionViewCell() }
        if collectionView == colorCollectionView {
            let color = colors[indexPath.row]
            cell.configColor(color: color)
        }
        if collectionView == emojiCollectionView {
            let emoji = emojies[indexPath.row]
            cell.configEmoji(emoji: emoji)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        if collectionView == colorCollectionView {
            let color = colors[indexPath.row]
            cell.colorSelection(color: color, flag: true)
            self.color = color
        }
        if collectionView == emojiCollectionView {
            let emoji = emojies[indexPath.row]
            cell.emojiSelection(isBackground: true)
            self.emoji = emoji
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        if collectionView == colorCollectionView {
            let color: UIColor = .clear
            cell.colorSelection(color: color, flag: false)
        }
        if collectionView == emojiCollectionView {
            cell.emojiSelection(isBackground: false)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - emojiCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(emojiCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: ConstantsCreateVc.heightCollectionView)

        return sizeCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: emojiCollectionView.params.leftInset, bottom: 16, right: emojiCollectionView.params.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var systemLayoutSize: CGSize
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        systemLayoutSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return systemLayoutSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if collectionView == colorCollectionView {
                supplementary.label.text = Header.color.name
            }
            if collectionView == emojiCollectionView {
                supplementary.label.text = Header.emoji.name
            }
        default:
            return UICollectionReusableView()
        }
        return supplementary
    }
}
