//
//  ItemListPaginationViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class ItemListPaginationViewController {
    private(set) var isPaginating = false
    
    private let viewModel: ItemListPaginationViewModel
    
    init(viewModel: ItemListPaginationViewModel) {
        self.viewModel = viewModel
        self.setUpBinding()
    }
    
    func resetPage() {
        viewModel.resetPage()
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
        viewModel.isItemsPaginationLoadingStateOnChange = { [weak self] isPaginating in
            self?.isPaginating = isPaginating
        }
    }
}
