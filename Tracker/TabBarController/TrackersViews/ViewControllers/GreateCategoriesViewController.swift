//
//  GreateCategoriesViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit

fileprivate let categoriLabelText = "Категория"
fileprivate let categoriAddButtonText = "Добавить категорию"
fileprivate let imageViewImageStab = "Star"
fileprivate let labelStabText = "Привычки и события можно обЪединить по смыслу"

fileprivate let cornerRadius = CGFloat(16)
fileprivate let categoriLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
fileprivate let labelStabTextFont = UIFont.systemFont(ofSize: 12, weight: .medium)
fileprivate let lableFont = UIFont.systemFont(ofSize: 17, weight: .regular)

//MARK: - GreateCategoriesViewControllerDelegate
protocol GreateCategoriesViewControllerDelegate: AnyObject {
    func greateCategoriesViewController(vc: UIViewController, nameCategori: String)
    func greateCategoriesViewControllerDidCancel(vc: GreateCategoriesViewController)
}

//MARK: - GreateCategoriesViewController
final class GreateCategoriesViewController: UIViewController {
    weak var delegate: GreateCategoriesViewControllerDelegate?
    
    private var categories: [String] = ["Важное"]
    private var selectedCategoriName: String = ""
    private lazy var categoriLabel: UILabel = {
        let categoriLabel = UILabel()
        categoriLabel.text = categoriLabelText
        categoriLabel.textColor = .blackDay
        categoriLabel.font = categoriLabelFont
        categoriLabel.textAlignment = .center
        categoriLabel.backgroundColor = .clear
        
        return categoriLabel
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        let image = UIImage(named: imageViewImageStab)
        imageViewStab.image = image
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.text = labelStabText
        lableTextStab.font = labelStabTextFont
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
        selectionCategoriTableView.register(GreateCategoriesTableViewCell.self, forCellReuseIdentifier: "\(GreateCategoriesTableViewCell.self)")
        
        return selectionCategoriTableView
    }()
    
    private lazy var greateCategoriButton: UIButton = {
        let greateCategoriButton = setupButton(text: categoriAddButtonText, font: categoriLabelFont, cornerRadius: cornerRadius)
        greateCategoriButton.addTarget(self, action: #selector(didTapСategoriButton), for: .allTouchEvents)
        
        return greateCategoriButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUIElement()
        showStabView(flag: !categories.isEmpty)
        selectionCategoriTableView.rowHeight = 75
    }
}

private extension GreateCategoriesViewController {
    //MARK: - обработка событий
    @objc
    func didTapСategoriButton() {
        delegate?.greateCategoriesViewController(vc: self, nameCategori: selectedCategoriName)
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
        view.addSubview(greateCategoriButton)
        
        NSLayoutConstraint.activate([
            greateCategoriButton.heightAnchor.constraint(equalToConstant: 60),
            greateCategoriButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            greateCategoriButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            greateCategoriButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
            selectionCategoriTableView.bottomAnchor.constraint(equalTo: greateCategoriButton.topAnchor)
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
extension GreateCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreateCategoriesTableViewCell.self)") as? GreateCategoriesTableViewCell else { return UITableViewCell() }
        let text = categories[indexPath.row]
        cell.config(text: text)
        
        return cell
    }
}
