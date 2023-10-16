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
        static let heightCollectionView = CGFloat(54)
        
        static let textFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let greateNameTextFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let spacingButtonSpacing = CGFloat(10)
        static let spacingContentStack = CGFloat(24)
        static let leftIndentTextField = CGFloat(12)
        
        static let insertSeparatorTableView = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        static let cornerRadius = CGFloat(16)
        static let borderWidthButton = CGFloat(1)
    }
    
    private let recordManager: RecordManagerProtocol = RecordManagerStab.shared
    weak var delegate: GreateTrackerViewControllerDelegate?
    
    private var isSchedul: Bool = true
    private var listSettings: [ChoiceParametrs] { isSchedul ? [.category] : [.category, .schedule] }
    private let dataSection: [Header] = [.emoji, .color]
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
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
    private var color: [UIColor] = []
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
    
    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.backgroundColor = .clear
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = ConstantsGreateVc.spacingContentStack
        
        return contentStackView
    }()
    
    private lazy var selectionTableView: UITableView = {
        let selectionTableView = UITableView()
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
        selectionTableView.backgroundColor = .clear
        selectionTableView.isScrollEnabled = false
        selectionTableView.separatorStyle = isSchedul ? .none : .singleLine
        selectionTableView.separatorInset = ConstantsGreateVc.insertSeparatorTableView
        selectionTableView.register(GreateTrackerTableViewCell.self, forCellReuseIdentifier: "\(GreateTrackerTableViewCell.self)")
        
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
        buttonStack.spacing = ConstantsGreateVc.spacingButtonSpacing
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
        [greateNameTextField, characterRestrictionsView, selectionTableView, emojiCollectionView, colorCollectionView].forEach {
            contentStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            greateNameTextField.heightAnchor.constraint(equalToConstant: 75),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            selectionTableView.heightAnchor.constraint(equalToConstant: isSchedul ? 75 : 150)
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

//MARK: - UITableViewDelegate
extension GreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GreateTrackerTableViewCell else { return }
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
}

//MARK: - UITextFieldDelegate
extension GreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        greateNameTextField.resignFirstResponder()
        return true
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

extension GreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int
        switch dataSection[section] {
        case .color:
            count = colors.count
        case .emoji:
            count = emoji.count
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
            let emoji = emoji[indexPath.row]
            cell.configEmoji(emoji: emoji)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension GreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        if collectionView == colorCollectionView {
            let color = colors[indexPath.row]
            cell.colorSelection(color: color, flag: true)
        }
        if collectionView == emojiCollectionView {
            cell.emojiSelection(isBackground: true)
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
extension GreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - emojiCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(emojiCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: ConstantsGreateVc.heightCollectionView)

        return sizeCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: emojiCollectionView.params.leftInset, bottom: 16, right: emojiCollectionView.params.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var systemLayoutSize: CGSize
        switch dataSection[section] {
        case .color:
            let indexPath = IndexPath(row: 1, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            systemLayoutSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        case .emoji:
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            systemLayoutSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }
        return systemLayoutSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            supplementary.label.text = dataSection[indexPath.section].name
            return supplementary
        default:
            return UICollectionReusableView()
        }
    }
}
