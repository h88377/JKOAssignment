//
//  ItemListUIComposer.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import UIKit

final class ItemListUIComposer {
    private init() {}
    
    static func composedItemList(with itemLoader: ItemLoader, select: @escaping (Item) -> Void) -> ItemListViewController {
        let mainThreadItemLoader = MainThreadDispatchDecorator(decoratee: itemLoader)
        
        let paginationVM = ItemListPaginationViewModel(itemLoader: mainThreadItemLoader)
        let paginationVC = ItemListPaginationViewController(viewModel: paginationVM)
        
        let itemListVM = ItemListViewModel(itemLoader: mainThreadItemLoader)
        let itemListVC = ItemListViewController(viewModel: itemListVM, paginationController: paginationVC)
        
        paginationVM.isItemsPaginationStateOnChange = { [weak itemListVC] items in
            let cellVMs = items.map { item in
                let viewModel = ItemListCellViewModel(item: item)
                viewModel.selectHandler = select
                return viewModel
            }
            itemListVC?.append(cellVMs)
        }
        
        paginationVM.isItemsPaginationErrorStateOnChange = { [weak itemListVC] message in
            guard let itemListVC = itemListVC else { return }
            
            itemListVC.errorView.show(message, on: itemListVC.view)
        }
        
        itemListVM.isItemsRefreshingStateOnChanged = { [weak itemListVC] items in
            let cellVMs = items.map { item in
                let viewModel = ItemListCellViewModel(item: item)
                viewModel.selectHandler = select
                return viewModel
            }
            itemListVC?.set(cellVMs)
        }
        
        itemListVM.isItemsRefreshingErrorStateOnChange = { [weak itemListVC] message in
            guard let itemListVC = itemListVC else { return }
            
            itemListVC.errorView.show(message, on: itemListVC.view)
        }
        
        return itemListVC
    }
    
    static func composedItemDetail(with item: Item, itemSaver: CartItemSaver) -> ItemDetailViewController {
        let mainThreadItemSaver = MainThreadDispatchDecorator(decoratee: itemSaver)
        let itemDetailVM = ItemDetailViewModel(item: item, itemSaver: mainThreadItemSaver)
        let itemDetailVC = ItemDetailViewController(viewModel: itemDetailVM)
        return itemDetailVC
    }
}
