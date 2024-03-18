//import Foundation
//import SwiftData
//import CoreData
//
//@Model // Assuming this is custom or part of a specific framework you're using.
//class Folder {
//    var id: String
//    var name: String
//    var updatedDate: Date
//    var createdDate: Date
//    var isSyced: Bool
//    var isFavourite: Bool
//    var isPin: Bool
//    var driveType: String
//    var fileCount: Int
//
//    // Existing initializer
//    init(id: String, name: String, updatedDate: Date, createdDate: Date, isSyced: Bool, isFavourite: Bool, isPin: Bool, driveType: String, fileCount: Int) {
//        self.id = id
//        self.name = name
//        self.updatedDate = updatedDate
//        self.createdDate = createdDate
//        self.isSyced = isSyced
//        self.isFavourite = isFavourite
//        self.isPin = isPin
//        self.driveType = driveType
//        self.fileCount = fileCount
//    }
//   
//    // Initializer to create a Folder instance from a FolderEntity
//    convenience init(entity: FolderEntity) {
//        self.init(
//            id: entity.id?.uuidString ?? UUID().uuidString,
//            name: entity.name ?? "",
//            updatedDate: entity.updatedDate ?? Date.now,
//            createdDate: entity.createdDate ?? Date.now,
//            isSyced: entity.isSyced,
//            isFavourite: entity.isFavourite,
//            isPin: entity.isPin,
//            driveType: entity.driveType ?? "",
//            fileCount: Int(entity.fileCount)
//        )
//    }
//}
