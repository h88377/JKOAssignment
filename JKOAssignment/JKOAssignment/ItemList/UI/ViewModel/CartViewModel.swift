//
//  CartViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class CartViewModel {
    var isItemsLoadingStateOnChanged: Observable<Bool>?
    var isItemsStateOnChanged: Observable<[Item]>?
    var isItemsErrorStateOnChange: Observable<String>?
    var isNoItemsReminderStateOnChanged: Observable<String>?
    
    private let cartLoader: CartItemsLoader
    
    init(cartLoader: CartItemsLoader) {
        self.cartLoader = cartLoader
    }
    
    func loadCartItems() {
        isItemsLoadingStateOnChanged?(true)
        cartLoader.loadItems { [weak self] result in
            switch result {
            case let .success(items) where items.isEmpty:
                self?.isNoItemsReminderStateOnChanged?(ItemListReminderMessage.noItemsInCart.rawValue)
                
            case let .success(items):
                self?.isItemsStateOnChanged?(items)
                
            case .failure:
                self?.isItemsErrorStateOnChange?(ItemListErrorMessage.loadCart.rawValue)
            }
            self?.isItemsLoadingStateOnChanged?(false)
        }
    }
}
