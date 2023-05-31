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
    private let itemLoader: ItemLoader
    
    init(itemLoader: ItemLoader) {
        self.itemLoader = itemLoader
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
}
