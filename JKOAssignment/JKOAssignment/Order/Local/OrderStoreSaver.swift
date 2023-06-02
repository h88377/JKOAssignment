//
//  OrderStoreSaver.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

protocol OrderStoreSaver {
    typealias Result = Error?
    
    func insert(order: Order, completion: @escaping (Result) -> Void)
}
