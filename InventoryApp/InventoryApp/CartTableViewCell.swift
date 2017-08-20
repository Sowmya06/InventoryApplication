//
//  CartTableViewCell.swift
//  InventoryApp
//
//  Created by Sowmya on 8/12/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    func configureCell(item: Book) {
        
        titleLabel.text = item.title
        priceLabel.text = "$\(item.price)"
        bookImage.image = item.image as? UIImage
        
    }
    }
