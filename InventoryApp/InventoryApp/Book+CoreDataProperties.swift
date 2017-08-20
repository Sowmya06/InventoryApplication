//
//  Book+CoreDataProperties.swift
//  InventoryApp
//
//  Created by Sowmya on 8/12/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var image: NSObject?

}
