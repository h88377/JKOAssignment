//
//  OrderHistoryPaginationViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/6.
//

import UIKit

final class OrderHistoryPaginationViewController {
    private(set) var isPaginating = false
    
    private let viewModel: OrderHistoryPaginationViewModel
    
    init(viewModel: OrderHistoryPaginationViewModel) {
        self.viewModel = viewModel
        self.setUpBinding()
    }
    
    func resetPage(with date: Date) {
        viewModel.resetPage(with: date)
    }
     
    func paginate(on scrollView: UIScrollView) {
        guard !isPaginating else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > (contentHeight - frameHeight) {
            viewModel.loadNextPage()
        }
    }
    
    private func setUpBinding() {
        viewModel.isOrdersPaginationLoadingStateOnChange = { [weak self] isPaginating in
            self?.isPaginating = isPaginating
        }
    }
}
