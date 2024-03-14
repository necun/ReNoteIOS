import Foundation
import SwiftData
import GoogleDriveClient
import CoreData

//
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CoreData") // Replace "YourModelName" with the name of your Core Data model file (without the extension)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

 
 
class DataBaseManager: ObservableObject {
    
    static let shared = DataBaseManager()
    @Published var isSignedIn: Bool = false
    @Published var mainFolderID: String?
    
    var context: NSManagedObjectContext {
            return PersistenceController.shared.container.viewContext
        }
    
    var users: [User] = []
    @Published var folders: [Folder] = []
    @Published var documents: [Document] = []
    @Published var tags: [Tag] = []
    
    var modelContext: ModelContext?
    
//    init() {
//           loadTags()
//       }
//
//    func loadTags() {
//        if let schemaData = UserDefaults.standard.data(forKey: "SchemaData"),
//           let schema = try? JSONSerialization.jsonObject(with: schemaData, options: []) as? [String: Any],
//           let tagsDict = schema["tags"] as? [String: [String: Any]] {
//
//            let loadedTags = tagsDict.values.compactMap { dict -> Tag? in
//                guard let id = dict["id"] as? String, let tagName = dict["tagName"] as? String else { return nil }
//                return Tag(id: id, name: tagName)
//            }
//
//            DispatchQueue.main.async {
//                self.tags = loadedTags
//            }
//        } else {
//            // Load default schema if no customized schema data is found
//            loadSchemaTagsIfNeeded()
//        }
//    }
//
//
//    func addNewTag(name: String) {
//        let newTag = Tag(id: UUID().uuidString, name: name)
//        self.tags.append(newTag)
//        saveTags() // This should serialize and save the updated tags list
//    }
 
 
 
 
//    private func loadSchemaTagsIfNeeded() {
//        guard tags.isEmpty, let schemaData = schemaData(),
//              let schema = try? JSONSerialization.jsonObject(with: schemaData, options: []) as? [String: Any],
//              let tagsDictionary = schema["tags"] as? [String: [String: Any]] else { return }
//
//        let schemaTags = tagsDictionary.compactMap { (_, value) -> Tag? in
//            guard let id = value["id"] as? String, let tagName = value["tagName"] as? String else { return nil }
//            return Tag(id: id, name: tagName)
//        }
//
//        DispatchQueue.main.async {
//            self.tags.append(contentsOf: schemaTags)
//            self.saveTags() // Save these loaded schema tags for future launches
//        }
//    }
 
    
//    func saveTags() {
//        var currentSchema: [String: Any]
//        if let schemaData = UserDefaults.standard.data(forKey: "SchemaData"),
//           var schema = try? JSONSerialization.jsonObject(with: schemaData, options: []) as? [String: Any] {
//            currentSchema = schema
//        } else {
//            currentSchema = ["tags": [String: [String: Any]](), "folders": [String: [String: Any]]()]
//        }
//
//        var tagsDict = currentSchema["tags"] as? [String: [String: Any]] ?? [String: [String: Any]]()
//        for tag in tags {
//            tagsDict[tag.id] = ["id": tag.id, "tagName": tag.name]
//        }
//
//        currentSchema["tags"] = tagsDict
//
//        do {
//            let modifiedSchemaData = try JSONSerialization.data(withJSONObject: currentSchema, options: [])
//            UserDefaults.standard.set(modifiedSchemaData, forKey: "SchemaData")
//        } catch {
//            print("Error saving modified schema: \(error)")
//        }
//    }
 
 
  
    
    
    
    
    
    func saveUserInfo() {
        // Assuming 'email' is the unique identifier for each user
        let userEmail = "user@example.com" // This should be obtained from the Google sign-in process
        
        // Check if the user already exists
        if !users.contains(where: { $0.userType == StoragePlace.Google.rawValue }) {
            // If the user is new, create and insert the user
            let newUser = User(name: "Name", email: userEmail, userType: StoragePlace.Google.rawValue, accessToken: "", accessTokenExpirationDate: Date.now, refreshToken: "", refreshTokenExpirationDate: Date.now, idToken: "", idTokenExpirationDate: Date.now, mainFolderID: "")
            
            // Insert the new user into the database or your data structure
            modelContext?.insert(newUser)
            
            // If you're using a SwiftUI view, and `users` is observed, it should automatically update.
            // Otherwise, you might need to manually fetch or update the list to include the new user.
        } else {
            // User already exists, you can update the user's info if needed
            // This might involve fetching the user from `users` and updating their details
            
            //TODO update the local user
            
        }
    }
    
