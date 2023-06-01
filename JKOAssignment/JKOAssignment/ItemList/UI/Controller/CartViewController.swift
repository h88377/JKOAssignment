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
