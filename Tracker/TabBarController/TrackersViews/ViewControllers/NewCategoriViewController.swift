//
//  NewCategoriViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 13.10.23.
//

import UIKit

fileprivate let newcategoriLabelText = "Новая категория"
fileprivate let buttonName = "Готово"
fileprivate let placeholderTextField = "Введите название категории"


fileprivate let cornerRadius = CGFloat(16)
fileprivate let leftIndentTextField = CGFloat(12)
fileprivate let newCategoriLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
fileprivate let textFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)

//MARK: - NewCategoriViewController
class NewCategoriViewController: UIViewController {
    private var nameCategori: String = ""
    
    private lazy var newCategoriLabel: UILabel = {
        let newCategoriLabel = UILabel()
        newCategoriLabel.text = newcategoriLabelText
        newCategoriLabel.textColor = .blackDay
        newCategoriLabel.font = newCategoriLabelFont
        newCategoriLabel.textAlignment = .center
        newCategoriLabel.backgroundColor = .clear
        
        return newCategoriLabel
    }()
    
    private lazy var readyButton: UIButton = {
        let readyButton = setupButton(text: newcategoriLabelText, font: newCategoriLabelFont, cornerRadius: cornerRadius)
        readyButton.addTarget(self, action: #selector(didTapNewСategoriButton), for: .allTouchEvents)
        
        return readyButton
    }()
    
    private lazy var greateNameTextField: UITextField = {
        let greateNameTextField = UITextField()
        greateNameTextField.placeholder = placeholderTextField
        greateNameTextField.font = textFieldFont
        greateNameTextField.indent(size: leftIndentTextField)
        greateNameTextField.backgroundColor = .backgroundNight
        greateNameTextField.layer.cornerRadius = cornerRadius
        greateNameTextField.layer.masksToBounds = true
        greateNameTextField.clearButtonMode = .whileEditing
        greateNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return greateNameTextField
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
