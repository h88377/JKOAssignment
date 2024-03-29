//
//  OrderSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

protocol OrderSaver {
    typealias Result = Error?
    
    func save(order: Order, completion: @escaping (Result) -> Void)
}
