//
//  OrderHistoryItemView.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/6.
//

import UIKit

final class OrderHistoryHeaderView: UITableViewHeaderFooterView {
    static let identifier = "\(OrderHistoryHeaderView.self)"
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubviews([timestampLabel, priceLabel])
        
        NSLayoutConstraint.activate([
            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timestampLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: timestampLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(equalTo: timestampLabel.bottomAnchor)
        ])
    }
}
