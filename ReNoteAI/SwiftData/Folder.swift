//
//  Folder.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 15/02/24.
//

import Foundation
import SwiftData

@Model
class Folder {
    var id: String
    var name: String
    var updatedDate: Date = Date.now
    var createdDate: Date
    var isSyced: Bool
    var isFavourite: Bool
    var isPin: Bool
    var driveType: String
    var fileCount: Int

    init(id: String, name: String, updatedDate: Date, createdDate: Date, isSyced: Bool, isFavourite: Bool, isPin: Bool, driveType: String,
         fileCount: Int) {
        self.id = id
        self.name = name
        self.updatedDate = updatedDate
        self.createdDate = createdDate
        self.isSyced = isSyced
        self.isFavourite = isFavourite
        self.isPin = isPin
        self.driveType = driveType
        self.fileCount = fileCount
    }
   
}




