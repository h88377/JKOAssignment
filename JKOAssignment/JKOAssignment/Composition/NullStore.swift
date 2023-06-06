//
//  NullStore.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class NullStore: CartItemStoreSaver, CartItemStoreLoader, CartItemStoreDeleter, OrderStoreSaver, OrderStoreLoader {
    func insert(_ item: LocalItem, completion: @escaping (CartItemStoreSaver.Result) -> Void) {}
    func retrieve(completion: @escaping (CartItemStoreLoader.Result) -> Void) {}
    func delete(items: [LocalItem], completion: @escaping (CartItemStoreDeleter.Result) -> Void) {}
    
    func insert(order: Order, completion: @escaping (OrderStoreSaver.Result) -> Void) {}
    func retrieve(before date: Date, completion: @escaping (OrderStoreLoader.Result) -> Void) {}
}