    func storeMainFolderID(fileID:String) {
        let users = users.filter({
            $0.userType == StoragePlace.Google.rawValue
        })
        
        if (users.count > 0) {
            let googleUser = users[0]
            googleUser.mainFolderID = fileID
        }
        
    }
    
    
    func getMainFolderID() -> String? {
        self.mainFolderID
    }
    
    func createSubFolder(name: String) {
            // Create local folder first
            let newFolder = Folder(id: UUID().uuidString, name: name, updatedDate: Date.now, createdDate: Date.now, isSyced: false, isFavourite: false, isPin: false, driveType: StoragePlace.Google.rawValue, fileCount: 0)
            
            // Insert newFolder into your local database
            // For example, you might save it to Core Data or another local storage solution.
            // This example directly adds it to an array for simplicity.
            self.folders.append(newFolder)

            // If the user is signed in to Google Drive, also create the folder on Google Drive
            if GoogleAuthentication.shared.isSignedIn, let mainFolderID = self.mainFolderID {
                Task {
                    await GoogleAuthentication.shared.createFolderInDrive(name: name, parentFolderID: mainFolderID)
                }
            }
        }
    func updateFoldersInLocalDB(folderInputs:[String:Any]) {
        for eachKey in folderInputs.keys {
            if !self.folders.contains(where: { $0.id ==  eachKey as String  }) {
                if let eachFolder = folderInputs[eachKey] as? [String: Any] {
                    // Assuming you have a way to parse eachFolder dictionary to your Folder model
                    let createdDate = Date(timeIntervalSince1970: eachFolder["createdDate"] as! TimeInterval )
                    let updatedDate = Date(timeIntervalSince1970: eachFolder["updatedDate"] as! TimeInterval )
                    
                    let f = Folder(
                        id: eachFolder["id"] as? String ?? "",
                        name: eachFolder["name"] as? String ?? "",
                        updatedDate: updatedDate,
                        createdDate: createdDate,
                        isSyced: eachFolder["isSynced"] as? Bool ?? true,
                        isFavourite: eachFolder["isFavourite"] as? Bool ?? false,
                        isPin: eachFolder["isPin"] as? Bool ?? false,
                        driveType: eachFolder["driveType"] as? String ?? "",
                        fileCount: eachFolder["fileCount"] as? Int ?? 0
                    )
                    modelContext?.insert(f)
                }
            }
            else {
                //TODO
                // update the folder
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func saveDocument(name: String, fileData: Data, folderId: String?) {
//        let context = PersistenceController.shared.container.viewContext
//        let newDocument = DocumentEntity(context: context)
//        newDocument.id = UUID().uuidString
//        newDocument.name = name
//        newDocument.createdDate = Date()
//        newDocument.updatedDate = Date()
//        newDocument.fileData = fileData
//        if let folderId = folderId {
//            newDocument.folderId = folderId
//        }
//        // Set other attributes as necessary
//
//        do {
//            try context.save()
//            print("Document saved successfully")
//            DispatchQueue.main.async {
//                self.refreshDocuments() // Fetches documents from CoreData and updates the observable array
//            }
//        } catch {
//            print("Failed to save document: \(error)")
//        }
//    }
//
//
//
//    func refreshDocuments() {
//        let context = PersistenceController.shared.container.viewContext
//        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
//
//        do {
//            let result = try context.fetch(fetchRequest)
//            DispatchQueue.main.async {
//                self.documents = result.map { $0.toDocumentModel() } // Convert Core Data entities to your model
//            }
//        } catch {
//            print("Failed to fetch documents: \(error)")
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func updateDocumentsInLocalDB(documentsFromCloud:[String:Any]) {
        for eachKey in documentsFromCloud.keys{
            if !documents.contains(where: { $0.id ==  eachKey as String  }) {
                if let eachDocument = documentsFromCloud[eachKey] as? [String: Any] {
                    // Assuming you have a way to parse eachFolder dictionary to your Folder model
                    let createdDate = Date(timeIntervalSince1970: eachDocument["createdDate"] as! TimeInterval )
                    let updatedDate = Date(timeIntervalSince1970: eachDocument["updatedDate"] as! TimeInterval )
                    
                    let d = Document.init(
                        id: eachDocument["id"] as? String ?? "",
                        name: eachDocument["name"] as? String ?? "",
                        createdDate: createdDate,
                        updatedDate: updatedDate,
                        fileData: eachDocument["fileData"] as? Data ?? Data(),
                        isSynced: eachDocument["isSynced"] as? Bool ?? true,
                        isPin: eachDocument["isPin"] as? Bool ?? true,
                        isFavourite: eachDocument["isFavourite"] as? Bool ?? true,
                        folderId: eachDocument["folderId"] as? String ?? "",
                        tagId: eachDocument["tagId"] as? String ?? "",
                        openCount: eachDocument["openCount"] as? Int ?? 0,
                        localFilePathIos: eachDocument["localFilePathIos"] as? String ?? "",
                        localFilePathAndroid: eachDocument["localFilePathAndroid"] as? String ?? "",
                        driveType: eachDocument["driveType"] as? String ?? "",
                        fileExtension: eachDocument["fileExtension"] as? String ?? ""
                    )
                    modelContext?.insert(d)
                }
            }
            else {
                //TODO Update document
            }
        }
    }
    
}
extension DataBaseManager {
    func saveFolderLocally(name: String) {
            let newFolder = FolderEntity(context: context)
        newFolder.id = UUID() // If your id is a UUID type

            newFolder.name = name
            newFolder.updatedDate = Date()
            newFolder.createdDate = Date()
            newFolder.isSyced = false
            newFolder.isFavourite = false
            newFolder.isPin = false
            newFolder.driveType = "Local"
            newFolder.fileCount = 0
            
            do {
                try context.save()
                print("Folder saved successfully")
                refreshFolders()
            } catch {
                print("Failed to save folder: \(error)")
            }
        }
}

func fetchFoldersFromDatabase(using context: NSManagedObjectContext, completion: @escaping ([FolderEntity]) -> Void) {
    let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()

    do {
        let fetchedFolders = try context.fetch(fetchRequest)
        completion(fetchedFolders)
    } catch {
        print("Failed to fetch folders: \(error)")
        completion([])
    }
}

 
extension DataBaseManager {
    func refreshFolders() {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        do {
            let fetchedFolders = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.folders = fetchedFolders.map { Folder(id: $0.id?.uuidString ?? UUID().uuidString, // Convert UUID to String
                                                           name: $0.name ?? "",
                                                           updatedDate: $0.updatedDate ?? Date(),
                                                           createdDate: $0.createdDate ?? Date(),
                                                           isSyced: $0.isSyced,
                                                           isFavourite: $0.isFavourite,
                                                           isPin: $0.isPin,
                                                           driveType: $0.driveType ?? "",
                                                           fileCount: Int($0.fileCount)) }
            }
        } catch {
            print("Failed to fetch folders: \(error)")
        }
    }

}

extension DataBaseManager {
    func saveDocument(name: String, fileData: Data, folderId: String? = nil) {
        print("Saving document with name: \(name), folderId: \(String(describing: folderId))")
        let newDocument = DocumentEntity(context: context)
        newDocument.id = UUID()
        newDocument.name = name
        newDocument.createdDate = Date()
        newDocument.updatedDate = Date()
        newDocument.fileData = fileData
        
        // Default properties
        newDocument.isSynced = false
        newDocument.isPin = false
        newDocument.isFavourite = false
        newDocument.openCount = 0
        newDocument.localFilePathIos = nil
        newDocument.localFilePathAndroid = nil
        newDocument.driveType = nil
        newDocument.fileExtension = "jpg"
        //        newDocument.folderId = UUID()
        newDocument.tagId = nil
        
        // Set folder if ID is provided
        if let folderIdUnwrapped = folderId, let uuid = UUID(uuidString: folderIdUnwrapped) {
            newDocument.folderId = uuid
            newDocument.folder = fetchFolder(by: uuid)
        }
        
        do {
            try context.save()
            print("Document saved successfully: Name = \(name), ID = \(newDocument.id?.uuidString ?? "N/A")")
            refreshDocuments() // Refresh the documents array
        } catch {
            print("Failed to save document: \(error)")
        }
    }
    
    
    
    func refreshDocuments() {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        do {
            let fetchedDocuments = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.documents = fetchedDocuments.compactMap { entity in
                    // Ensure all required fields are non-nil before initialization
                    guard let id = entity.id,
                          let name = entity.name,
                          let createdDate = entity.createdDate,
                          let updatedDate = entity.updatedDate,
                          let fileData = entity.fileData,
                          let fileExtension = entity.fileExtension else {
                        print("Skipping a document due to missing required fields.")
                        return nil
                    }
                    
                    return Document(
                        id: id.uuidString,
                        name: name,
                        createdDate: createdDate,
                        updatedDate: updatedDate,
                        fileData: fileData,
                        isSynced: entity.isSynced,
                        isPin: entity.isPin,
                        isFavourite: entity.isFavourite,
                        folderId: entity.folderId?.uuidString ?? "",
                        tagId: entity.tagId ?? "",
                        openCount: Int(entity.openCount),
                        localFilePathIos: entity.localFilePathIos ?? "",
                        localFilePathAndroid: entity.localFilePathAndroid ?? "",
                        driveType: entity.driveType ?? StoragePlace.Local.rawValue, // Default to 'Local' if nil
                        fileExtension: fileExtension
                    )
                }
            }
        } catch {
            print("Failed to fetch documents: \(error)")
        }
    }
    
    private func fetchFolder(by id: UUID) -> FolderEntity? {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching folder with ID \(id): \(error)")
            return nil
        }
    }
    
    func fetchDocumentsFromDatabase() {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        
        do {
            let fetchedDocuments = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.documents = fetchedDocuments.compactMap { entity in
                    guard let id = entity.id, let name = entity.name, let createdDate = entity.createdDate, let updatedDate = entity.updatedDate, let fileData = entity.fileData, let fileExtension = entity.fileExtension else {
                        print("Skipping a document due to missing required fields.")
                        return nil
                    }
                    return Document(
                        id: id.uuidString,
                        name: name,
                        createdDate: createdDate,
                        updatedDate: updatedDate,
                        fileData: fileData,
                        isSynced: entity.isSynced,
                        isPin: entity.isPin,
                        isFavourite: entity.isFavourite,
                        folderId: entity.folderId?.uuidString ?? "",
                        tagId: entity.tagId ?? "",
                        openCount: Int(entity.openCount),
                        localFilePathIos: entity.localFilePathIos ?? "",
                        localFilePathAndroid: entity.localFilePathAndroid ?? "",
                        driveType: entity.driveType ?? StoragePlace.Local.rawValue,
                        fileExtension: fileExtension
                    )
                }
            }
        } catch {
            print("Failed to fetch documents: \(error)")
        }
    }
}



