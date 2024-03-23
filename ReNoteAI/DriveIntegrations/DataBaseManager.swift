import Foundation
import SwiftyDropbox
import GoogleDriveClient
import CoreData



struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}




 
 
class DataBaseManager: ObservableObject {
    
    static let shared = DataBaseManager(context: PersistenceController.shared.container.viewContext)
    @Published var isSignedIn: Bool = false
    @Published var mainFolderID: String?
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
            self.context = context
        }

    
    var users: [UserEntity] = []
        @Published var folders: [FolderEntity] = []
        @Published var documents: [DocumentEntity] = []
        @Published var tags: [TagEntity] = []
    
    enum StoragePlace: String {
        case Google = "Google"
        // Add other cases as necessary
    }

    
    
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
 
 
  
    
    
    
    
    
    func saveUserInfo(email: String, userType: String, mainFolderID: String) {
        let newUser = UserEntity(context: self.context)
        newUser.email = email
        
        do {
            try self.context.save()
            
            // After successfully saving the user, store the userType and mainFolderID in UserDefaults
            UserDefaults.standard.set(userType, forKey: "userType-\(email)")
            UserDefaults.standard.set(mainFolderID, forKey: "mainFolderID-\(email)")
            
        } catch {
            print("Failed to save user info: \(error)")
        }
    }

    func storeMainFolderID(fileID: String) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Assuming `userType` is the correct attribute name in your model
        fetchRequest.predicate = NSPredicate(format: "userType == %@", StoragePlace.Google.rawValue)
        
        do {
            let filteredUsers = try context.fetch(fetchRequest)
            if let googleUser = filteredUsers.first {
                // Assuming here you have the logic to set `mainFolderID` for `googleUser`
                // Since you mentioned not updating CoreData, remember to update the approach based on your context
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }
    
    func fetchUserWithType(_ type: String) -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userType == %@", type)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching users with type \(type): \(error)")
            return []
        }
    }

    
    
    func getMainFolderID() -> String? {
        self.mainFolderID
    }
    
    func createSubFolder(name: String, driveType: String) {
            let newFolder = FolderEntity(context: self.context)
            newFolder.id = UUID()
            newFolder.name = name
            newFolder.driveType = driveType
            newFolder.updatedDate = Date()
            newFolder.createdDate = Date()
            newFolder.isSyced = false
            newFolder.isFavourite = false
            newFolder.isPin = false
            newFolder.fileCount = 0
            
            do {
                try self.context.save()
            } catch {
                print("Failed to save the folder: \(error)")
            }
        }


    func updateFoldersInLocalDB(folderInputs: [String: Any]) {
        for (folderIDString, folderInfo) in folderInputs {
            guard let folderDict = folderInfo as? [String: Any],
                  let id = UUID(uuidString: folderIDString),
                  let name = folderDict["name"] as? String,
                  let updatedDate = folderDict["updatedDate"] as? Date,
                  let createdDate = folderDict["createdDate"] as? Date,
                  let isSynced = folderDict["isSynced"] as? Bool,
                  let isFavourite = folderDict["isFavourite"] as? Bool,
                  let isPin = folderDict["isPin"] as? Bool,
                  let driveType = folderDict["driveType"] as? String,
                  let fileCount = folderDict["fileCount"] as? Int64 else { continue }

            let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try context.fetch(fetchRequest)
                let folderEntity: FolderEntity
                if let existingFolder = results.first {
                    folderEntity = existingFolder
                } else {
                    folderEntity = FolderEntity(context: context)
                    folderEntity.id = id
                }
                
                folderEntity.name = name
                folderEntity.updatedDate = updatedDate
                folderEntity.createdDate = createdDate
                folderEntity.isSyced = isSynced
                folderEntity.isFavourite = isFavourite
                folderEntity.isPin = isPin
                folderEntity.driveType = driveType
                folderEntity.fileCount = fileCount
                
                try context.save()
            } catch {
                print("Failed to update or create folder: \(error)")
            }
        }
    }


     func updateDocumentsInLocalDB(documentsFromCloud: [String: Any]) {
        for (documentIDString, documentInfo) in documentsFromCloud {
            guard let documentDict = documentInfo as? [String: Any],
                  let id = UUID(uuidString: documentIDString),
                  let name = documentDict["name"] as? String,
                  let createdDate = documentDict["createdDate"] as? Date,
                  let updatedDate = documentDict["updatedDate"] as? Date,
                  let isSynced = documentDict["isSynced"] as? Bool,
                  let isPin = documentDict["isPin"] as? Bool,
                  let isFavourite = documentDict["isFavourite"] as? Bool,
                  let driveType = documentDict["driveType"] as? String else { continue }

            let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)
                let documentEntity: DocumentEntity

                if let existingDocument = results.first {
                    documentEntity = existingDocument
                } else {
                    documentEntity = DocumentEntity(context: context)
                    documentEntity.id = id
                }

                documentEntity.name = name
                documentEntity.createdDate = createdDate
                documentEntity.updatedDate = updatedDate
                documentEntity.isSynced = isSynced
                documentEntity.isPin = isPin
                documentEntity.isFavourite = isFavourite
                documentEntity.driveType = driveType

                try context.save()
            } catch {
                print("Failed to update or create document: \(error)")
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
                // Directly assign the fetched FolderEntity objects to self.folders
                self.folders = fetchedFolders
            }
        } catch {
            print("Failed to fetch folders: \(error)")
        }
    }
}

