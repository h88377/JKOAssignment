//
//  OrderHistoryCellViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/6.
//

import Foundation

final class OrderHistoryCellSectionViewModel {
    private let id = UUID()
    private let order: Order
    
    init(order: Order) {
        self.order = order
    }
    
    var priceText: String {
        return "總價格：$ \(order.price)"
    }
    
    var itemsDetals: [(nameText: String, priceText: String, imageName: String)] {
        return order.items.map { ($0.name, "$ \($0.price)", $0.imageName) }
    }
}

extension OrderHistoryCellSectionViewModel: Hashable {
    static func == (lhs: OrderHistoryCellSectionViewModel, rhs: OrderHistoryCellSectionViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
