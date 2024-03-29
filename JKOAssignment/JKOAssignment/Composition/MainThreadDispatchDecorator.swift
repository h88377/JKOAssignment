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

// MARK: - Item

extension MainThreadDispatchDecorator: ItemLoader where T == ItemLoader {
    func load(with condition: ItemRequestCondition, completion: @escaping (ItemLoader.Result) -> Void) {
        decoratee.load(with: condition) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainThreadDispatchDecorator: CartItemSaver where T == CartItemSaver {
    func save(item: Item, completion: @escaping (CartItemSaver.Result) -> Void) {
        decoratee.save(item: item) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainThreadDispatchDecorator: CartItemLoader where T == CartItemLoader {
    func loadItems(completion: @escaping (CartItemLoader.Result) -> Void) {
        decoratee.loadItems { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainThreadDispatchDecorator: CartItemDeleter where T == CartItemDeleter {
    func delete(item: Item, completion: @escaping (CartItemDeleter.Result) -> Void) {
        decoratee.delete(item: item) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

// MARK: - Order

extension MainThreadDispatchDecorator: OrderSaver where T == OrderSaver {
    func save(order: Order, completion: @escaping (OrderSaver.Result) -> Void) {
        decoratee.save(order: order) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainThreadDispatchDecorator: OrderLoader where T == OrderLoader {
    func loadOrders(before date: Date, completion: @escaping (OrderLoader.Result) -> Void) {
        decoratee.loadOrders(before: date) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
