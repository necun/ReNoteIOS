//
//  Document.swfit.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 14/02/24.
//

import Foundation
import SwiftData

enum StoragePlace: String, CaseIterable {
    case Google = "Google";
    case iCloud = "iCloud";
    case OneDrive = "OneDrive";
    case Local = "Local"
}


@Model
class Document {
    var id: String
    var name: String
    var createdDate: Date
    var updatedDate: Date = Date.now
    var fileData: Data
    var isSynced: Bool
    var isPin: Bool
    var isFavourite: Bool
    var folderId: String
    var tagId: String
    var openCount: Int
    var localFilePathIos: String
    var localFilePathAndroid: String
    var driveType: String
    var fileExtension: String

    init(id: String, name: String, createdDate: Date, updatedDate: Date, fileData: Data, isSynced: Bool, isPin: Bool, isFavourite: Bool, folderId: String, tagId: String, openCount: Int, localFilePathIos: String, localFilePathAndroid: String, driveType: String, fileExtension: String) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.fileData = fileData
        self.isSynced = isSynced
        self.isPin = isPin
        self.isFavourite = isFavourite
        self.folderId = folderId
        self.tagId = tagId
        self.openCount = openCount
        self.localFilePathIos = localFilePathIos
        self.localFilePathAndroid = localFilePathAndroid
        self.driveType = driveType
        self.fileExtension = fileExtension
    }
}
