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
    var isEmptyCartStateOnChanged: Observable<String>?
    
    var isItemDeleteStateOnChanged: Observable<Void>?
    var isItemDeleteErrorStateOnChanged: Observable<String>?
    
    var checkoutHandler: Observable<[Item]>?
    
    private let cartLoader: CartItemsLoader
    private let cartDeleter: CartItemDeleter
    
    init(cartLoader: CartItemsLoader, cartDeleter: CartItemDeleter) {
        self.cartLoader = cartLoader
        self.cartDeleter = cartDeleter
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
    
    func deleteCartItem(with cellViewModel: CartCellViewModel) {
        cartDeleter.delete(item: cellViewModel.item) { [weak self] error in
            if let _ = error {
                self?.isItemDeleteErrorStateOnChanged?(ItemListErrorMessage.deleteCartItem.rawValue)
            } else {
                self?.isItemDeleteStateOnChanged?(())
            }
        }
    }
    
    func goToCheckout(with cellViewModels: [CartCellViewModel]) {
        if cellViewModels.isEmpty {
            isEmptyCartStateOnChanged?(ItemListErrorMessage.noSelectedItemsInCart.rawValue)
            return
        }
        checkoutHandler?(cellViewModels.map { $0.item })
    }
}
