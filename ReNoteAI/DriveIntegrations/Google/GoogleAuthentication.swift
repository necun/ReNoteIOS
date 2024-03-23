//
//  GoogleAuthentication.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 24/02/24.
//

import Dependencies
import Foundation
import SwiftUI
import GoogleDriveClient
import CoreData
import SwiftyDropbox


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
                    await syncAppFoldersWithDrive()
                } else {
                    // Folder does not exist, create it and then sync folders
                    let folderId = await createMainFolderInGDrive()
                    DataBaseManager.shared.mainFolderID = ""
                    await syncAppFoldersWithDrive()
                }
            } catch {
                print("An error occurred while listing files: \(error)")
            }
        }
    }
    
    
    

    
    func checkIsSignedIn() {
        Task {
            for await isSignedIn in client.auth.isSignedInStream() {
                DispatchQueue.main.async {
                    self.isSignedIn = isSignedIn
                    if isSignedIn {
                        // Replace these values with actual data from your application's context
                        let email = "" // Example; use the actual email
                        let userType = "Google" // Example; determine the actual user type
                        let mainFolderID = "" // Example; use the actual main folder ID obtained from Google Drive
                        
                        DataBaseManager.shared.saveUserInfo(email: email, userType: userType, mainFolderID: mainFolderID)
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
    
    func syncAppFoldersWithDrive() async {
        guard let mainFolderID = DataBaseManager.shared.mainFolderID else { return }
        
        Task {
            let driveFolders = try await self.fetchDriveFolders(parentFolderID: mainFolderID)
            
            let localFolders = fetchLocalFolders()
            
            for folder in localFolders {
                // Check if folder exists in Drive
                if let driveFolder = driveFolders.first(where: { $0.name == folder.name }) {
                    // Folder exists in Drive, sync documents within this folder
                    await syncDocumentsForFolder(localFolder: folder, driveFolderID: driveFolder.id)
                } else {
                    // If not, create it in Drive
                    if let createdFolderID = await createFolderInDrive(name: folder.name ?? "", parentFolderID: mainFolderID) {
                        DataBaseManager.shared.updateFolderWithDriveID(for: folder, with: createdFolderID)
                        // Sync documents within this newly created folder
                        await syncDocumentsForFolder(localFolder: folder, driveFolderID: createdFolderID)
                       
                    }
                }
            }
        }
    }
    
   
    


    
    private func fetchLocalDocumentsWithoutFolder() -> [DocumentEntity] {
           let context = PersistenceController.shared.container.viewContext
           let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
           
           // Assuming `folder` is the optional relationship from DocumentEntity to FolderEntity
           // We want to fetch documents where `folder` is nil
           fetchRequest.predicate = NSPredicate(format: "folder == nil")
           
           do {
               let documentsWithoutFolder = try context.fetch(fetchRequest)
               return documentsWithoutFolder
           } catch {
               print("Failed to fetch documents without a folder: \(error)")
               return [] // Return an empty array in case of error
           }
       }
    
    func createFolderInDrive(name: String, parentFolderID: String) async -> String? {
        do {
            let createdFolder = try await client.createFile(
                name: name,
                spaces: "drive",
                mimeType: "application/vnd.google-apps.folder",
                parents: [parentFolderID],
                data: Data()
            )
            print("Folder created successfully in Google Drive with ID: \(createdFolder.id)")
            return createdFolder.id
        } catch {
            print("Failed to create folder in Google Drive: \(error)")
            return nil
        }
    }
    
    func uploadDocumentToDrive(documentName: String, mimeType: String, parentFolderID: String?, documentData: Data) async -> String? {
        do {
            // Adjust the parents parameter based on whether a folderID is provided
            let parents: [String] = parentFolderID == nil ? ["root"] : [parentFolderID!]
            
            let createdFile = try await client.createFile(
                name: documentName,
                spaces: "drive",
                mimeType: mimeType,
                parents: parents,
                data: documentData
            )
            
            print("Successfully uploaded document: \(createdFile.name), ID: \(createdFile.id)")
            return createdFile.id
        } catch {
            print("Failed to upload document. Error: \(error.localizedDescription)")
            return nil
        }
    }

    func syncDocumentsForFolder(localFolder: FolderEntity, driveFolderID: String) async {
            let documents = DataBaseManager.shared.fetchDocumentsForFolder(localFolder)
            
            for document in documents {
                if let images = document.image as? Set<ImageEntity>, !images.isEmpty {
                    for image in images {
                        // Check if the image has already been uploaded
                        if let existingDriveFileID = image.googleDriveFileID {
                            print("Image already uploaded with Google Drive File ID: \(existingDriveFileID). Skipping...")
                            continue
                        }
                        
                        // Proceed with uploading the image
                        guard let imageData = image.imageData else { continue }
                        let imageName = image.name ?? "Untitled"
                        let fileExtension = imageName.components(separatedBy: ".").last ?? ""
                        let mimeType = self.mimeType(for: fileExtension)
                        
                        let uploadedFileID = await uploadDocumentToDrive(documentName: imageName, mimeType: mimeType, parentFolderID: driveFolderID, documentData: imageData)
                        
                        // Store the Google Drive file ID locally associated with the ImageEntity
                        if let uploadedFileID = uploadedFileID {
                            updateImageWithGoogleDriveFileID(image: image, fileID: uploadedFileID)
                            print("Uploaded and updated ImageEntity with Google Drive File ID: \(uploadedFileID)")
                        }
                    }
                }
            }
        }
    func updateImageWithGoogleDriveFileID(image: ImageEntity, fileID: String) {
           // Assuming 'image' is already the managed object you wish to update,
           // and it's fetched or passed in the context of its managed object context.
           // Otherwise, you'll need to fetch the specific ImageEntity using a unique identifier.
           
           let context = PersistenceController.shared.container.viewContext
           
           // Update the ImageEntity with the Google Drive file ID
           image.googleDriveFileID = fileID
           
           // Save the context to persist changes
           do {
               try context.save()
               print("Successfully updated ImageEntity with Google Drive File ID.")
           } catch {
               print("Failed to save ImageEntity with Google Drive File ID: \(error)")
           }
       }

    func uploadDocumentToGoogleDrive(documentName: String, mimeType: String = "application/octet-stream", documentData: Data, parentFolderID: String, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let createdFile = try await client.createFile(
                    name: documentName,
                    spaces: "drive",
                    mimeType: mimeType,
                    parents: [parentFolderID],
                    data: documentData
                )
                print("Successfully uploaded document: \(createdFile.name), ID: \(createdFile.id)")
                completion(.success(createdFile.id))
            } catch {
                print("Failed to upload document to Google Drive. Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    // Example method where a document is created/saved locally
    func saveAndUploadDocument(name: String, data: Data) {
        DataBaseManager.shared.saveDocument(name: name, fileData: data, folderId: nil) { savedSuccessfully, savedDocument in
            guard savedSuccessfully, let savedDocument = savedDocument else {
                print("Failed to save document locally.")
                return
            }


            // Now upload the document to Google Drive
            let googleDriveFolderID = DataBaseManager.shared.getMainFolderID() ?? "root" // Use "root" or a specific folder ID
            GoogleAuthentication.shared.uploadDocumentToGoogleDrive(documentName: name, documentData: data, parentFolderID: googleDriveFolderID) { result in
                switch result {
                case .success(let googleDriveFileID):
                    print("Document uploaded to Google Drive with ID: \(googleDriveFileID)")
                    // Optionally, update the local database with this Google Drive ID
                case .failure(let error):
                    print("Error uploading document to Google Drive: \(error.localizedDescription)")
                }
            }
        }
    }
    
    

    


    func fetchLocalFolders() -> [FolderEntity] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        
        do {
            let folderEntities = try context.fetch(fetchRequest)
            return folderEntities
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
    
    
    
}
extension GoogleAuthentication {
    
    // This method remains unchanged, ensures we use the correct method name
    private func mimeType(for fileExtension: String) -> String {
        switch fileExtension.lowercased() {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "pdf":
            return "application/pdf"
        case "txt":
            return "text/plain"
            // Add more cases as needed
        default:
            return "application/octet-stream" // Fallback MIME type
        }
    }
}







