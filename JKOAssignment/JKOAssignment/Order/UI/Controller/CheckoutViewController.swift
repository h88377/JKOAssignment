//
//  CheckoutViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    // MARK: - Property
    
    let indicator: LoadingIndicator = {
        let indicator = LoadingIndicator()
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CheckoutCell.self, forCellReuseIdentifier: CheckoutCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("提交訂單", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CheckoutCellViewModel> = {
        .init(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutCell.identifier, for: indexPath) as? CheckoutCell else { return UITableViewCell() }
            
            cell.nameLabel.text = viewModel.nameText
            cell.priceLabel.text = viewModel.priceText
            cell.itemImageView.image = UIImage(systemName: viewModel.imageName)
            return cell
        }
    }()
    
    private var checkoutSection: Int { 0 }
    
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
        setUpBindings()
        configureSnapshot()
    }
    
    // MARK: - Method
    
    private func setUpUI() {
        view.backgroundColor = .white
        priceLabel.text = "總價格：$ \(viewModel.price)"
        view.addSubviews([tableView, priceLabel, checkoutButton])
    
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            priceLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CheckoutCellViewModel>()
        snapshot.appendSections([checkoutSection])
        snapshot.appendItems(cellViewModels, toSection: checkoutSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpBindings() {
        viewModel.isOrderSaveLoadingStateOnChanged = { [weak self] isSaving in
            guard let self = self else { return }
            
            if isSaving {
                self.indicator.show(on: self.view)
            } else {
                self.indicator.hide()
            }
        }
    }
    
    @objc private func checkout() {
        viewModel.checkout()
    }
}
