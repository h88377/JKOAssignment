//
//  CartDataSource.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/5.
//

import UIKit

final class CartDataSource: UITableViewDiffableDataSource<Int, CartCellViewModel> {
    private let deleteHandler: (CartCellViewModel) -> Void
    
    init(deleteHandler: @escaping (CartCellViewModel) -> Void, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<Int, CartCellViewModel>.CellProvider) {
        self.deleteHandler = deleteHandler
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cellViewModel = itemIdentifier(for: indexPath) else { return }
            
            deleteHandler(cellViewModel)
        }
    }
}
