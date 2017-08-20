//
//  Users+CoreDataProperties.swift
//  InventoryApp
//
//  Created by Sowmya on 8/12/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var mobile: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var userType: String?

}
