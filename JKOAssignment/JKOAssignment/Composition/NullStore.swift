//
//  NullStore.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class NullStore: CartItemStoreSaver, CartItemsStoreLoader {
    func insert(_ item: Item, completion: @escaping (CartItemStoreSaver.Result) -> Void) {}
    func retrieve(completion: @escaping (CartItemsStoreLoader.Result) -> Void) {}
}
