//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 29.09.23.
//

import UIKit

private enum Constants {
    static let adButtonImageName = "Addtracker"
    static let imageViewImageName = "Star"
    
    static let labelHeaderText = "Трекеры"
    static let labelStabText = "Что будем отслеживать?"
    
    static let labelTextSize = CGFloat(34)
}

final class TrackersViewController: UIViewController {
    private lazy var horisontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(addHabitorEvent), for: .allTouchEvents)
        button.backgroundColor = .clear
        let image = UIImage(named: Constants.adButtonImageName)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = UIColor(named: "Gray Lite")
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        return datePicker
    }()
    
    private lazy var lableHeader: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = Constants.labelHeaderText
        label.font = UIFont.boldSystemFont(ofSize: Constants.labelTextSize)
        label.textColor = UIColor(named: "Black [day]")
        
        return label
    }()
    
    private lazy var seerchText: UISearchTextField = {
        let seerchText = UISearchTextField()
        seerchText.backgroundColor = .clear
        
        return seerchText
    }()
    
    private lazy var collectinView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let contentView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return contentView
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: Constants.imageViewImageName)
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lable = UILabel()
        lable.text = Constants.labelStabText
        lable.font = UIFont.systemFont(ofSize: 12)
        
        return lable
    }()
    
    private lazy var conteinerView: UIView = {
        let conteiner = UIView()
        conteiner.translatesAutoresizingMaskIntoConstraints = false
        conteiner.backgroundColor = .clear
        
        return conteiner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupElementView()
        setupHorisontalStack()
        setupConteinerView()
    }
}

extension TrackersViewController: UITextFieldDelegate {
    
}

private extension TrackersViewController {
    @objc
    func addHabitorEvent() {
        let greateVC = GreateTrackersViewController()
        greateVC.modalPresentationStyle = .formSheet
        tabBarController?.tabBar.barTintColor = .black
        present(greateVC, animated: true)
    }
    
    func setupHorisontalStack() {
        view.addSubview(horisontalStack)
        [addButton, datePicker].forEach {
            horisontalStack.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            horisontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horisontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            horisontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horisontalStack.heightAnchor.constraint(equalToConstant: 44),
//
            addButton.leadingAnchor.constraint(equalTo: horisontalStack.leadingAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.topAnchor.constraint(equalTo: horisontalStack.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: horisontalStack.bottomAnchor),

            datePicker.trailingAnchor.constraint(equalTo: horisontalStack.trailingAnchor),
            datePicker.centerYAnchor.constraint(equalTo: horisontalStack.centerYAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func setupElementView() {
        seerchText.delegate = self
        [horisontalStack, lableHeader, seerchText, collectinView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            lableHeader.topAnchor.constraint(equalTo: horisontalStack.bottomAnchor),
            lableHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            seerchText.topAnchor.constraint(equalTo: lableHeader.bottomAnchor, constant: 10),
            seerchText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            seerchText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            seerchText.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupConteinerView() {
        view.addSubview(conteinerView)
        [imageViewStab, lableTextStab].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            conteinerView.addSubview($0)
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            conteinerView.topAnchor.constraint(equalTo: seerchText.bottomAnchor, constant: 10),
            conteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            conteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            conteinerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageViewStab.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),
            imageViewStab.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            
            lableTextStab.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            lableTextStab.topAnchor.constraint(equalTo: imageViewStab.bottomAnchor, constant: 10)
        ])
    }
}


