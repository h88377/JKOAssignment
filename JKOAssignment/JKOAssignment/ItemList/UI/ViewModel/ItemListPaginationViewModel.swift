//
//  ItemListPaginationViewModel.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class ItemListPaginationViewModel {
    typealias Observable<T> = ((T) -> Void)
    
    var isItemsPaginationLoadingStateOnChange: Observable<Bool>?
    var isItemsPaginationStateOnChange: Observable<[Item]>?
    var isItemsPaginationErrorStateOnChange: Observable<String?>?
    
    private var currentPage = 0
    private let itemLoader: ItemLoader
    
    init(petLoader: ItemLoader) {
        self.itemLoader = petLoader
    }
    
    func resetPage() {
        currentPage = 0
    }
    
    func loadNextPage() {
        currentPage += 1
        isItemsPaginationLoadingStateOnChange?(true)
        itemLoader.load(with: ItemRequestCondition(page: currentPage)) { [weak self] result in
            switch result {
            case let .success(items) where items.isEmpty:
                self?.currentPage -= 1
                self?.isItemsPaginationErrorStateOnChange?(ErrorMessage.reachEndItemsPage.rawValue)
                
            case let .success(items):
                self?.isItemsPaginationStateOnChange?(items)
                
            case .failure:
                self?.currentPage -= 1
                self?.isItemsPaginationErrorStateOnChange?(ErrorMessage.loadItems.rawValue)
                
            }
            self?.isItemsPaginationLoadingStateOnChange?(false)
        }
    }
}
