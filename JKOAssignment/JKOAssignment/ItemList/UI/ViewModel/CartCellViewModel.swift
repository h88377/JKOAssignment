//
//  CartCellViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class CartCellViewModel {
    private let id = UUID()
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var isSelected = true
    
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

extension CartCellViewModel: Hashable {
    static func == (lhs: CartCellViewModel, rhs: CartCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
