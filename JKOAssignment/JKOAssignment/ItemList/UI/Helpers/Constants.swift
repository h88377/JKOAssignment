//
//  Constants.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

enum ItemListErrorMessage: String {
    case loadItems = "無法連接至伺服器"
    case reachEndItemsPage = "沒有更多商品囉"
    case addToCart = "加入購物車失敗"
}

enum ItemListSuccessMessage: String {
    case addToCart = "加入成功"
}
