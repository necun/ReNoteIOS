//
//  FolderEntity+CoreDataProperties.swift
//  
//
//  Created by Siddanathi Rohith on 12/03/24.
//
//

import Foundation
import CoreData


extension FolderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderEntity> {
        return NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var driveType: String?
    @NSManaged public var fileCount: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isPin: Bool
    @NSManaged public var isSyced: Bool
    @NSManaged public var name: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var document: NSSet?

}

// MARK: Generated accessors for document
extension FolderEntity {

    @objc(addDocumentObject:)
    @NSManaged public func addToDocument(_ value: DocumentEntity)

    @objc(removeDocumentObject:)
    @NSManaged public func removeFromDocument(_ value: DocumentEntity)

    @objc(addDocument:)
    @NSManaged public func addToDocument(_ values: NSSet)

    @objc(removeDocument:)
    @NSManaged public func removeFromDocument(_ values: NSSet)

}
