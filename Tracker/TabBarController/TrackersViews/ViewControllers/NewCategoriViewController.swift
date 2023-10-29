//
//  NewCategoriViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit

//MARK: - NewCategoriViewController
class NewCategoriViewController: UIViewController {
    private struct ConstantsNewCatVc {
        static let newcategoriLabelText = "Новая категория"
        static let buttonName = "Готово"
        static let placeholderTextField = "Введите название категории"
        
        static let cornerRadius = CGFloat(16)
        static let leftIndentTextField = CGFloat(12)
        static let newCategoriLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let textFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    private var nameCategori: String = ""
    
    private lazy var newCategoriLabel: UILabel = {
        let newCategoriLabel = UILabel()
        newCategoriLabel.text = ConstantsNewCatVc.newcategoriLabelText
        newCategoriLabel.textColor = .blackDay
        newCategoriLabel.font = ConstantsNewCatVc.newCategoriLabelFont
        newCategoriLabel.textAlignment = .center
        newCategoriLabel.backgroundColor = .clear
        
        return newCategoriLabel
    }()
    
    private lazy var readyButton: UIButton = {
        let readyButton = setupButton(text: ConstantsNewCatVc.newcategoriLabelText, font: ConstantsNewCatVc.newCategoriLabelFont, cornerRadius: ConstantsNewCatVc.cornerRadius)
        readyButton.addTarget(self, action: #selector(didTapNewСategoriButton), for: .touchUpInside)
        
        return readyButton
    }()
    
    private lazy var createNameTextField: UITextField = {
        let createNameTextField = UITextField()
        createNameTextField.placeholder = ConstantsNewCatVc.placeholderTextField
        createNameTextField.font = ConstantsNewCatVc.textFieldFont
        createNameTextField.indent(size: ConstantsNewCatVc.leftIndentTextField)
        createNameTextField.backgroundColor = .backgroundNight
        createNameTextField.layer.cornerRadius = ConstantsNewCatVc.cornerRadius
        createNameTextField.layer.masksToBounds = true
        createNameTextField.clearButtonMode = .whileEditing
        createNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return createNameTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension NewCategoriViewController {
    //MARK: - Обработка событий
    
    @objc
    func didTapNewСategoriButton() {
        //TODO: -
    }
    
    @objc
    func textFieldDidChange() {
        //TODO: -
    }
    
    //MARK: - SetupUI
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
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCategoriLabel() {
        view.addSubview(newCategoriLabel)
        newCategoriLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newCategoriLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newCategoriLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
