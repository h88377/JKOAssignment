//
//  CartItemsLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

protocol CartItemLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func loadItems(completion: @escaping (Result) -> Void)
}
