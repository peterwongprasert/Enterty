//
//  User+CoreDataProperties.swift
//  Enterty
//
//  Created by PandaSan on 10/31/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
