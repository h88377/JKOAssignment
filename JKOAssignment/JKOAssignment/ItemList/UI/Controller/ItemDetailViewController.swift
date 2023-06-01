//
//  ItemDetailViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class ItemDetailViewModel {
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
        return "$ \(item.price)"
    }
    
    var imageName: String {
        return item.imageName
    }
}

final class ItemDetailViewController: UIViewController {
    private let viewModel: ItemDetailViewModel
    
    init(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
