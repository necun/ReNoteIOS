//
//  ImageEntity+CoreDataProperties.swift
//  
//
//  Created by Siddanathi Rohith on 19/03/24.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var documentId: UUID?
    @NSManaged public var driveType: String?
    @NSManaged public var fileData: Data?
    @NSManaged public var fileExtension: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isPin: Bool
    @NSManaged public var isSynced: Bool
    @NSManaged public var localFilePathAndroid: String?
    @NSManaged public var localFilePathIos: String?
    @NSManaged public var name: String?
    @NSManaged public var openCount: Int64
    @NSManaged public var tagId: UUID?
    @NSManaged public var upadatedDate: Date?
    @NSManaged public var googleDriveFileID: String?
    @NSManaged public var folderId: String?
    @NSManaged public var document: DocumentEntity?

}
