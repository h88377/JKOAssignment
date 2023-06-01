//
//  ItemListUIComposer.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class ItemListUIComposer {
    private init() {}
    
    static func composedItemList(with itemLoader: ItemLoader) -> ItemListViewController {
        let mainThreadItemLoader = MainThreadDispatchDecorator(decoratee: itemLoader)
        
        let paginationVM = ItemListPaginationViewModel(itemLoader: mainThreadItemLoader)
        let paginationVC = ItemListPaginationViewController(viewModel: paginationVM)
        
        let itemListVM = ItemListViewModel(itemLoader: mainThreadItemLoader)
        let itemListVC = ItemListViewController(viewModel: itemListVM, paginationController: paginationVC)
        
        paginationVM.isItemsPaginationStateOnChange = { [weak itemListVC] items in
            let cellVMs = items.map(ItemListCellViewModel.init)
            itemListVC?.append(cellVMs)
        }
        
        paginationVM.isItemsPaginationErrorStateOnChange = { [weak itemListVC] message in
            itemListVC?.present(alert(with: message), animated: true)
        }
        
        itemListVM.isItemsRefreshingStateOnChanged = { [weak itemListVC] items in
            let cellVMs = items.map(ItemListCellViewModel.init)
            itemListVC?.set(cellVMs)
        }
        
        itemListVM.isItemsRefreshingErrorStateOnChange = { [weak itemListVC] message in
            itemListVC?.present(alert(with: message), animated: true)
        }
        
        return itemListVC
    }
    
    private static func alert(with message: String?) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default)
        alert.addAction(action)
        return alert
    }
}
