//
//  ItemListViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

struct Item: Hashable {
    let name: String
    let description: String
    let price: Int
    let timestamp: Date
    let imageName: String
}

struct ItemRequestCondition {
    let page: Int
}

final class ItemListCell: UICollectionViewCell {
    static let identifier = "\(ItemListCell.self)"
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let priceLabel = UILabel()
    let imageView = UIImageView()
}

class ItemListViewController: UICollectionViewController {
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Item> = {
        .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier, for: indexPath) as? ItemListCell else { return UICollectionViewCell() }
            
            cell.nameLabel.text = item.name
            cell.descriptionLabel.text = item.description
            cell.priceLabel.text = String(item.price)
            cell.imageView.image = UIImage(systemName: item.imageName)
            return cell
        }
    }()
    
    private var itemsSection: Int { return 0 }
    
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
        
        setUpBindings()
        loadItems()
    }
    
    private func setUpBindings() {
        collectionView.refreshControl = binded(refreshView: UIRefreshControl())
        
        viewModel.isItemsStateOnChanged = { [weak self] items in
            self?.set(items)
        }
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
    
    private func set(_ newItems: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([itemsSection])
        snapshot.appendItems(newItems, toSection: itemsSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
