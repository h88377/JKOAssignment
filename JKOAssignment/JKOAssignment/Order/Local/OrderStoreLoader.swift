//
//  OrderStoreLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

protocol OrderStoreLoader {
    typealias Result = Swift.Result<[LocalOrder], Error>
    
    func retrieve(before date: Date, completion: @escaping (Result) -> Void)
}
