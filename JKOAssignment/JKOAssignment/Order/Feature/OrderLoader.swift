//
//  OrderLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

protocol OrderLoader {
    typealias Result = Swift.Result<[Order], Error>
    
    func loadOrders(completion: (Result) -> Void)
}
