//
//  ItemDetailViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class ItemDetailViewModel {
    var isItemSaveLoadingStateOnChanged: Observable<Bool>?
    var isItemSavingStateOnChanged: Observable<Void>?
    var isItemSavingErrorStateOnChanged: Observable<String>?
    
    var checkoutHandler: Observable<Void>?
    
    private let id = UUID()
    private let item: Item
    private let itemSaver: ItemSaver
    
    init(item: Item, itemSaver: ItemSaver) {
        self.item = item
        self.itemSaver = itemSaver
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
        isItemSaveLoadingStateOnChanged?(true)
        itemSaver.save(item: item) { [weak self] error in
            self?.isItemSaveLoadingStateOnChanged?(false)
            
            guard error == nil else {
                self?.isItemSavingErrorStateOnChanged?(ItemListErrorMessage.addToCart.rawValue)
                return
            }
            self?.isItemSavingStateOnChanged?(())
        }
    }
    
    func goToCheckout() {
        checkoutHandler?(())
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
