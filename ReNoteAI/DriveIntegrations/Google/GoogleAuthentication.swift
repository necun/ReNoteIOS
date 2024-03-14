//
//  GoogleAuthentication.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 24/02/24.
//

import Dependencies
import Foundation
import SwiftUI
import SwiftData
import GoogleDriveClient
import CoreData


class GoogleAuthentication: ObservableObject {
    
    static let shared = GoogleAuthentication()
    @Published var isSignedIn: Bool = false

    @Dependency(\.googleDriveClient) var client
       
    var googleSignInButton: some View {
        CustomSingleSignOnButton(
            backgroundColor: Color.blue,
            imageName: "Google",
            buttonText: "Sign in with Google Account",
            textColor: .white,
            buttonAction: {
                self.googleSignIn()
            }
        )
    }
    
    func googleSignIn() {
        Task {
            await GoogleAuthentication.shared.client.auth.signIn()
        }
    }
    
    
    func googleSignOut() {
        Task {
            await client.auth.signOut()
        }
    }
    
    func listFiles() {
        Task {
            do {
                let filesList = try await client.listFiles {
                    $0.query = "trashed=false and mimeType='application/vnd.google-apps.folder'"
                    $0.spaces = []
                }
                
                let reNoteAIFolder = filesList.files.first(where: { $0.name == "ReNoteAI" })
                
                if let reNoteAIFolder = reNoteAIFolder {
                    print("ReNoteAI folder already exists.")
                    DataBaseManager.shared.mainFolderID = reNoteAIFolder.id
                    // Sync local folders to Google Drive after ensuring ReNoteAI folder exists
                    syncAppFoldersWithDrive()
                } else {
                    // Folder does not exist, create it and then sync folders
                    let folderId = await createMainFolderInGDrive()
                    DataBaseManager.shared.mainFolderID = ""
                    syncAppFoldersWithDrive()
                }
            } catch {
                print("An error occurred while listing files: \(error)")
            }
        }
    }
    
    
    

    
    func checkIsSignedIn () {
        Task {
            for await isSignedIn in client.auth.isSignedInStream() {
                DispatchQueue.main.async {
                    self.isSignedIn = isSignedIn
                    if (isSignedIn) {
                        DataBaseManager.shared.saveUserInfo()
                        self.listFiles()
                    }
                }
            }
        }
    }
    
    func onOpenURL (url:URL) {
        Task<Void, Never> {
            do {
                _ = try await client.auth.handleRedirect(url)
            } catch {
                
            }
        }
    }
    
//    func fetchSchemaDetails(mainFolderID:String)  {
//        
//        // List contents of the ReNoteAI folder to find schema.json
//        Task {
//            do {
//                let folderContents = try await client.listFiles {
//                    $0.query = "'\(mainFolderID)' in parents and trashed=false and name='schema.json'"
//                    $0.spaces = []
//                }
//                
//                if let schemaFile = folderContents.files.first {
//                    // Read the contents of schema.json
//                    let jsonData = try await client.getFileData(fileId: schemaFile.id) // Assuming this method exists and returns Data
//                    // Assuming the jsonData is directly printable
//                    if let json = String(data: jsonData, encoding: .utf8) {
//                        let jsonFormat:[String:Any]  =  try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : Any]
//                        let foldersOfCloud = jsonFormat["folders"] as! [String:Any]
//                        DataBaseManager.shared.updateFoldersInLocalDB(folderInputs: foldersOfCloud)
//                        
//                        let documentsOfCloud = jsonFormat["documents"] as! [String:Any]
//                        DataBaseManager.shared.updateDocumentsInLocalDB(documentsFromCloud: documentsOfCloud)
//                        
//                    } else {
//                        print("Unable to decode jsonData to String")
//                    }
//                } else {
//                    print("schema.json does not exist within the ReNoteAI folder.")
//                }
//            } catch {
//                print("An error occurred while listing files: \(error)")
//            }
//        }
//    }
    
