//
//  ItemListViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

final class ItemListViewController: UICollectionViewController {
    
    // MARK: - Property
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, ItemListCellViewModel> = {
        .init(collectionView: collectionView) { collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier, for: indexPath) as? ItemListCell else { return UICollectionViewCell() }
            
            cell.nameLabel.text = viewModel.nameText
            cell.priceLabel.text = viewModel.priceText
            cell.imageView.image = UIImage(systemName: viewModel.imageName)
            return cell
        }
    }()
    
    private var itemsSection: Int { return 0 }
    
    private let viewModel: ItemListViewModel
    private let paginationController: ItemListPaginationViewController
        
    
    // MARK: - Life cycle
    
    init(viewModel: ItemListViewModel, paginationController: ItemListPaginationViewController) {
        self.viewModel = viewModel
        self.paginationController = paginationController
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        loadItems()
    }
    
    // MARK: - Method
    
    func set(_ newItems: [ItemListCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemListCellViewModel>()
        snapshot.appendSections([itemsSection])
        snapshot.appendItems(newItems, toSection: itemsSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func append(_ newItems: [ItemListCellViewModel]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(newItems, toSection: itemsSection)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGray6
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        collectionView.dataSource = self.dataSource
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
        collectionView.refreshControl = binded(refreshView: UIRefreshControl())
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(290))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(290))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
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
        guard !paginationController.isPaginating else { return }
        
        paginationController.resetPage()
        viewModel.loadItems()
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> ItemListCellViewModel? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension ItemListViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellViewModel(at: indexPath)?.didSelect()
    }
}

// MARK: - UIScrollViewDelegate

extension ItemListViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let snapshot = dataSource.snapshot()
        guard collectionView.refreshControl?.isRefreshing != true, !snapshot.itemIdentifiers.isEmpty else { return }
            
        paginationController.paginate(on: scrollView)
    }
}
