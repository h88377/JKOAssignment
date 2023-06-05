//
//  NullStore.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class NullStore: CartItemStoreSaver, CartItemsStoreLoader, OrderStoreSaver {
    func insert(_ item: LocalItem, completion: @escaping (CartItemStoreSaver.Result) -> Void) {}
    func retrieve(completion: @escaping (CartItemsStoreLoader.Result) -> Void) {}
    func insert(order: Order, completion: @escaping (OrderStoreSaver.Result) -> Void) {}
}
