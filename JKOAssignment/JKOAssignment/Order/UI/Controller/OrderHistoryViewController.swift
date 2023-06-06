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
    
    private lazy var dataSource: UITableViewDiffableDataSource<OrderHistoryCellSectionViewModel, OrderHistoryCellItemViewModel> = {
        .init(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryCell.identifier, for: indexPath) as? OrderHistoryCell else { return UITableViewCell() }
            
            cell.priceLabel.text = viewModel.priceText
            cell.nameLabel.text = viewModel.nameText
            cell.itemImageView.image = UIImage(systemName: viewModel.imageName)
            return cell
        }
    }()
    
    private let viewModel: OrderHistoryViewModel
    
    init(viewModel: OrderHistoryViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
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
    
    func set(_ sections: [OrderHistoryCellSectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<OrderHistoryCellSectionViewModel, OrderHistoryCellItemViewModel>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.itemViewModels, toSection: section)
        }
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
        tableView.backgroundColor = .systemGray6
        tableView.register(OrderHistoryCell.self, forCellReuseIdentifier: OrderHistoryCell.identifier)
        tableView.register(OrderHistoryFooterView.self, forHeaderFooterViewReuseIdentifier: OrderHistoryFooterView.identifier)
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderHistoryFooterView.identifier) as? OrderHistoryFooterView else { return nil }
        
        let section = dataSource.sectionIdentifier(for: section)
        footerView.timestampLabel.text = section?.timestampText
        footerView.priceLabel.text = section?.priceText
        return footerView
    }
}
