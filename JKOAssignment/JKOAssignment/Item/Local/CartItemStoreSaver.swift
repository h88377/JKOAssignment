//
//  ItemStoreSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

protocol CartItemStoreSaver {
    typealias Result = Error?
    
    func insert(_ item: LocalItem, completion: @escaping (Result) -> Void)
}
