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
    
    private var currentPage = 0
    private var oldestOrder: Order?
    private let orderLoader: OrderLoader
    
    init(orderLoader: OrderLoader) {
        self.orderLoader = orderLoader
    }
    
    func resetPage() {
        currentPage = 0
    }
    
    func loadNextPage() {
        guard let oldestOrder = oldestOrder else { return }
        
        currentPage += 1
        isOrdersPaginationLoadingStateOnChange?(true)
        orderLoader.loadOrders(before: oldestOrder.timestamp) { [weak self] result in
            switch result {
            case let .success(orders) where orders.isEmpty:
                self?.currentPage -= 1
                self?.isOrdersPaginationErrorStateOnChange?(OrderErrorMessage.reachEndOrdersPage.rawValue)
                
            case let .success(orders):
                self?.isOrdersPaginationStateOnChange?(orders)
                
            case .failure:
                self?.currentPage -= 1
                self?.isOrdersPaginationErrorStateOnChange?(OrderErrorMessage.orderHistory.rawValue)
                
            }
            self?.isOrdersPaginationLoadingStateOnChange?(false)
        }
    }
}
