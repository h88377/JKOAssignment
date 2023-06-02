//
//  OrderUIComposer.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import Foundation

final class OrderUIComposer {
    private init() {}
    
    static func composedCheckout(with items: [Item], orderSaver: OrderSaver) -> CheckoutViewController {
        let viewModel = CheckoutViewModel(items: items, orderSaver: orderSaver)
        let cellVMs = items.map { CheckoutCellViewModel(item: $0) }
        let controller = CheckoutViewController(viewModel: viewModel, cellViewModels: cellVMs)
        return controller
    }
}
