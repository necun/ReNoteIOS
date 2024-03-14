//
//  DocumentEntity+CoreDataProperties.swift
//  
//
//  Created by Siddanathi Rohith on 12/03/24.
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
    @NSManaged public var fileData: Data?
    @NSManaged public var fileExtension: String?
    @NSManaged public var folderId: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isPin: Bool
    @NSManaged public var isSynced: Bool
    @NSManaged public var localFilePathAndroid: String?
    @NSManaged public var localFilePathIos: String?
    @NSManaged public var name: String?
    @NSManaged public var openCount: Int64
    @NSManaged public var tagId: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var folder: FolderEntity?

}
