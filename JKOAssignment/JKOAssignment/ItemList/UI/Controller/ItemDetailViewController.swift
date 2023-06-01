//
//  ItemDetailViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class ItemDetailCell: UITableViewCell {
    static let identifier = "\(ItemDetailCell.self)"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

protocol CartSaver {
    typealias Result = Error?
    
    func save(item: Item, completion: @escaping (Result) -> Void)
}

final class ItemDetailViewModel {
    typealias Observable<T> = ((T) -> Void)
    
    var isCartSavingStateOnChanged: Observable<Void>?
    var isCartSavingErrorStateOnChanged: Observable<String>?
    
    private let id = UUID()
    private let item: Item
    private let cartSaver: CartSaver
    
    init(item: Item, cartSaver: CartSaver) {
        self.item = item
        self.cartSaver = cartSaver
    }
    
    var nameText: String {
        return item.name
    }
    
    var descriptionText: String {
        return item.description
    }
    
    var priceText: String {
        return "$ \(item.price)"
    }
    
    var imageName: String {
        return item.imageName
    }
    
    func addToCart() {
        cartSaver.save(item: item) { [weak self] error in
            guard error == nil else {
                self?.isCartSavingErrorStateOnChanged?(ErrorMessage.addToCart.rawValue)
                return
            }
            self?.isCartSavingStateOnChanged?(())
        }
    }
}

extension ItemDetailViewModel: Hashable {
    static func == (lhs: ItemDetailViewModel, rhs: ItemDetailViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class ItemDetailViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("加入購物車", for: .normal)
        button.addTarget(self, action: #selector(didTapAddToCart), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("立刻購買", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, ItemDetailViewModel> = {
        .init(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailCell.identifier, for: indexPath) as? ItemDetailCell else { return UITableViewCell() }
            
            cell.nameLabel.text = viewModel.nameText
            cell.descriptionLabel.text = viewModel.descriptionText
            cell.priceLabel.text = viewModel.priceText
            return cell
        }
    }()
    
    private var itemSection: Int { return 0 }
    
    private let viewModel: ItemDetailViewModel
    
    init(viewModel: ItemDetailViewModel) {
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
    }
    
    func set(_ newItem: ItemDetailViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemDetailViewModel>()
        snapshot.appendSections([itemSection])
        snapshot.appendItems([newItem], toSection: itemSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpUI() {
        view.addSubviews([tableView, addToCartButton, checkoutButton])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            checkoutButton.leadingAnchor.constraint(equalTo: addToCartButton.trailingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = self.dataSource
        tableView.register(ItemDetailCell.self, forCellReuseIdentifier: ItemDetailCell.identifier)
    }
    
    @objc private func didTapAddToCart() {
        viewModel.addToCart()
    }
}
