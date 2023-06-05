//
//  OrderStoreLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

protocol OrderStoreLoader {
    typealias Result = Swift.Result<[LocalOrder], Error>
    
    func retrieve(completion: @escaping (Result) -> Void)
}
