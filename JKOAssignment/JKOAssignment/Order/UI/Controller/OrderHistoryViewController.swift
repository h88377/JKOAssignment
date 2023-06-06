//
//  OrderHistoryViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import UIKit

final class OrderHistoryViewController: UITableViewController {
    let noOrdersReminder: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let errorView: FadingMessageView = {
        let view = FadingMessageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, OrderHistoryCellViewModel> = {
        .init(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryCell.identifier, for: indexPath) as? OrderHistoryCell else { return UITableViewCell() }
            
            var itemViews = [UIView]()
            viewModel.itemsDetals.forEach { detail in
                let detailView = OrderHistoryItemView()
                detailView.imageView.image = UIImage(systemName: detail.imageName)
                detailView.priceLabel.text = detail.priceText
                detailView.nameLabel.text = detail.nameText
                
                itemViews.append(detailView)
            }

            cell.configureItems(with: itemViews)
            return cell
        }
    }()
    
    private var ordersSection: Int { 0 }
    
    private let viewModel: OrderHistoryViewModel
    
    init(viewModel: OrderHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        configureTableView()
        setUpBindings()
        loadOrders()
    }
    
    func set(_ newItems: [OrderHistoryCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, OrderHistoryCellViewModel>()
        snapshot.appendSections([ordersSection])
        snapshot.appendItems(newItems, toSection: ordersSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpUI() {
        view.insertSubview(noOrdersReminder, belowSubview: tableView)
        
        NSLayoutConstraint.activate([
            noOrdersReminder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noOrdersReminder.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.isEmptyOrderStateOnChanged = { [weak self] message in
            self?.noOrdersReminder.text = message
            self?.tableView.isHidden = true
        }
        
        viewModel.isOrdersRefreshingErrorStateOnChange = { [weak self] message in
            guard let self = self else { return }
            
            self.errorView.show(message, on: self.view)
        }
    }
    
    private func configureTableView() {
        tableView.register(OrderHistoryCell.self, forCellReuseIdentifier: OrderHistoryCell.identifier)
        tableView.refreshControl = binded(refreshView: UIRefreshControl())
    }
    
    private func binded(refreshView: UIRefreshControl) -> UIRefreshControl {
        refreshView.addTarget(self, action: #selector(loadOrders), for: .valueChanged)
        
        viewModel.isOrdersRefreshLoadingStateOnChanged = { [weak self] isLoading in
            if isLoading {
                self?.tableView.refreshControl?.beginRefreshing()
            } else {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
        return refreshView
    }
    
    @objc private func loadOrders() {
        viewModel.loadOrders()
    }
}
