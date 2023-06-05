//
//  LocalOrderLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

struct LocalOrderItem {
    let name: String
    let description: String
    let price: Int
    let timestamp: Date
    let imageName: String
}

final class LocalOrderLoader: OrderLoader {
    enum Error: Swift.Error {
        case failed
    }
    
    private let storeLoader: OrderStoreLoader
    
    init(storeLoader: OrderStoreLoader) {
        self.storeLoader = storeLoader
    }
    
    func loadOrders(completion: @escaping (OrderLoader.Result) -> Void) {
        storeLoader.retrieve { result in
            switch result {
            case let .success(localOrders):
                completion(.success(localOrders.toModel()))
                
            case .failure:
                completion(.failure(Error.failed))
            }
        }
    }
}

private extension Array where Element == LocalOrder {
    func toModel() -> [Order] {
        return map { Order(items: $0.items.toModel(), price: $0.price, timestamp: $0.timestamp) }
    }
}

private extension Array where Element == LocalOrderItem {
    func toModel() -> [Item] {
        return map { Item(name: $0.name, description: $0.description, price: $0.price, timestamp: $0.timestamp, imageName: $0.imageName) }
    }
}
