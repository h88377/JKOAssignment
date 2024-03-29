//
//  OrderHistoryViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import UIKit

final class OrderHistoryViewController: UIViewController {
    
    // MARK: - Property
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(OrderHistoryCell.self, forCellReuseIdentifier: OrderHistoryCell.identifier)
        tableView.register(OrderHistoryFooterView.self, forHeaderFooterViewReuseIdentifier: OrderHistoryFooterView.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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
    private let paginationController: OrderHistoryPaginationViewController
    
    // MARK: - Life cycle
    
    init(viewModel: OrderHistoryViewModel, paginationController: OrderHistoryPaginationViewController) {
        self.viewModel = viewModel
        self.paginationController = paginationController
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
    
    // MARK: - Method
    
    func set(_ sections: [OrderHistoryCellSectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<OrderHistoryCellSectionViewModel, OrderHistoryCellItemViewModel>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.itemViewModels, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func append(_ sections: [OrderHistoryCellSectionViewModel]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.itemViewModels, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func resetPage(with date: Date) {
        paginationController.resetPage(with: date)
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.insertSubview(noOrdersReminder, belowSubview: tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
        tableView.delegate = self
        tableView.dataSource = self.dataSource
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
        guard !paginationController.isPaginating else { return }
        
        viewModel.loadOrders()
    }
}

// MARK: - UITableViewDelegate

extension OrderHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderHistoryFooterView.identifier) as? OrderHistoryFooterView else { return nil }
        
        let section = dataSource.sectionIdentifier(for: section)
        footerView.timestampLabel.text = section?.timestampText
        footerView.priceLabel.text = section?.priceText
        return footerView
    }
}

// MARK: - UIScrollViewDelegate

extension OrderHistoryViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard tableView.refreshControl?.isRefreshing != true else { return }

        paginationController.paginate(on: scrollView)
    }
}
