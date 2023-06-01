//
//  ItemListViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

final class ItemListCellViewModel {
    private let id = UUID()
    private let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var nameText: String {
        return item.name
    }
    
    var descriptionText: String {
        return item.description
    }
    
    var priceText: String {
        return String(item.price)
    }
    
    var imageName: String {
        return item.imageName
    }
}

extension ItemListCellViewModel: Hashable {
    static func == (lhs: ItemListCellViewModel, rhs: ItemListCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class ItemListViewController: UICollectionViewController {
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, ItemListCellViewModel> = {
        .init(collectionView: collectionView) { collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier, for: indexPath) as? ItemListCell else { return UICollectionViewCell() }
            
            cell.nameLabel.text = viewModel.nameText
            cell.descriptionLabel.text = viewModel.descriptionText
            cell.priceLabel.text = viewModel.priceText
            cell.imageView.image = UIImage(systemName: viewModel.imageName)
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
        
        collectionView.refreshControl = binded(refreshView: UIRefreshControl())
        loadItems()
    }
    
    func set(_ newItems: [ItemListCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemListCellViewModel>()
        snapshot.appendSections([itemsSection])
        snapshot.appendItems(newItems, toSection: itemsSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func binded(refreshView: UIRefreshControl) -> UIRefreshControl {
        viewModel.isItemsRefreshLoadingStateOnChanged = { [weak self] isLoading in
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
