//
//  ItemListCellViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class ItemListCellViewModel {
    var selectHandler: Observable<Item>?
    
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
    
    func didSelect() {
        selectHandler?(item)
    }
}

extension ItemListCellViewModel: Hashable {
    static func == (lhs: ItemListCellViewModel, rhs: ItemListCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
