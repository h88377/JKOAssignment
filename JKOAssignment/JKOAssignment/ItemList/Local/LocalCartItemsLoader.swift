//
//  LocalCartItemsLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

protocol CartItemsStoreLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func retrieve(completion: @escaping (Result) -> Void)
}

final class LocalCartItemsLoader: CartItemsLoader {
    enum LoadError: Swift.Error {
        case failed
    }
    
    private let storeLoader: CartItemsStoreLoader
    
    init(storeLoader: CartItemsStoreLoader) {
        self.storeLoader = storeLoader
    }
    
    func loadItems(completion: @escaping (CartItemsLoader.Result) -> Void) {
        storeLoader.retrieve { result in
            switch result {
            case let .success(items):
                completion(.success(items))
                
            case .failure:
                completion(.failure(LoadError.failed))
            }
        }
    }
}
