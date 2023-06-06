//
//  OrderHistoryCellViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/6.
//

import Foundation

final class OrderHistoryCellViewModel {
    private let id = UUID()
    private let order: Order
    
    init(order: Order) {
        self.order = order
    }
    
    var priceText: String {
        return "總價格：$ \(order.price)"
    }
    
    var items: (itemsNameText: [String], itemsPriceText: [String], itemsImageName: [String]) {
        return (order.items.map { $0.name },
                order.items.map { "$ \($0.price)" },
                order.items.map { $0.imageName })
        
    }
    
    var itemsDetals: [(nameText: String, priceText: String, imageName: String)] {
        return order.items.map { ($0.name, "$ \($0.price)", $0.imageName) }
    }
    
    var itemsNameText: [String] {
        return order.items.map { $0.name }
    }
    
    var itemsPriceText: [String] {
        return order.items.map { "$ \($0.price)" }
    }
    
    var itemsimageName: [String] {
        return order.items.map { $0.imageName }
    }
}

extension OrderHistoryCellViewModel: Hashable {
    static func == (lhs: OrderHistoryCellViewModel, rhs: OrderHistoryCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
