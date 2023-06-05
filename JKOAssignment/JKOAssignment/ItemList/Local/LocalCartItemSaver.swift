//
//  LocalItemSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class LocalCartItemSaver: CartItemSaver {
    enum SaveError: Error {
        case failed
    }
    
    private let storeSaver: CartItemStoreSaver
    
    init(storeSaver: CartItemStoreSaver) {
        self.storeSaver = storeSaver
    }
    
    func save(item: Item, completion: @escaping (CartItemSaver.Result) -> Void) {
        storeSaver.insert(item.toLocal()) { error in
            guard error == nil else {
                return completion(.some(SaveError.failed))
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
