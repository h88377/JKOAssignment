//
//  LocalCartItemsLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class LocalCartItemLoader: CartItemLoader {
    enum LoadError: Swift.Error {
        case failed
    }
    
    private let storeLoader: CartItemStoreLoader
    
    init(storeLoader: CartItemStoreLoader) {
        self.storeLoader = storeLoader
    }
    
    func loadItems(completion: @escaping (CartItemLoader.Result) -> Void) {
        storeLoader.retrieve { result in
            switch result {
            case let .success(items):
                completion(.success(items.toModel()))
                
            case .failure:
                completion(.failure(LoadError.failed))
            }
        }
    }
}

private extension Array where Element == LocalItem {
    func toModel() -> [Item] {
        return map { Item(name: $0.name, description: $0.description, price: $0.price, timestamp: $0.timestamp, imageName: $0.imageName) }
    }
}
