//
//  CartViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

protocol CartItemsLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func loadItems(completion: @escaping (Result) -> Void)
}

final class CartViewModel {
    var isItemsLoadingStateOnChanged: Observable<Bool>?
    var isItemsStateOnChanged: Observable<[Item]>?
    var isItemsErrorStateOnChange: Observable<String>?
    var isNoItemsReminderStateOnChanged: Observable<String>?
    
    private let cartLoader: CartItemsLoader
    
    init(cartLoader: CartItemsLoader) {
        self.cartLoader = cartLoader
    }
    
    func loadCartItems() {
        isItemsLoadingStateOnChanged?(true)
        cartLoader.loadItems { [weak self] result in
            switch result {
            case let .success(items) where items.isEmpty:
                self?.isNoItemsReminderStateOnChanged?(ItemListReminderMessage.noItemsInCart.rawValue)
                
            case let .success(items):
                self?.isItemsStateOnChanged?(items)
                
            case .failure:
                self?.isItemsErrorStateOnChange?(ItemListErrorMessage.loadCart.rawValue)
            }
            self?.isItemsLoadingStateOnChanged?(false)
        }
    }
}

final class CartCell: UITableViewCell {
    static let identifier = "\(CartCell.self)"
    
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
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.isSelected = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubviews([checkButton, itemImageView, nameLabel, priceLabel])
        
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            itemImageView.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: itemImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor)
        ])
    }
}

final class CartViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("結算", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        loadCartItems()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubviews([tableView, checkoutButton])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    private func loadCartItems() {
        viewModel.loadCartItems()
    }
}
