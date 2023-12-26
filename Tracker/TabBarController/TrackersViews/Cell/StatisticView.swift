//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Григорий Машук on 25.12.23.
//

import UIKit

final class StatisticsView: UIView {
    private struct ConstantsStatistics {
        static let fontLabelHeader = UIFont.boldSystemFont(ofSize: 34)
        static let lableFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let cornerRadius = CGFloat(16)
        static let borderWidth = CGFloat(1)
    }
    
    private lazy var lableHeader: UILabel = {
        let lableHeader = UILabel()
        lableHeader.font = ConstantsStatistics.fontLabelHeader
        lableHeader.textColor = .blackDay
        lableHeader.translatesAutoresizingMaskIntoConstraints = false
        lableHeader.backgroundColor = .clear
        
        return lableHeader
    }()
    
    private lazy var secondaryTextLable: UILabel = {
        let secondaryTextLable = UILabel()
        secondaryTextLable.font =  ConstantsStatistics.lableFont
        secondaryTextLable.textColor = .blackDay
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return secondaryTextLable
    }()
    
    private lazy var lableStackView: UIStackView = {
        let lableStackView = UIStackView()
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        lableStackView.axis = .vertical
        
        return lableStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSteckView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatisticsView {
    private func setupSteckView() {
        addSubview(lableStackView)
        [lableHeader, secondaryTextLable].forEach {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            lableStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            lableStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            lableStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setCount(count: Int) {
        lableHeader.text = String(count)
    }
    
    func setSecondaryTextLable(text: String) {
        secondaryTextLable.text = text
    }
}
