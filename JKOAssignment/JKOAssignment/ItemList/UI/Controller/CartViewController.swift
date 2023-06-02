//
//  CartViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Property
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let errorView: FadingMessageView = {
        let view = FadingMessageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let noItemsReminder: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var loadingIndicator: UIRefreshControl = {
        let indicator = UIRefreshControl()
        indicator.addTarget(self, action: #selector(loadCartItems), for: .valueChanged)
        
        return indicator
    }()
    
    private(set) lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("結算", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CartCellViewModel> = {
        .init(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else { return UITableViewCell() }
            
            cell.nameLabel.text = viewModel.nameText
            cell.priceLabel.text = viewModel.priceText
            cell.itemImageView.image = UIImage(systemName: viewModel.imageName)
            cell.checkButton.isSelected = viewModel.isSelected
            cell.didCheckHandler = { isSelected in
                viewModel.isSelected = isSelected
            }
            return cell
        }
    }()
    
    private var cartSection: Int { return 0 }
    
    private let viewModel: CartViewModel
    
    // MARK: - Life cycle
    
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
        setUpBindings()
        tableView.dataSource = self.dataSource
        loadCartItems()
    }
    
    // MARK: - Method
    
    func set(_ newItems: [CartCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CartCellViewModel>()
        snapshot.appendSections([cartSection])
        snapshot.appendItems(newItems, toSection: cartSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubviews([tableView, checkoutButton])
        view.insertSubview(noItemsReminder, belowSubview: tableView)
        tableView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            noItemsReminder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noItemsReminder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.isItemsLoadingStateOnChanged = { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.beginRefreshing()
            } else {
                self?.loadingIndicator.endRefreshing()
            }
        }
        
        viewModel.isItemsErrorStateOnChange = { [weak self] message in
            guard let self = self else { return }
            
            self.errorView.show(message, on: self.view)
        }
        
        viewModel.isNoItemsReminderStateOnChanged = { [weak self] message in
            self?.noItemsReminder.text = message
        }
    }
    
    @objc private func loadCartItems() {
        viewModel.loadCartItems()
    }
}
