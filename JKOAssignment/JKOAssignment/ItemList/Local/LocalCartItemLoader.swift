//
//  LocalCartItemsLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class LocalCartItemLoader: CartItemsLoader {
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
