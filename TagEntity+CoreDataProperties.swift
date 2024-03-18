//
//  TagEntity+CoreDataProperties.swift
//  
//
//  Created by Siddanathi Rohith on 18/03/24.
//
//

import Foundation
import CoreData


extension TagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}
