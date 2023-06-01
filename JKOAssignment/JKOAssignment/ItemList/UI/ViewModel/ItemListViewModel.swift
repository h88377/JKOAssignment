//
//  ItemListViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import Foundation

enum ErrorMessage: String {
    case loadItems = "無法連接至伺服器"
    case reachEndItemsPage = "沒有更多商品囉"
    case addToCart = "加入購物車失敗"
}

final class ItemListViewModel {
    var isItemsRefreshLoadingStateOnChanged: ((Bool) -> Void)?
    var isItemsRefreshingStateOnChanged: (([Item]) -> Void)?
    var isItemsRefreshingErrorStateOnChange: ((String) -> Void)?
    
    private let itemLoader: ItemLoader
    
    init(itemLoader: ItemLoader) {
        self.itemLoader = itemLoader
    }
    
    func loadItems() {
        isItemsRefreshLoadingStateOnChanged?(true)
        itemLoader.load(with: ItemRequestCondition(page: 0)) { [weak self] result in
            switch result {
            case let .success(items):
                self?.isItemsRefreshingStateOnChanged?(items)
                
            case .failure:
                self?.isItemsRefreshingErrorStateOnChange?(ErrorMessage.loadItems.rawValue)
            }
            self?.isItemsRefreshLoadingStateOnChanged?(false)
        }
    }
}