//extension DataBaseManager {
//    func refreshDocuments() {
//        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
//        do {
//            let fetchedDocuments = try context.fetch(fetchRequest)
//            DispatchQueue.main.async {
//                self.documents = fetchedDocuments.map { entity in
//                    Document(
//                        id: entity.id?.uuidString ?? UUID().uuidString,
//                        name: entity.name ?? "",
//                        createdDate: entity.createdDate ?? Date(),
//                        updatedDate: entity.updatedDate ?? Date(),
//                        fileData: entity.fileData ?? Data(),
//                        isSynced: entity.isSynced,
//                        isPin: entity.isPin,
//                        isFavourite: entity.isFavourite,
//                        folderId: entity.folderId?.uuidString ?? UUID().uuidString, // Correctly match to folderId
//                        tagId: entity.tagId ?? "", // Correctly match to tagId
//                        openCount: Int(entity.openCount), // Correctly use openCount as Int
//                        localFilePathIos: entity.localFilePathIos ?? "", // Correctly match to localFilePathIos
//                        localFilePathAndroid: entity.localFilePathAndroid ?? "", // Correctly match to localFilePathAndroid
//                        driveType: entity.driveType ?? "", // Correctly match to driveType
//                        fileExtension: entity.fileExtension ?? "" // Correctly match to fileExtension
//                    )
//                }
//            }
//        } catch {
//            print("Failed to fetch documents: \(error)")
//        }
//    }
//}















