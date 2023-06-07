//
//  ItemLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import Foundation

protocol ItemLoader {
    typealias Result = Swift.Result<[Item], Error>
    
    func load(with condition: ItemRequestCondition, completion: @escaping (Result) -> Void)
}
