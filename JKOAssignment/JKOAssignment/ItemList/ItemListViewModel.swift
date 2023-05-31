//
//  ItemListViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import Foundation

final class ItemListViewModel {
    var isItemsLoadingStateOnChanged: ((Bool) -> Void)?
    var isItemsStateOnChanged: (([Item]) -> Void)?
    
    private let itemLoader: ItemLoader
    
    init(itemLoader: ItemLoader) {
        self.itemLoader = itemLoader
    }
    
    func loadItems() {
        isItemsLoadingStateOnChanged?(true)
        itemLoader.load(with: ItemRequestCondition(page: 0)) { [weak self] result in
            switch result {
            case let .success(items):
                self?.isItemsStateOnChanged?(items)
                
            case .failure:
                break
            }
            self?.isItemsLoadingStateOnChanged?(false)
        }
    }
}
