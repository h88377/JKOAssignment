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
    
    private let currentDate: () -> Date
    private let orderLoader: OrderLoader
    
    init(currentDate: @escaping () -> Date, orderLoader: OrderLoader) {
        self.currentDate = currentDate
        self.orderLoader = orderLoader
    }
    
    func loadOrders() {
        isOrdersRefreshLoadingStateOnChanged?(true)
        orderLoader.loadOrders(before: currentDate()) { [weak self] result in
            switch result {
            case let .success(orders) where orders.isEmpty:
                self?.isEmptyOrderStateOnChanged?(OrderReminderMessage.noOrder.rawValue)
                
            case let .success(orders):
                self?.isOrdersRefreshingStateOnChanged?(orders)
                
            case .failure:
                self?.isOrdersRefreshingErrorStateOnChange?(OrderErrorMessage.orderHistory.rawValue)
            }
            self?.isOrdersRefreshLoadingStateOnChanged?(false)
        }
    }
}
