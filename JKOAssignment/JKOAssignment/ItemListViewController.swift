//
//  ItemListViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

struct Item {
    let name: String
    let description: String
    let price: Int
    let timestamp: Date
    let imageName: String
}

struct ItemRequestCondition {
    let page: Int
}

protocol ItemLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func load(with condition: ItemRequestCondition, completion: @escaping (Result) -> Void)
}

class ItemListViewModel {
    var isItemsLoadingStateOnChanged: ((Bool) -> Void)?
    
    private let itemLoader: ItemLoader
    
    init(itemLoader: ItemLoader) {
        self.itemLoader = itemLoader
    }
    
    func loadItems() {
        isItemsLoadingStateOnChanged?(true)
        itemLoader.load(with: ItemRequestCondition(page: 0)) { [weak self] _ in
            self?.isItemsLoadingStateOnChanged?(false)
        }
    }
}

class ItemListViewController: UICollectionViewController {
    private let viewModel: ItemListViewModel
        
    init(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = binded(refreshView: UIRefreshControl())
        loadItems()
    }
    
    private func binded(refreshView: UIRefreshControl) -> UIRefreshControl {
        viewModel.isItemsLoadingStateOnChanged = { [weak self] isLoading in
            if isLoading {
                self?.collectionView.refreshControl?.beginRefreshing()
            } else {
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
        refreshView.addTarget(self, action: #selector(loadItems), for: .valueChanged)
        
        return refreshView
    }
    
    @objc private func loadItems() {
        viewModel.loadItems()
    }
}
