//
//  CartSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

protocol ItemSaver {
    typealias Result = Error?
    
    func save(item: Item, completion: @escaping (Result) -> Void)
}
