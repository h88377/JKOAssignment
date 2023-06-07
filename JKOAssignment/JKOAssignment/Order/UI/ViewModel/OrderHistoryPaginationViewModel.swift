//
//  OrderHistoryPaginationViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/6.
//

import Foundation

final class OrderHistoryPaginationViewModel {
    var isOrdersPaginationLoadingStateOnChange: Observable<Bool>?
    var isOrdersPaginationStateOnChange: Observable<[Order]>?
    var isOrdersPaginationErrorStateOnChange: Observable<String>?
    
    private var currentDate = Date()
    private let orderLoader: OrderLoader
    
    init(orderLoader: OrderLoader) {
        self.orderLoader = orderLoader
    }
    
    func resetPage(with date: Date) {
        currentDate = date
    }
    
    func loadNextPage() {
        isOrdersPaginationLoadingStateOnChange?(true)
        orderLoader.loadOrders(before: currentDate) { [weak self] result in
            switch result {
            case let .success(orders) where orders.isEmpty:
                self?.isOrdersPaginationErrorStateOnChange?(OrderErrorMessage.reachEndOrdersPage.rawValue)
                
            case let .success(orders):
                let lastIndex = orders.count - 1
                self?.currentDate = orders[lastIndex].timestamp
                self?.isOrdersPaginationStateOnChange?(orders)
                
            case .failure:
                self?.isOrdersPaginationErrorStateOnChange?(OrderErrorMessage.orderHistory.rawValue)
                
            }
            self?.isOrdersPaginationLoadingStateOnChange?(false)
        }
    }
}
