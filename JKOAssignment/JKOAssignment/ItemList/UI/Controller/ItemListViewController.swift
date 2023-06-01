//
//  ItemListViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

final class ItemListPaginationViewModel {
    typealias Observable<T> = ((T) -> Void)
    
    var isItemsPaginationLoadingStateOnChange: Observable<Bool>?
    var isItemsPaginationStateOnChange: Observable<[Item]>?
    var isItemsPaginationErrorStateOnChange: Observable<String?>?
    
    private var currentPage = 0
    private let itemLoader: ItemLoader
    
    init(petLoader: ItemLoader) {
        self.itemLoader = petLoader
    }
    
    func resetPage() {
        currentPage = 0
    }
    
    func loadNextPage() {
        currentPage += 1
        isItemsPaginationLoadingStateOnChange?(true)
        itemLoader.load(with: ItemRequestCondition(page: currentPage)) { [weak self] result in
            switch result {
            case let .success(items) where items.isEmpty:
                self?.currentPage -= 1
                self?.isItemsPaginationErrorStateOnChange?(ErrorMessage.reachEndItemsPage.rawValue)
                
            case let .success(items):
                self?.isItemsPaginationStateOnChange?(items)
                
            case .failure:
                self?.currentPage -= 1
                self?.isItemsPaginationErrorStateOnChange?(ErrorMessage.loadItems.rawValue)
                
            }
            self?.isItemsPaginationLoadingStateOnChange?(false)
        }
    }
}

final class ItemListPaginationViewController {
    private(set) var isPaginating = false
    
    private let viewModel: ItemListPaginationViewModel
    
    init(viewModel: ItemListPaginationViewModel) {
        self.viewModel = viewModel
        self.setUpBinding()
    }
    
    func resetPage() {
        viewModel.resetPage()
    }
     
    func paginate(on scrollView: UIScrollView) {
        guard !isPaginating else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > (contentHeight - frameHeight) {
            viewModel.loadNextPage()
        }
    }
    
    private func setUpBinding() {
        viewModel.isItemsPaginationLoadingStateOnChange = { [weak self] isPaginating in
            self?.isPaginating = isPaginating
        }
    }
}

final class ItemListViewController: UICollectionViewController {
    private let viewModel: ItemListViewModel
    private let paginationController: ItemListPaginationViewController
        
    init(viewModel: ItemListViewModel, paginationController: ItemListPaginationViewController) {
        self.viewModel = viewModel
        self.paginationController = paginationController
        super.init(collectionViewLayout: .init())
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        loadItems()
    }
    
    func set(_ newItems: [ItemListCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemListCellViewModel>()
        snapshot.appendSections([itemsSection])
        snapshot.appendItems(newItems, toSection: itemsSection)
        dataSource.apply(snapshot, animatingDifferences: false)
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
}

// MARK: - UIScrollViewDelegate

extension ItemListViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let snapshot = dataSource.snapshot()
        guard collectionView.refreshControl?.isRefreshing != true, !snapshot.itemIdentifiers.isEmpty else { return }
            
        paginationController.paginate(on: scrollView)
    }
}
