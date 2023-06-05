//
//  ItemStoreSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

struct LocalItem {
    let name: String
    let description: String
    let price: Int
    let timestamp: Date
    let imageName: String
}

protocol CartItemStoreSaver {
    typealias Result = Error?
    
    func insert(_ item: LocalItem, completion: @escaping (Result) -> Void)
}
