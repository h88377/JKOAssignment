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
    
    private let storeSaver: ItemStoreSaver
    
    init(storeSaver: ItemStoreSaver) {
        self.storeSaver = storeSaver
    }
    
    func save(item: Item, completion: @escaping (CartItemSaver.Result) -> Void) {
        storeSaver.insert(item) { error in
            guard error == nil else {
                return completion(.some(SaveError.failed))
            }
            completion(.none)
        }
    }
}
