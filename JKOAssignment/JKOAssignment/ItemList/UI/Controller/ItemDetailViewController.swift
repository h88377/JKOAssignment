//
//  ItemDetailViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class ItemDetailViewController: UIViewController {
    
    // MARK: - Property
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let fadingView: FadingMessageView = {
        let view = FadingMessageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray3
        button.setTitle("加入購物車", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapAddToCart), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("立刻購買", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
        
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
    
    // MARK: - Life cycle
    
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
        setUpBindings()
        configureTableView()
        configureSnapshot()
    }
    
    // MARK: - Method
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemDetailViewModel>()
        snapshot.appendSections([itemSection])
        snapshot.appendItems([viewModel], toSection: itemSection)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubviews([tableView, addToCartButton, checkoutButton])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addToCartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            checkoutButton.leadingAnchor.constraint(equalTo: addToCartButton.trailingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = self.dataSource
        tableView.register(ItemDetailCell.self, forCellReuseIdentifier: ItemDetailCell.identifier)
        configureTableHeaderView()
    }
    
    private func configureTableHeaderView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: viewModel.imageName)
        
        tableView.tableHeaderView = imageView
    }
    
    private func setUpBindings() {
        viewModel.isItemSavingStateOnChanged = { [weak self] _ in
            guard let self = self else { return }
            
            self.fadingView.show(ItemListSuccessMessage.addToCart.rawValue, on: self.view)
        }
    }
    
    @objc private func didTapAddToCart() {
        viewModel.addToCart()
    }
    
    @objc private func didTapCheckout() {
        viewModel.goToCheckout()
    }
}

final class FadingMessageView: UIView {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    var isVisible: Bool {
        return alpha > 0
    }
    
    private var message: String? {
        didSet { messageLabel.text = message }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ message: String?, on view: UIView) {
        guard superview == nil else { return }
        
        self.message = message
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            heightAnchor.constraint(equalTo: widthAnchor)
        ])
        
        UIView.animate(
            withDuration: 1,
            animations: { self.alpha = 1 },
            completion: { isCompleted in
                if isCompleted { self.hide() }
            })
    }
    
    private func hide() {
        UIView.animate(
            withDuration: 1,
            animations: { self.alpha = 0},
            completion: { isCompleted in
                self.message = nil
                self.removeFromSuperview()
            })
    }
    
    private func setUpUI() {
        backgroundColor = .darkGray
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
