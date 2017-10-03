//
//  Item.swift
//  NewApp
//
//  Created by Sowmya on 8/26/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Item {
    
    
    let key: String
    let title: String
    let price: Double
    let image: String?
    let ref: DatabaseReference?
    let addedBy: String?
    
    init(title: String, price: Double, image: String, addedBy: String, key: String = "") {
        self.key = key
        self.title = title
        self.price = price
        self.image = image
       self.addedBy = addedBy
        self.ref = nil
    }
    
    init(dictionary: [String:Any], key: String) {
        self.key = key
        title = dictionary["title"] as! String
        price = dictionary["price"] as! Double
        image = dictionary["image"] as? String
        addedBy = dictionary["addedBy"] as? String
        ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        title = snapshotValue["title"] as! String
        price = snapshotValue["price"] as! Double
        image = snapshotValue["image"] as? String
        addedBy = snapshotValue["addedBy"] as? String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "title": title,
            "price": price,
            "image": image!,
            "addedBy": addedBy!
        ]
    }
 
}
