//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Григорий Машук on 28.09.23.
//

import UIKit

//MARK: - StatisticsViewController
class StatisticsViewController: UIViewController {
    private struct ConstantsStatisticVC {
        static let headerStatisticText = NSLocalizedString("headerStatisticText", comment: "")
        static let secondaryStatisticText = NSLocalizedString("secondaryStatisticText", comment: "")
        static let labelStubStatisticsText = NSLocalizedString("labelStubStatisticsText", comment: "")
        static let imageNothingFound = "NothingFound"
        
        static let borderRadius = CGFloat(16)
        static let borderWidth = CGFloat(2)
        static let fontLabelHeader = UIFont.boldSystemFont(ofSize: 34)
        static let fontLabelTextStub = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private var viewModel: StatisticsViewModelProtocol?
    
    private lazy var labelHeader: UILabel = {
        let labelHeader = UILabel()
        labelHeader.text = ConstantsStatisticVC.headerStatisticText
        labelHeader.font = ConstantsStatisticVC.fontLabelHeader
        labelHeader.textColor = .blackDay
        labelHeader.translatesAutoresizingMaskIntoConstraints = false
        labelHeader.backgroundColor = .clear
        
        return labelHeader
    }()
    
    private lazy var cardStatysticsView: StatisticsView = {
        let cardStatistics = StatisticsView()
        cardStatistics.setSecondaryTextLable(text: ConstantsStatisticVC.secondaryStatisticText)
        cardStatistics.translatesAutoresizingMaskIntoConstraints = false
        cardStatistics.backgroundColor = .clear
        
        return cardStatistics
    }()
    
    private lazy var imageViewStab: UIImageView = {
        let imageViewStab = UIImageView()
        imageViewStab.image = UIImage(named: ConstantsStatisticVC.imageNothingFound)
        
        return imageViewStab
    }()
    
    private lazy var lableTextStab: UILabel = {
        let lableTextStab = UILabel()
        lableTextStab.text = ConstantsStatisticVC.labelStubStatisticsText
        lableTextStab.font = ConstantsStatisticVC.fontLabelTextStub
        
        return lableTextStab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StatisticsViewModel()
        showStabView(flag: viewModel?.getIsTracker())
        bind()
        cardStatysticsView.setCount(count: viewModel?.getCountTrackerComplet() ?? 0)
        view.backgroundColor = .white
        setupSubView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorderGradient(view: cardStatysticsView,
                          colors: [UIColor.redGradient.cgColor,
                                   UIColor.greenGradient.cgColor,
                                   UIColor.blueGradient.cgColor],
                          borderWidth: ConstantsStatisticVC.borderWidth,
                          startPoint: CGPoint.centerLeft,
                          endPoint: CGPoint.centerRight,
                          cornerRadius: ConstantsStatisticVC.borderRadius)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showStabView(flag: viewModel?.getIsTracker())
    }
}

private extension StatisticsViewController {
    func bind() {
        guard let viewModel = viewModel as? StatisticsViewModel else { return }
        viewModel.$countTrackerComplet.bind { [weak self] count in
            guard let self else { return }
            cardStatysticsView.setCount(count: count ?? 0)
        }
    }
    
    func addBorderGradient(view: UIView,
                                   colors: [CGColor],
                                   borderWidth: CGFloat,
                                   startPoint: CGPoint,
                                   endPoint: CGPoint,
                                   cornerRadius: CGFloat)
    {
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        shape.path = path
        shape.strokeColor = UIColor.blackDay.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        view.layer.addSublayer(gradient)
    }
    
    func showStabView(flag: Bool?) {
        guard let flag else {
            imageViewStab.isHidden = false
            lableTextStab.isHidden = false
            cardStatysticsView.isHidden = true
            return }
        imageViewStab.isHidden = !flag
        lableTextStab.isHidden = !flag
        cardStatysticsView.isHidden = flag
    }
    
    func setupSubView() {
        setupLabelHeader()
        setupStabView()
        setupCardStatysticsView()
    }
    
    func setupLabelHeader() {
        view.addSubview(labelHeader)
        NSLayoutConstraint.activate([
            labelHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
    
    func setupStabView() {
        [imageViewStab, lableTextStab].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            imageViewStab.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewStab.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lableTextStab.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lableTextStab.topAnchor.constraint(equalTo: imageViewStab.bottomAnchor, constant: 10)
        ])
    }
    
    func setupCardStatysticsView() {
        view.addSubview(cardStatysticsView)
        NSLayoutConstraint.activate([
            cardStatysticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardStatysticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardStatysticsView.topAnchor.constraint(equalTo: labelHeader.bottomAnchor, constant: 77),
            cardStatysticsView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
