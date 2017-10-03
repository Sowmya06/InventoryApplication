//
//  CustomerTableViewCell.swift
//  NewApp
//
//  Created by Sowmya on 9/14/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    var item: Item!
    var onButtonTapped : (() -> Void)? = nil
    var onHeartTapped : (() -> Void)? = nil
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    
    @IBAction func cartButtonPressed(_ sender: UIButton) {
        //cartButton.isSelected = true
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    @IBAction func heartPressed(_ sender: Any) {
        heartButton.isSelected = true
        if let onHeartTapped = self.onHeartTapped {
            onHeartTapped()
        }
    }
    
    func configureCell(_ item: Item) {
        self.item = item
        title.text = item.title
        price.text = String(describing: item.price)
        
        if let imageUrl  = item.image {
            
            if imageCache.object(forKey: (imageUrl as AnyObject)) != nil {
                print("Cached image used, no need to download it")
                bookImage.image = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage
                
            }
            
            print("image not cache")
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    if let data = data, let downloadImage = UIImage(data: data) {
                        self.imageCache.setObject(downloadImage as AnyObject, forKey: imageUrl as AnyObject)
                        self.bookImage.image = downloadImage
                    }
                }
            }).resume()
            
        }
    }
    
}
