//
//  OrderConstants.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

enum OrderErrorMessage: String {
    case checkout = "結帳失敗"
    case orderHistory = "加載訂單記錄失敗"
    case reachEndOrdersPage = "沒有更多訂單記錄囉"
}

enum OrderSuccessMessage: String {
    case checkout = "結帳成功"
}

enum OrderReminderMessage: String {
    case noOrder = "目前無訂單記錄喔"
}
