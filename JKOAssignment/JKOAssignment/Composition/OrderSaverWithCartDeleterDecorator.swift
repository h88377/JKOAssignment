//
//  OrderSaverWithCartDeleterDecorator.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

final class OrderSaverWithCartDeleterDecorator: OrderSaver {
    private let decoratee: OrderSaver
    private let cartDeleter: CartItemStoreDeleter
    
    init(decoratee: OrderSaver, cartDeleter: CartItemStoreDeleter) {
        self.decoratee = decoratee
        self.cartDeleter = cartDeleter
    }
    
    func save(order: Order, completion: @escaping (OrderSaver.Result) -> Void) {
        decoratee.save(order: order) { [weak self] error in
            if let error = error {
                completion(.some(error))
            } else {
                let localItems = order.items.map { $0.toLocalItem() }
                self?.cartDeleter.delete(items: localItems, completion: completion)
            }
        }
    }
}

private extension OrderItem {
    func toLocalItem() -> LocalItem {
        return LocalItem(name: name, description: description, price: price, timestamp: timestamp, imageName: imageName)
    }
}
