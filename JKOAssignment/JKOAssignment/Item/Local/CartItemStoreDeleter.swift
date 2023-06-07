//
//  CartItemStoreDeleter.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

protocol CartItemStoreDeleter {
    typealias Result = Error?
    
    func delete(items: [LocalItem], completion: @escaping (Result) -> Void)
}
