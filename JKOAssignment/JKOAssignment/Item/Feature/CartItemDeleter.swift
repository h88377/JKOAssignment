//
//  CartItemDeleter.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

protocol CartItemDeleter {
    typealias Result = Error?
    
    func delete(item: Item, completion: @escaping (Result) -> Void)
}
