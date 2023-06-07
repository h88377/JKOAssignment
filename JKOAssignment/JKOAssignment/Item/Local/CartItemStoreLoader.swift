//
//  CartItemsStoreLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

protocol CartItemStoreLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func retrieve(completion: @escaping (Result) -> Void)
}
