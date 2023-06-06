//
//  OrderHistoryViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import Foundation

final class OrderHistoryViewModel {
    var isOrdersRefreshLoadingStateOnChanged: Observable<Bool>?
    var isOrdersRefreshingStateOnChanged: Observable<[Order]>?
    var isEmptyOrderStateOnChanged: Observable<String>?
    var isOrdersRefreshingErrorStateOnChange: Observable<String>?
    
    private let orderLoader: OrderLoader
    
    init(orderLoader: OrderLoader) {
        self.orderLoader = orderLoader
    }
    
    func loadOrders() {
        isOrdersRefreshLoadingStateOnChanged?(true)
        orderLoader.loadOrders(before: Date()) { [weak self] result in
            switch result {
            case let .success(orders) where orders.isEmpty:
                self?.isEmptyOrderStateOnChanged?(OrderReminderMessage.noOrder.rawValue)
                
            case let .success(orders):
                self?.isOrdersRefreshingStateOnChanged?(orders)
                
            case .failure:
                self?.isOrdersRefreshingErrorStateOnChange?("")
            }
            self?.isOrdersRefreshLoadingStateOnChanged?(false)
        }
    }
}
