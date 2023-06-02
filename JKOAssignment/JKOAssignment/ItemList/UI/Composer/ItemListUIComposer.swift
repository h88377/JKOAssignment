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
        let paginationVM = ItemListPaginationViewModel(itemLoader: itemLoader)
        let paginationVC = ItemListPaginationViewController(viewModel: paginationVM)
        
        let itemListVM = ItemListViewModel(itemLoader: itemLoader)
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
        return itemListVC
    }
    
    static func composedItemDetail(with item: Item, itemSaver: CartItemSaver) -> ItemDetailViewController {
        let itemDetailVM = ItemDetailViewModel(item: item, itemSaver: itemSaver)
        let itemDetailVC = ItemDetailViewController(viewModel: itemDetailVM)
        return itemDetailVC
    }
    
    static func composedCart(with cartLoader: CartItemsLoader, checkout: @escaping ([Item]) -> Void) -> CartViewController {
        let cartVM = CartViewModel(cartLoader: cartLoader)
        let cartVC = CartViewController(viewModel: cartVM)
        
        cartVM.isItemsStateOnChanged = { [weak cartVC] items in
            let cartCellVMs = items.map { CartCellViewModel(item: $0) }
            cartVC?.set(cartCellVMs)
        }
        cartVM.checkoutHandler = checkout
        return cartVC
    }
}
