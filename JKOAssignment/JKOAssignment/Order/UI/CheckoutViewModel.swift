//
//  CheckoutViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

struct Order {
    let items: [Item]
    let price: Int
    let timestamp: Date
}

protocol OrderSaver {
    typealias Result = Error?
    
    func save(order: Order, completion: @escaping (Result) -> Void)
}

final class CheckoutViewModel {
    private let orderSaver: OrderSaver
    
    init(orderSaver: OrderSaver) {
        self.orderSaver = orderSaver
    }
}
