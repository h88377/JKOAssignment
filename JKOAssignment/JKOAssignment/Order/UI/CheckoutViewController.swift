//
//  CheckoutViewController.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import UIKit

final class CheckoutViewController: UIViewController {
    private let viewModel: CheckoutViewModel
    private let cellViewModels: [CheckoutCellViewModel]
    
    init(viewModel: CheckoutViewModel, cellViewModels: [CheckoutCellViewModel]) {
        self.viewModel = viewModel
        self.cellViewModels = cellViewModels
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