    func uploadFile(fileURL: URL, fileName:String, folderID:String?) {
       
        Task<Void, Never> {
            let startAccessing = fileURL.startAccessingSecurityScopedResource()
            
            defer {
                if startAccessing {
                    fileURL.stopAccessingSecurityScopedResource()
                }
            }
            
            do {
                let localFileName = fileURL.lastPathComponent
                
                // Check if the URL is a file and not a directory
                var isDir: ObjCBool = false
                if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDir), !isDir.boolValue {
                    guard let localFileData = try? Data(contentsOf: fileURL) else {
                        print("Failed to read file data from URL: \(fileURL)")
                        return
                    }
                    
                    var uploadingFolder = ""
                    if (folderID != "") {
                        uploadingFolder = folderID!
                    }
                    else {
                        uploadingFolder = DataBaseManager.shared.mainFolderID ?? ""
                    }
                    // Attempt to upload the file
                    let createdFile = try await client.createFile(
                        name: fileName,
                        spaces: "ReNoteAI",
                        mimeType:"image/jpeg",
//                        fileURL.pathExtension,
                        parents: [uploadingFolder], // Adjust if you want to specify a parent folder
                        data: localFileData
                    )
                    
                    // Log success message with uploaded file details
                    print("Successfully uploaded file: \(createdFile.name), ID: \(createdFile.id)")
                } else {
                    print("URL does not point to a valid file: \(fileURL)")
                }
            } catch {
                print("Failed to upload file. Error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateFolderName() {
        
    }
    
    func updateFile() {
        
    }
    
    func deleteFolder(fileID:String) async {
        do {
            try await client.deleteFile(fileId: fileID)
        }
        catch {
            print("DeleteFile failure",
                  "error", "\(error)",
                  "localizedDescription", "\(error.localizedDescription)"
            )
        }
    }
    
    func deleteFile(fileID:String) async {
        do {
            try await client.deleteFile(fileId: fileID)
        }
        catch {
            print("DeleteFile failure",
                  "error", "\(error)",
                  "localizedDescription", "\(error.localizedDescription)"
            )
        }
    }
}
extension GoogleAuthentication {
    
    func syncAppFoldersWithDrive() {
        guard let mainFolderID = DataBaseManager.shared.mainFolderID else { return }
        
        // Fetch local folders
        let localFolders = fetchLocalFolders()
        
        // Fetch folders from Drive
        Task {
            let driveFolders = try await fetchDriveFolders(parentFolderID: mainFolderID)
            
            // Determine which local folders need to be created in Drive
            let foldersToCreate = localFolders.filter { localFolder in
                !driveFolders.contains { $0.name == localFolder.name }
            }
            
            // Create missing folders in Drive
            for folder in foldersToCreate {
                await createFolderInDrive(name: folder.name, parentFolderID: mainFolderID)
            }
        }
    }
    
    
    func fetchLocalFolders() -> [Folder] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        
        do {
            let folderEntities = try context.fetch(fetchRequest)
            
            // Convert FolderEntity instances to Folder models
            let folders = folderEntities.map { entity -> Folder in
                return Folder(
                    id: entity.id?.uuidString ?? UUID().uuidString,
                    name: entity.name ?? "",
                    updatedDate: entity.updatedDate ?? Date(),
                    createdDate: entity.createdDate ?? Date(),
                    isSyced: entity.isSyced,
                    isFavourite: entity.isFavourite,
                    isPin: entity.isPin,
                    driveType: entity.driveType ?? "",
                    fileCount: Int(entity.fileCount)
                )
            }
            
            return folders
        } catch {
            print("Failed to fetch folders: \(error)")
            return [] // Return an empty array in case of error
        }
    }
    
    
    private func fetchDriveFolders(parentFolderID: String) async throws -> [File] {
        let query = "'\(parentFolderID)' in parents and trashed=false and mimeType='application/vnd.google-apps.folder'"
        let folderContents = try await client.listFiles {
            $0.query = query
            $0.spaces = []
        }
        return folderContents.files
    }
    
    
    func createFolderInDrive(name: String, parentFolderID: String) async {
        do {
            let createdFolder = try await client.createFile(
                name: name,
                spaces: "drive",
                mimeType: "application/vnd.google-apps.folder",
                parents: [parentFolderID],
                data: Data()
            )
            
            // Log the creation
            print("Folder created successfully in Google Drive with ID: \(createdFolder.id)")
            
            // Here, update the corresponding local folder entity to mark it as synced
            // You need to find the local folder by name and update its isSyced to true
            DispatchQueue.main.async {
                if let index = DataBaseManager.shared.folders.firstIndex(where: { $0.name == name }) {
                    DataBaseManager.shared.folders[index].isSyced = true
                }
            }
        } catch {
            print("Failed to create folder in Google Drive: \(error)")
        }
    }
}



