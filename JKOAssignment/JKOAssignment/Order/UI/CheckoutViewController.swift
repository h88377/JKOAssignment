//
//  CheckoutViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    // MARK: - Property
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("提交訂單", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: CheckoutViewModel
    private let cellViewModels: [CheckoutCellViewModel]
    
    // MARK: - Life cycle
    
    init(viewModel: CheckoutViewModel, cellViewModels: [CheckoutCellViewModel]) {
        self.viewModel = viewModel
        self.cellViewModels = cellViewModels
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    // MARK: - Method
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubviews([tableView, priceLabel, checkoutButton])
    
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
