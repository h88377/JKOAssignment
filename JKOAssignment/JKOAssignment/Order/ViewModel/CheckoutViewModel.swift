//
//  CheckoutViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class CheckoutViewModel {
    var isOrderSaveLoadingStateOnChanged: Observable<Bool>?
    var isOrderSavingStateOnChanged: Observable<Void>?
    var isOrderSavingErrorStateOnChanged: Observable<String>?
    
    private let items: [Item]
    private let orderSaver: OrderSaver
    
    init(items: [Item], orderSaver: OrderSaver) {
        self.items = items
        self.orderSaver = orderSaver
    }
    
    func checkout() {
        let order = Order(
            items: items,
            price: items.reduce(0) { $0 + $1.price },
            timestamp: Date())
        
        isOrderSaveLoadingStateOnChanged?(true)
        orderSaver.save(order: order) { [weak self] error in
            self?.isOrderSaveLoadingStateOnChanged?(false)
            
            guard error == nil else {
                self?.isOrderSavingErrorStateOnChanged?(OrderErrorMessage.checkout.rawValue)
                return
            }
            self?.isOrderSavingStateOnChanged?(())
        }
    }
}
