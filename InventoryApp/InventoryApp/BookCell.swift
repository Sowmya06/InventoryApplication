//
//  BookCell.swift
//  InventoryApp
//
//  Created by Sowmya on 8/11/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    var onButtonTapped : (() -> Void)? = nil
    
    
    func configureCell(item: Book) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        bookImage.image = item.image as? UIImage
        
    }


    @IBAction func cartButtonPressed(_ sender: Any) {
        //let image = UIImage(named: "check")
        //cartButton.setImage(image, for: UIControlState.normal)
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
        //print("print")
    }
}
