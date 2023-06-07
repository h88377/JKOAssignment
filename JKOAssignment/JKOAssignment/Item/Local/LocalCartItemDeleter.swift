//
//  LocalCartItemDeleter.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

final class LocalCartItemDeleter: CartItemDeleter {
    enum DeleteError: Error {
        case failed
    }
    
    private let storeDeleter: CartItemStoreDeleter
    
    init(storeDeleter: CartItemStoreDeleter) {
        self.storeDeleter = storeDeleter
    }
    
    func delete(item: Item, completion: @escaping (CartItemDeleter.Result) -> Void) {
        storeDeleter.delete(items: [item.toLocal()]) { error in
            guard error == nil else {
                return completion(.some(DeleteError.failed))
            }
            
            completion(.none)
        }
    }
}


private extension Item {
    func toLocal() -> LocalItem {
        return LocalItem(name: name, description: description, price: price, timestamp: timestamp, imageName: imageName)
    }
}
