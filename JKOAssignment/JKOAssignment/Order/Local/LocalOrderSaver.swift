//
//  LocalOrderSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

protocol OrderStoreSaver {
    typealias Result = Error?
    
    func insert(order: Order, completion: @escaping (Result) -> Void)
}

final class LocalOrderSaver: OrderSaver {
    enum SaveError: Error {
        case failed
    }
    
    private let storeSaver: OrderStoreSaver
    
    init(storeSaver: OrderStoreSaver) {
        self.storeSaver = storeSaver
    }
    
    func save(order: Order, completion: @escaping (OrderSaver.Result) -> Void) {
        storeSaver.insert(order: order) { error in
            guard error == nil else {
                return completion(.some(SaveError.failed))
            }
            completion(.none)
        }
    }
}
