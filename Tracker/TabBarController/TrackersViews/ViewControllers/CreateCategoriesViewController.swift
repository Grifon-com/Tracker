//
//  CreateCategoriesViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit



//MARK: - CreateCategoriesViewControllerDelegate
protocol CreateCategoriesViewControllerDelegate: AnyObject {
    func createCategoriesViewController(vc: UIViewController, nameCategori: String)
    func createCategoriesViewControllerDidCancel(vc: CreateCategoriesViewController)
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
    }
    
    weak var delegate: CreateCategoriesViewControllerDelegate?
    
    private var categories: [String] = ["Важное"]
    private var selectedCategoriName: String = ""
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
        selectionCategoriTableView.allowsSelection = false
        selectionCategoriTableView.backgroundColor = .clear
        selectionCategoriTableView.isScrollEnabled = false
        selectionCategoriTableView.separatorStyle = .none
        selectionCategoriTableView.register(CreateCategoriesTableViewCell.self, forCellReuseIdentifier: "\(CreateCategoriesTableViewCell.self)")
        
        return selectionCategoriTableView
    }()
    
    private lazy var createCategoriButton: UIButton = {
        let createCategoriButton = setupButton(text: ConstantsCreateCatVc.categoriAddButtonText, font: ConstantsCreateCatVc.categoriLabelFont, cornerRadius: ConstantsCreateCatVc.cornerRadius)
        createCategoriButton.addTarget(self, action: #selector(didTapСategoriButton), for: .touchUpInside)
        
        return createCategoriButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUIElement()
        showStabView(flag: !categories.isEmpty)
        selectionCategoriTableView.rowHeight = 75
    }
}

private extension CreateCategoriesViewController {
    //MARK: - обработка событий
    @objc
    func didTapСategoriButton() {
        delegate?.createCategoriesViewController(vc: self, nameCategori: selectedCategoriName)
        //TODO: - Sprint_15
    }
    
    // метод показа/скрытия заглушки
    func showStabView(flag: Bool) {
        conteinerStabView.isHidden = flag
    }
    
    //MARK: - SetupUI
    func setupUIElement() {
        setupCategoriButton()
        setupCategoriLabel()
        setupTableView()
        setupStabView()
    }
    
    func setupButton(text: String, font: UIFont, cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.textColor = UIColor.whiteDay
        button.backgroundColor = UIColor.blackDay
        button.titleLabel?.font = font
        button.layer.cornerRadius = cornerRadius ?? CGFloat(0)
        button.layer.masksToBounds = cornerRadius == nil ? false : true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func setupCategoriButton() {
        view.addSubview(createCategoriButton)
        
        NSLayoutConstraint.activate([
            createCategoriButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoriButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createCategoriButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoriButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCategoriLabel() {
        view.addSubview(categoriLabel)
        categoriLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTableView() {
        view.addSubview(selectionCategoriTableView)
        selectionCategoriTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionCategoriTableView.topAnchor.constraint(equalTo: categoriLabel.bottomAnchor, constant: 24),
            selectionCategoriTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionCategoriTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            selectionCategoriTableView.bottomAnchor.constraint(equalTo: createCategoriButton.topAnchor)
        ])
    }
    
    func setupStabView() {
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
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CreateCategoriesTableViewCell.self)") as? CreateCategoriesTableViewCell else { return UITableViewCell() }
        let text = categories[indexPath.row]
        cell.config(text: text)
        
        return cell
    }
}
