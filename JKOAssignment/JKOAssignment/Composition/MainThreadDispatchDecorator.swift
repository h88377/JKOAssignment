//
//  MainThreadDispatchDecorator.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class MainThreadDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { completion() }
        }
        
        completion()
    }
}

extension MainThreadDispatchDecorator: ItemLoader where T == ItemLoader {
    func load(with condition: ItemRequestCondition, completion: @escaping (ItemLoader.Result) -> Void) {
        decoratee.load(with: condition) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
