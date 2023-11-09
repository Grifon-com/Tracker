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
        static let categoriLabelText = "Категория"
        static let categoriAddButtonText = "Добавить категорию"
        static let imageViewImageStab = "Star"
        static let labelStabText = "Привычки и события можно обЪединить по смыслу"
        
        static let cornerRadius = CGFloat(16)
        static let categoriLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let labelStabTextFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let insertSeparatorTableView = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        static let backgroundColorCell: UIColor = .backgroundNight
    }
    
    weak var delegate: CreateCategoriesViewControllerDelegate?
    
    private var viewModel: CategoriViewModel?
    
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
        lableTextStab.numberOfLines = 2
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
    
    private lazy var selectionCategoriTableView: UITableView = {
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
        
        createCategoriButton.addTarget(self, action: #selector(didTapСategoriButton), for: .touchUpInside)
        
        return createCategoriButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel else { return }
        bind()
        view.backgroundColor = .whiteDay
        setupUIElement()
        showStabView(flag: !viewModel.category.isEmpty)
        selectionCategoriTableView.rowHeight = 75
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

extension CreateCategoriesViewController {
    func config(viewModel: CategoriViewModel?) {
        self.viewModel = viewModel
    }
    
    //MARK: - обработка событий
    @objc
    private func didTapСategoriButton() {
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
        viewModel?.$category.bind { [weak self] _ in
            guard let self,
                  let viewModel
            else { return }
            showStabView(flag: !viewModel.category.isEmpty)
            selectionCategoriTableView.reloadData()
        }
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
        view.addSubview(selectionCategoriTableView)
        selectionCategoriTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionCategoriTableView.topAnchor.constraint(equalTo: categoriLabel.bottomAnchor, constant: 24),
            selectionCategoriTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionCategoriTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            selectionCategoriTableView.bottomAnchor.constraint(equalTo: createCategoriButton.topAnchor)
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
        guard let viewModel else { return 0 }
        return viewModel.category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CreateCategoriesTableViewCell.self)") as? CreateCategoriesTableViewCell,
              let viewModel
        else { return UITableViewCell() }
        let isSelected = viewModel.isCategorySelected(at: indexPath.row)
        let text = viewModel.createNameCategory(at: indexPath.row)
        cell.showSelectedImage(flag: isSelected)
        let model = CreateCategoryCellModel(text: text, color: ConstantsCreateCatVc.backgroundColorCell)
        cell.config(model: model)
        
        if viewModel.category.count > 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        }
        
        if indexPath.row == viewModel.category.count - 1 {
            cell.setupCornerRadius(cornerRadius: ConstantsCreateCatVc.cornerRadius,
                                   maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            cell.separatorInset = UIEdgeInsets(top: 0, left: view.bounds.width, bottom: 0, right: 0)
        }
        
        if indexPath.row == 0 {
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
              let delegate,
              let viewModel
        else { return }
        cell.showSelectedImage(flag: false)
        viewModel.selectСategory(at: indexPath.row)
        let nameCategory = viewModel.createNameCategory(at: indexPath.row)
        delegate.createCategoriesViewController(vc: self, nameCategory: nameCategory)
    }
}

//MARK: - NewCategoriViewControllerDelegate
extension CreateCategoriesViewController: NewCategoriViewControllerDelegate {
    func didNewCategoriName(_ vc: UIViewController, nameCategori: String) {
        guard let viewModel else { return }
        let nameFirstUppercased = nameCategori.lowercased().firstUppercased
        if viewModel.category.filter({ $0.nameCategory == nameFirstUppercased }).count > 0 {
            return
        }
        
        try? viewModel.addCategory(nameCategory: nameFirstUppercased)
    }
}