extension DataBaseManager {
    func saveDocument(name: String, fileData: Data, folderId: UUID?, completion: @escaping (Bool, DocumentEntity?) -> Void) {
        print("Saving document with name: \(name), folderId: \(String(describing: folderId))")
        let newDocument = DocumentEntity(context: context)
        newDocument.id = UUID()
        newDocument.name = name
        newDocument.createdDate = Date()
        newDocument.updatedDate = Date()
        
        // Default properties
        newDocument.isSynced = false
        newDocument.isPin = false
        newDocument.isFavourite = false
        newDocument.driveType = nil
        
        // Set folder if ID is provided
        do {
                    try context.save()
                    print("Document saved successfully.")
                    refreshDocuments()
                } catch {
                    print("Failed to save document: \(error.localizedDescription)")
                }
    }
    
    // Ensure this method exists within DataBaseManager


        func findFolderByID(_ id: UUID) -> FolderEntity? {
            let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let results = try context.fetch(fetchRequest)
                return results.first // Return the first found folder, if any
            } catch {
                print("Error fetching folder with ID \(id): \(error)")
                return nil
            }
        }
    


    
    
    
    func refreshDocuments() {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        // You might want to specify sort descriptors or predicates here
        do {
            self.documents = try context.fetch(fetchRequest)
            print("Fetched \(self.documents.count) documents.")
        } catch let error as NSError {
            print("Could not fetch documents: \(error), \(error.userInfo)")
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
    
func fetchDocumentsFromDatabase(completion: @escaping ([DocumentEntity]) -> Void) {
    let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
    // Add sort descriptors or predicates if needed
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DocumentEntity.createdDate, ascending: false)]

    do {
        let fetchedDocuments = try context.fetch(fetchRequest)
        completion(fetchedDocuments)
    } catch {
        print("Failed to fetch documents: \(error)")
        completion([])
    }
}


}
extension DataBaseManager {
    func updateFolderWithDriveID(for folder: FolderEntity, with driveFolderID: String) {
        folder.googleId = driveFolderID
        folder.isSyced = true
        do {
            try context.save()
            print("Folder updated with Google Drive ID successfully.")
        } catch {
            print("Failed to update folder with Google Drive ID: \(error.localizedDescription)")
        }
    }

    func fetchDocumentsForFolder(_ folder: FolderEntity) -> [DocumentEntity] {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "folder == %@", folder)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching documents for folder: \(error.localizedDescription)")
            return []
        }
    }
}
