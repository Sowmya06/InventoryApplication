//
//  VendorTableViewCell.swift
//  InventoryApp
//
//  Created by Sowmya on 8/14/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit

class VendorTableViewCell: UITableViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bookImage: UIImageView!

    func configureCell(item: Book) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        bookImage.image = item.image as? UIImage
        
    }

}
