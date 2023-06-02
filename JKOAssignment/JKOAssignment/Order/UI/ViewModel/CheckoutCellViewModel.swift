//
//  CheckoutCellViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class CheckoutCellViewModel {
    private let id = UUID()
    private let item: Item
    
    init(item: Item) {
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
    
    var price: Int {
        return item.price
    }
}

extension CheckoutCellViewModel: Hashable {
    static func == (lhs: CheckoutCellViewModel, rhs: CheckoutCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
