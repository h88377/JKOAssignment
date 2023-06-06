//
//  Cell+Extension.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import UIKit

extension UITableViewCell {
    static var identifier: String { return String(describing: self) }
}

extension UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
}
