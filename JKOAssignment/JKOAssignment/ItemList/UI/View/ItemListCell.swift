//
//  ItemListCell.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

final class ItemListCell: UICollectionViewCell {
    static let identifier = "\(ItemListCell.self)"
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let priceLabel = UILabel()
    let imageView = UIImageView()
}
