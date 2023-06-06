//
//  LocalOrderSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class LocalOrderSaver: OrderSaver {
    enum SaveError: Error {
        case failed
    }
    
    private let storeSaver: OrderStoreSaver
    
    init(storeSaver: OrderStoreSaver) {
        self.storeSaver = storeSaver
    }
    
    func save(order: Order, completion: @escaping (OrderSaver.Result) -> Void) {
        storeSaver.insert(order: order.toLocal()) { error in
            guard error == nil else {
                return completion(.some(SaveError.failed))
            }
            completion(.none)
        }
    }
}

private extension Order {
    func toLocal() -> LocalOrder {
        return LocalOrder(items: items.toLocal(), price: price, timestamp: timestamp)
    }
}

private extension Array where Element == OrderItem {
    func toLocal() -> [LocalOrderItem] {
        return map { LocalOrderItem(name: $0.name, description: $0.description, price: $0.price, timestamp: $0.timestamp, imageName: $0.imageName) }
    }
}
