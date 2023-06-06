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
    private let dateFormatter: DateFormatter
    
    init(order: Order, dateFormatter: DateFormatter) {
        self.order = order
        self.dateFormatter = dateFormatter
    }
    
    var priceText: String {
        return "總價格：$ \(order.price)"
    }
    
    var timestampText: String {
        return dateFormatter.string(from: order.timestamp)
    }
    
    var itemViewModels: [OrderHistoryCellItemViewModel] {
        return order.items.map { OrderHistoryCellItemViewModel(item: $0) }
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
