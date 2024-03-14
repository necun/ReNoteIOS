//
//  CreateFolderInGDrive.swift
//  ReNoteAI
//
//  Created by Siddanathi Rohith on 01/03/24.
//

import Foundation


func createMainFolderInGDrive()  async {
    do {
        // Step 1: Create the main folder
        let dateText = Date().formatted(date: .complete, time: .complete)
        let folderData = try await GoogleAuthentication.shared.client.createFile(
            name: "ReNoteAI",
            spaces: "ReNote",
            mimeType: "application/vnd.google-apps.folder",
            parents: [],
            data: "Folder created at \(dateText)".data(using: .utf8)!
        )
        DataBaseManager.shared.mainFolderID = folderData.id
        DataBaseManager.shared.storeMainFolderID(fileID: folderData.id)
        
        // Step 2: Prepare the schema JSON data
        if let jsonData = schemaData() {
            // Assume createFile can also upload data to a specific folder by specifying `parents`
            _ = try await GoogleAuthentication.shared.client.createFile(
                name: "schema.json",
                spaces: "ReNote",
                mimeType: "application/json",
                parents: [folderData.id], // Specify the folder ID as the parent
                data: jsonData
            )
        }
    } catch {
        print("Failure: \(error.localizedDescription)")
    }
}

//func CreateSubFolderInGDrive(newFolderName: String) async {
//    if let mainFolderID = DataBaseManager.shared.mainFolderID {
//        do {
//            let dateText = Date().formatted(date: .complete, time: .complete)
//            let fileData = try await GoogleAuthentication.shared.client.createFile(
//                name: newFolderName,
//                spaces: "ReNote",
//                mimeType: "application/vnd.google-apps.folder",
//                parents: [mainFolderID],
//                data: "Hello, World!\nCreated at \(dateText)".data(using: .utf8)!
//            )
//            DataBaseManager.shared.createSubFolder(fileID: fileData.id, newFolderName: newFolderName)
//        } catch {
//            print("CreateFile failure",
//                  "error", "\(error)",
//                  "localizedDescription", "\(error.localizedDescription)"
//            )
//        }
//
//    }
//    
//}
//
func DeleteFolderInGDrive() {
    
}

func renameFolderInGDrive() {
    
}
