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
        setUpBindings()
        loadOrders()
    }
    
    private func setUpUI() {
        view.insertSubview(noOrdersReminder, belowSubview: tableView)
        
        NSLayoutConstraint.activate([
            noOrdersReminder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noOrdersReminder.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpBindings() {
        tableView.refreshControl = binded(refreshView: UIRefreshControl())
        
        viewModel.isEmptyOrderStateOnChanged = { [weak self] message in
            self?.noOrdersReminder.text = message
            self?.tableView.isHidden = true
        }
        
        viewModel.isOrdersRefreshingErrorStateOnChange = { [weak self] message in
            guard let self = self else { return }
            
            self.errorView.show(message, on: self.view)
        }
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
