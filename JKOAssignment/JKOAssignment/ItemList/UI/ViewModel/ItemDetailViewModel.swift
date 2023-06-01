//
//  ItemDetailViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

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
                self?.isCartSavingErrorStateOnChanged?(ItemListErrorMessage.addToCart.rawValue)
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
