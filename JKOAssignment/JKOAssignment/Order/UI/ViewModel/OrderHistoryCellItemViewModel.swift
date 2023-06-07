//
//  OrderHistoryCellItemViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/6.
//

import Foundation

final class OrderHistoryCellItemViewModel {
    private let id = UUID()
    private let item: OrderItem
    
    init(item: OrderItem) {
        self.item = item
    }
    
    var nameText: String {
        return item.name
    }
    
    var priceText: String {
        return "$ \(item.price)"
    }
    
    var imageName: String {
        return item.imageName
    }
}

extension OrderHistoryCellItemViewModel: Hashable {
    static func == (lhs: OrderHistoryCellItemViewModel, rhs: OrderHistoryCellItemViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

