//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Siddanathi Rohith on 18/03/24.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var userType: String?

}
