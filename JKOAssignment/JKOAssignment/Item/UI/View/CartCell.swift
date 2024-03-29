//
//  CartCell.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class CartCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var didCheckHandler: Observable<Bool>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        didCheckHandler = nil
    }
    
    private func setUpUI() {
        contentView.addSubviews([checkButton, itemImageView, nameLabel, priceLabel])
        
        let imageHightConstraint = itemImageView.heightAnchor.constraint(equalToConstant: 100)
        imageHightConstraint.priority = UILayoutPriority(999)
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            itemImageView.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
            imageHightConstraint,
            
            nameLabel.topAnchor.constraint(equalTo: itemImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor)
        ])
    }
    
    @objc private func check() {
        checkButton.isSelected = !checkButton.isSelected
        didCheckHandler?(checkButton.isSelected)
    }
}
