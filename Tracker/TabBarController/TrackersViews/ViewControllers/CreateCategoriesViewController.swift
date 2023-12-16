//
//  CreateCategoriesViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit

//MARK: - CreateCategoriesViewControllerDelegate
protocol CreateCategoriesViewControllerDelegate: AnyObject {
    func createCategoriesViewController(vc: UIViewController, nameCategory: String)
}

//MARK: - CreateCategoriesViewController
final class CreateCategoriesViewController: UIViewController {
    private struct ConstantsCreateCatVc {
        static let imageViewImageStab = "Star"
        static let alertActionErrorTitle = "Ok"
        
        static let categoriLabelText = NSLocalizedString("categoriLabelText", comment: "")
        static let categoriAddButtonText = NSLocalizedString("categoriAddButtonText", comment: "")
        static let labelStabText = NSLocalizedString("labelStabText", comment: "")
        static let textFixed = NSLocalizedString("textFixed", comment: "")
        
        static let lableTextStabNumberOfLines = 2
        static let selectionCategoryTableViewRowHeight = CGFloat(75)
        static let cornerRadius = CGFloat(16)
        static let categoriLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let labelStabTextFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let insertSeparatorTableView = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: 12)
        
        static let backgroundColorCell: UIColor = .backgroundNight
    }
    
    weak var delegate: CreateCategoriesViewControllerDelegate?
    private var viewModel: TrackerViewModelProtocol
    
    private lazy var categoriLabel: UILabel = {
        let categoriLabel = UILabel()
        categoriLabel.text = ConstantsCreateCatVc.categoriLabelText
        categoriLabel.textColor = .blackDay
        categoriLabel.font = ConstantsCreateCatVc.categoriLabelFont
        categoriLabel.textAlignment = .center
        categoriLabel.backgroundColor = .clear
        
        return categoriLabel
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        let image = UIImage(named: ConstantsCreateCatVc.imageViewImageStab)
        imageViewStab.image = image
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.text = ConstantsCreateCatVc.labelStabText
        lableTextStab.font = ConstantsCreateCatVc.labelStabTextFont
        lableTextStab.numberOfLines = ConstantsCreateCatVc.lableTextStabNumberOfLines
        lableTextStab.textAlignment = .center
        
        return lableTextStab
    }()
    
    private lazy var conteinerStabView: UIView = {
        let conteinerStabView = UIView()
        conteinerStabView.translatesAutoresizingMaskIntoConstraints = false
        conteinerStabView.backgroundColor = .clear
        conteinerStabView.isHidden = false
        
        return conteinerStabView
    }()
    
    private lazy var selectionCategoryTableView: UITableView = {
        let selectionCategoriTableView = UITableView()
        selectionCategoriTableView.dataSource = self
        selectionCategoriTableView.delegate = self
        selectionCategoriTableView.backgroundColor = .clear
        selectionCategoriTableView.separatorStyle = .singleLine
        selectionCategoriTableView.register(CreateCategoriesTableViewCell.self, forCellReuseIdentifier: "\(CreateCategoriesTableViewCell.self)")
        selectionCategoriTableView.separatorInset = ConstantsCreateCatVc.insertSeparatorTableView
        
        return selectionCategoriTableView
    }()
    
    private lazy var createCategoriButton: UIButton = {
        let createCategoriButton = UIButton()
        createCategoriButton.setTitle(ConstantsCreateCatVc.categoriAddButtonText, for: .normal)
        createCategoriButton.titleLabel?.textColor = .whiteDay
        createCategoriButton.backgroundColor = .blackDay
        createCategoriButton.titleLabel?.font = ConstantsCreateCatVc.lableFont
        createCategoriButton.layer.cornerRadius = ConstantsCreateCatVc.cornerRadius
        createCategoriButton.layer.masksToBounds = true
        createCategoriButton.translatesAutoresizingMaskIntoConstraints = false
        
        createCategoriButton.addTarget(self, action: #selector(didTapСategoryButton), for: .touchUpInside)
        
        return createCategoriButton
    }()
    
    init(delegate: CreateCategoriesViewControllerDelegate, viewModel: TrackerViewModelProtocol) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel as? TrackerViewModel else { return }
        setupUIElement()
        bind()
        view.backgroundColor = .whiteDay
        resultTypeHandler(viewModel.category) { [weak self] cat in
            guard let self else { return }
            self.showStabView(flag: !cat.isEmpty)
        }
        selectionCategoryTableView.rowHeight = ConstantsCreateCatVc.selectionCategoryTableViewRowHeight
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

extension CreateCategoriesViewController {
    //MARK: - обработка событий
    @objc
    private func didTapСategoryButton() {
        let newCategoryVC = NewCategoriViewController()
        newCategoryVC.delegate = self
        newCategoryVC.modalPresentationStyle = .formSheet
        present(newCategoryVC, animated: true)
    }
    
    // метод показа/скрытия заглушки
    private func showStabView(flag: Bool) {
        conteinerStabView.isHidden = flag
    }
    
    private func bind() {
        guard let viewModel = viewModel as? TrackerViewModel else { return }
        viewModel.$category.bind { [weak self] _ in
            guard let self else { return }
            resultTypeHandler(viewModel.category) { cat in
                self.showStabView(flag: !cat.isEmpty)
            }
            selectionCategoryTableView.reloadData()
        }
    }
    
    private func resultTypeHandler<Value>(_ value: Result<Value, Error>, handler: (Value) -> Void) {
        switch value {
        case .success(let newValue):
            handler(newValue)
        case .failure(let error):
            showMessageErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func resultTypeHandlerGetValue<Value>(_ value: Result<Value, Error>) -> Value? {
        switch value {
        case .success(let newValue):
            return newValue
        case .failure(let error):
            showMessageErrorAlert(message: error.localizedDescription)
            return nil
        }
    }
    
    private func showMessageErrorAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ConstantsCreateCatVc.alertActionErrorTitle, style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
    }
    
    //MARK: - SetupUI
    private func setupUIElement() {
        setupCategoriButton()
        setupCategoriLabel()
        setupTableView()
        setupStabView()
    }
    
    private func setupCategoriButton() {
        view.addSubview(createCategoriButton)
        
        NSLayoutConstraint.activate([
            createCategoriButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoriButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createCategoriButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoriButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCategoriLabel() {
        view.addSubview(categoriLabel)
        categoriLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(selectionCategoryTableView)
        selectionCategoryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionCategoryTableView.topAnchor.constraint(equalTo: categoriLabel.bottomAnchor, constant: 24),
            selectionCategoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionCategoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            selectionCategoryTableView.bottomAnchor.constraint(equalTo: createCategoriButton.topAnchor)
        ])
    }
    
    private func setupStabView() {
        view.addSubview(conteinerStabView)
        [imageViewStab, lableTextStab].forEach {
            conteinerStabView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            conteinerStabView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            conteinerStabView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageViewStab.centerYAnchor.constraint(equalTo: conteinerStabView.centerYAnchor),
            imageViewStab.centerXAnchor.constraint(equalTo: conteinerStabView.centerXAnchor),
            
            lableTextStab.widthAnchor.constraint(equalToConstant: 200),
            lableTextStab.centerXAnchor.constraint(equalTo: conteinerStabView.centerXAnchor),
            lableTextStab.topAnchor.constraint(equalTo: imageViewStab.bottomAnchor, constant: 10)
        ])
    }
}

//MARK: - UITableViewDataSource
extension CreateCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = resultTypeHandlerGetValue(viewModel.getCategory())?.count
        else { return .zero }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CreateCategoriesTableViewCell.self)") as? CreateCategoriesTableViewCell,
              let isSelected = resultTypeHandlerGetValue(viewModel.isCategorySelected(at: indexPath.row)),
              let text = resultTypeHandlerGetValue(viewModel.createNameCategory(at: indexPath.row)),
              let count = resultTypeHandlerGetValue(viewModel.getCategory())?.count
        else { return UITableViewCell() }
        cell.showSelectedImage(flag: isSelected)
        let model = CreateCategoryCellModel(text: text, color: ConstantsCreateCatVc.backgroundColorCell)
        cell.config(model: model)
        
        if count > 1 {
            cell.separatorInset = ConstantsCreateCatVc.insertSeparatorTableView
        }
        
        if indexPath.row == count - 1 {
            cell.setupCornerRadius(cornerRadius: ConstantsCreateCatVc.cornerRadius,
                                   maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            cell.separatorInset = UIEdgeInsets(top: .zero, left: view.bounds.width, bottom: .zero, right: .zero)
        }
        
        if indexPath.row == .zero {
            cell.setupCornerRadius(cornerRadius: ConstantsCreateCatVc.cornerRadius,
                                   maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CreateCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreateCategoriesTableViewCell,
              let delegate
        else { return }
        cell.showSelectedImage(flag: false)
        resultTypeHandler(viewModel.selectСategory(at: indexPath.row)) {}
        resultTypeHandler(viewModel.createNameCategory(at: indexPath.row)) { [weak self] cat in
            guard let self else { return }
            delegate.createCategoriesViewController(vc: self, nameCategory: cat)
        }
    }
}

//MARK: - NewCategoriViewControllerDelegate
extension CreateCategoriesViewController: NewCategoriViewControllerDelegate {
    func didNewCategoriName(_ vc: UIViewController, nameCategori: String) {
        guard let category = resultTypeHandlerGetValue(viewModel.getCategory())
        else { return }
        let nameFirstUppercased = nameCategori.lowercased().firstUppercased
        if let _ = category.filter({ $0.nameCategory == nameFirstUppercased }).first {
            return
        }
        resultTypeHandler(viewModel.addCategory(nameCategory: nameFirstUppercased)) {}
    }
}
