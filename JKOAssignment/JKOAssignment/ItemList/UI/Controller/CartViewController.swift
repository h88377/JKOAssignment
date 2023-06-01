//
//  CartViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

protocol CartItemsLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func loadItems(completion: @escaping (Result) -> Void)
}

final class CartViewModel {
    private let cartLoader: CartItemsLoader
    
    init(cartLoader: CartItemsLoader) {
        self.cartLoader = cartLoader
    }
}

final class CartViewController: UIViewController {
    private let viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
