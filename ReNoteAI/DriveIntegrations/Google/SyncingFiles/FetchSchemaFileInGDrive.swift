//////
//////  FetchSchemaFileInGDrive.swift
//////  ReNoteAI
//////
//////  Created by Siddanathi Rohith on 01/03/24.
//////
////
//import Dependencies
//import Foundation
//import SwiftUI
//import SwiftData
//
//
//func fetchSchemaDetails(mainFolderID:String)  {
//    // List contents of the ReNoteAI folder to find schema.json
//    Task {
//        do {
//            let folderContents = try await GoogleAuthentication.shared.client.listFiles {
//                $0.query = "'\(mainFolderID)' in parents and trashed=false and name='schema.json'"
//                $0.spaces = []
//            }
//            
//            if let schemaFile = folderContents.files.first {
//                // Read the contents of schema.json
//                let jsonData = try await GoogleAuthentication.shared.client.getFileData(fileId: schemaFile.id) // Assuming this method exists and returns Data
//                // Assuming the jsonData is directly printable
//                if let json = String(data: jsonData, encoding: .utf8) {
//                    let jsonFormat:[String:Any]  =  try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : Any]
//                    let foldersOfCloud = jsonFormat["folders"] as! [String:Any]
//                    let keysOfFolders = foldersOfCloud.keys
//                    
//                    for eachKey in keysOfFolders {
//                        if !DataBaseManager.shared.folders.contains(where: { $0.id ==  eachKey as String  }) {
//                            if let eachFolder = foldersOfCloud[eachKey] as? [String: Any] {
//                                // Assuming you have a way to parse eachFolder dictionary to your Folder model
//                                let createdDate = Date(timeIntervalSince1970: eachFolder["createdDate"] as! TimeInterval )
//                                let updatedDate = Date(timeIntervalSince1970: eachFolder["updatedDate"] as! TimeInterval )
//
//                                let f = Folder(
//                                    id: eachFolder["id"] as? String ?? "",
//                                    name: eachFolder["name"] as? String ?? "",
//                                    updatedDate: updatedDate,
//                                    createdDate: createdDate,
//                                    isSyced: eachFolder["isSynced"] as? Bool ?? true,
//                                    isFavourite: eachFolder["isFavourite"] as? Bool ?? false,
//                                    isPin: eachFolder["isPin"] as? Bool ?? false,
//                                    driveType: eachFolder["driveType"] as? String ?? "",
//                                    fileCount: eachFolder["fileCount"] as? Int ?? 0
//                                )
//                                DataBaseManager.shared.modelContext?.insert(f)
//                            }
//                        }
//                        else {
//                            //TODO
//                            // update the folder
//                        }
//}
//                    
//                    let documentsOfCloud = jsonFormat["documents"] as! [String:Any]
//                    let keysOfDocuments = documentsOfCloud.keys
//                    
////                    for eachKey in keysOfDocuments{
////                        if !DataBaseManager.shared.documents.contains(where: { $0.id ==  eachKey as String  }) {
////                            if let eachDocument = documentsOfCloud[eachKey] as? [String: Any] {
////                                // Assuming you have a way to parse eachFolder dictionary to your Folder model
////                                let createdDate = Date(timeIntervalSince1970: eachDocument["createdDate"] as! TimeInterval )
////                                let updatedDate = Date(timeIntervalSince1970: eachDocument["updatedDate"] as! TimeInterval )
////                                
////                                let d = Document.init(
////                                    id: eachDocument["id"] as? String ?? "",
////                                    name: eachDocument["name"] as? String ?? "",
////                                    createdDate: createdDate,
////                                    updatedDate: updatedDate,
////                                    fileData: eachDocument["fileData"] as? Data ?? Data(),
////                                    isSynced: eachDocument["isSynced"] as? Bool ?? true,
////                                    isPin: eachDocument["isPin"] as? Bool ?? true,
////                                    isFavourite: eachDocument["isFavourite"] as? Bool ?? true,
////                                    folderId: eachDocument["folderId"] as? String ?? "",
////                                    tagId: eachDocument["tagId"] as? String ?? "",
////                                    openCount: eachDocument["openCount"] as? Int ?? 0,
////                                    localFilePathIos: eachDocument["localFilePathIos"] as? String ?? "",
////                                    localFilePathAndroid: eachDocument["localFilePathAndroid"] as? String ?? "",
////                                    driveType: eachDocument["driveType"] as? String ?? "",
////                                    fileExtension: eachDocument["fileExtension"] as? String ?? ""
////                                )
////                                DataBaseManager.shared.modelContext?.insert(d)
////                            }
////                        }
////                        else {
////                            //TODO Update document
////                        }
////                    }
//                    
//            
//
//
//                    
//                } else {
//                    print("Unable to decode jsonData to String")
//                }
//            } else {
//                print("schema.json does not exist within the ReNoteAI folder.")
//            }
//        } catch {
//            print("An error occurred while listing files: \(error)")
//        }
//    }
//}
//
//func fetchAllTags(tagID: String){
//    Task {
//        do {
//            let folderContents = try await GoogleAuthentication.shared.client.listFiles {
//                $0.query = "'\(tagID)' in parents and trashed=false and name='schema.json'"
//                $0.spaces = []
//            }
//            
//            if let schemaFile = folderContents.files.first {
//                // Read the contents of schema.json
//                let jsonData = try await GoogleAuthentication.shared.client.getFileData(fileId: schemaFile.id)
//                if let jsonFormat = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
//                    if let tagsOfCloud = jsonFormat["tags"] as? [String: Any] {
//                        for (tagId, tagInfo) in tagsOfCloud {
//                            if let tagDetails = tagInfo as? [String: Any],
//                               !DataBaseManager.shared.tags.contains(where: { $0.id == tagId }) {
//                                // Parse tag details
//                                let tagName = tagDetails["name"] as? String ?? "Unnamed Tag"
//                                let tagDescription = tagDetails["description"] as? String ?? "No Description"
//
//                                // Create and insert the new tag
//                                let newTag = Tag(id: tagId, name: tagName)
//                                DataBaseManager.shared.modelContext?.insert(newTag)
//                            }
//                        }
//                    }
//                    // Continue with folders and documents processing as before
//                }
//            } else {
//                print("schema.json does not exist within the ReNoteAI folder.")
//            }
//        } catch {
//            print("An error occurred while listing files: \(error)")
//        }
//    }
//}
