//
//  DocumentEntity+CoreDataProperties.swift
//  
//
//  Created by Siddanathi Rohith on 18/03/24.
//
//

import Foundation
import CoreData


extension DocumentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentEntity> {
        return NSFetchRequest<DocumentEntity>(entityName: "DocumentEntity")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var driveType: String?
    @NSManaged public var folderId: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isPin: Bool
    @NSManaged public var isSynced: Bool
    @NSManaged public var name: String?
    @NSManaged public var tagId: UUID?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var folder: FolderEntity?
    @NSManaged public var image: NSSet?

}

// MARK: Generated accessors for image
extension DocumentEntity {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: ImageEntity)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: ImageEntity)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}
