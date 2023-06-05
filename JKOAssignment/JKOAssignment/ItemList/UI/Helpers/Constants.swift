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
    case loadCart = "加載購物車失敗"
    case noSelectedItemsInCart = "請先選擇要結帳的商品"
    case deleteCartItem = "刪除購物車商品失敗"
}

enum ItemListSuccessMessage: String {
    case addToCart = "加入成功"
}

enum ItemListReminderMessage: String {
    case noItemsInCart = "目前購物車無商品喔"
}
