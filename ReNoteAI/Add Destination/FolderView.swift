import SwiftUI
import SwiftyDropbox
import CoreData
 
 
struct ImportScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
 
    @State private var isScannerPresented = false
    @Binding var scannedImages: [UIImage]
    
    var onDocumentsSaved: (() -> Void)?
    
    @ObservedObject var dataBaseManager = DataBaseManager.shared
    @State private var selectedFolderID: String?
    @State private var searchString = ""
    @State private var showingAddFolderAlert = false
       @State private var newFolderName = ""
    @State private var showingAddFolderModal = false
    @State private var showDocumentScanner = false
    @State private var showDocumentListView = false
    @State private var navigateToFolderDetails = false
       @State private var selectedFolder: FolderEntity? = nil
 
 
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedSegment = 0
       @State private var searchText = ""
    var onSaveFolder: ((FolderEntity) -> Void)?
    @State private var selectedDocument: DocumentEntity? = nil 

    
    var body: some View {
           NavigationView {
               VStack {
                   // Segmented control
                   Picker("Options", selection: $selectedSegment) {
                       Text("All").tag(0)
                       Text("Local").tag(1)
                       Text("GDrive").tag(2)
                       Text("OneDrive").tag(3)
                       Text("iCloud").tag(4)
                   }
                   .pickerStyle(SegmentedPickerStyle())
                   .padding()
 
                   // Search bar
                   HStack {
                              Image(systemName: "magnifyingglass")
                                  .foregroundColor(.gray)
 
                              TextField("Search", text: $searchText)
                          }
                          .padding(8)
                          .background(
                              RoundedRectangle(cornerRadius: 20)
                                  .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                          )
                          .padding(.horizontal, 10)
 
                   // List of folders
                   if selectedSegment == 0 || selectedSegment == 1  {
                       // Inside your List in ImportScreen
                       // Inside your List in ImportScreen
                       List {
                           ForEach(dataBaseManager.folders.filter {
                                       searchText.isEmpty ? true : $0.name?.contains(searchText) ?? false
                                   }, id: \.self) { folderEntity in
                               Button(action: {
                                   // Toggle selection
                                   withAnimation {
                                              if selectedFolderID == folderEntity.id?.uuidString {
                                                  // If this folder is already selected, deselect it
                                                  selectedFolderID = nil
                                              } else {
                                                  // Otherwise, select this folder
                                                  selectedFolderID = folderEntity.id?.uuidString
                                              }
                                          }
                                          onSaveFolder?(folderEntity)
                               }) {
                                   HStack {
                                                   Text(folderEntity.name ?? "")
                                                   Spacer()
                                                   if selectedFolderID == folderEntity.id?.uuidString {
                                                       Image(systemName: "checkmark").foregroundColor(.blue)
                                                   }
                                               }                               }
                               .padding()
                                           .background(selectedFolderID == folderEntity.id?.uuidString ? Color.blue.opacity(0.2) : Color.clear)
                                           .cornerRadius(5)
                           }
                                              .onDelete(perform: deleteFolders)
                       }
 
 
 
//                       .searchable(text: $searchString)
                   } else {
                       // Display alternative content or leave blank for other segments
                       Spacer()
                       Text("Create New Folders to View")
                           .foregroundColor(.black)
                   }
                   
                   
                   
                   
                   
                   Spacer()
                   // Create Folder button
                   HStack(spacing: 16) { // Add spacing between buttons
                               Button(action: {
                                   // Action for create folder
                                   self.showingAddFolderModal = true
                               }) {
                                   HStack {
                                       Image(systemName: "plus.circle")
                                       Text("Create Folder")
                                   }
                                   .frame(height: 44)
                                   .frame(minWidth: 0, maxWidth: .infinity)
                                   .background(Color.white)
                                   .foregroundColor(.black)
                                   .cornerRadius(22)
                                   .overlay(
                                       RoundedRectangle(cornerRadius: 22)
                                           .stroke(Color.gray, lineWidth: 0.6)
                                   )
                               }
                               
                       Button(action: {
                           // Save images when completion is called
                           self.saveScannedImages()
                           showDocumentListView = true
                       }) {
                                   Text("Save Here")
                                       .frame(height: 44)
                                       .frame(minWidth: 0, maxWidth: .infinity)
                                       .background(Color.green)
                                       .foregroundColor(.white)
                                       .cornerRadius(22)
                               }
                       .sheet(isPresented: $showDocumentScanner) {
                               DocumentScanner(scannedImages: $scannedImages) {
                                   // This will be called upon completion
                                   self.saveScannedImages()
                               }
                           }
                           }
                           .padding(.horizontal)
                           .padding(.bottom, 20)
   //                        .environment(\.sizeCategory, .extraExtraLarge)
               }
               .onAppear {
                       dataBaseManager.refreshFolders() // Refresh the folders list when the view appears
                   }
               .navigationTitle("Choose Folder")
                           .navigationBarItems(leading: Button(action: {
                               // Action for back navigation
                           }) {
//                               HStack {
//                                   Image(systemName: "chevron.left")
//                                   Text("Back")
//                               }
/*                               .foregroundColor(.black)*/ // Change the color as needed
                           })
                           .navigationBarBackButtonHidden(true)
                           .sheet(isPresented: $showingAddFolderModal) {
                                           AddNewTagFolderView(type: "Folder") { newName in
                                               // Here you would add the logic to create a new folder and save it
                                               // This is just a placeholder for where you would call your model or data store's add new folder function
                                               print("Creating new folder with name: \(newName)")
                                               // For example, you might call something like modelContext.addNewFolder(name: newName)
                                           }
                                       }// Hide the default back button
                       }
        // This approach requires SwiftUI 2.0 or later
        if let selectedFolder = selectedFolder {
                            NavigationLink(destination: FolderDetailsView(folder: selectedFolder), isActive: $navigateToFolderDetails) {
                                EmptyView()
                            }
                            .hidden()
                        }
                    }
    
    private func saveScannedImages() {
        let newDocument = DocumentEntity(context: viewContext)

        // Set the document's properties
        newDocument.createdDate = Date()
        newDocument.name = "Document \(Date())"
        newDocument.id = UUID()

        // Add the scanned images to the document
        for image in scannedImages {
            let imageData = ImageEntity(context: viewContext)
            imageData.imageData = image.jpegData(compressionQuality: 1.0)
            newDocument.addToImage(imageData) // Correct relationship method
        }

        // Fetch and assign the folder if selectedFolderID is set
        if let folderIdString = selectedFolderID, let folderId = UUID(uuidString: folderIdString) {
            let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", folderId as CVarArg)

            do {
                let results = try viewContext.fetch(fetchRequest)
                if let folder = results.first {
                    newDocument.folder = folder // Correctly assigning the folder
                }
            } catch {
                print("Error fetching folder: \(error)")
            }
        }

        do {
            try viewContext.save()
            onDocumentsSaved?()
            // Assuming you have a way to fetch the FolderEntity by its ID
            if let folderId = UUID(uuidString: selectedFolderID ?? ""), let selectedFolder = fetchFolderById(folderId) {
                self.selectedFolder = selectedFolder // Make sure you have a `@State` variable for `selectedFolder`
                self.navigateToFolderDetails = true // Trigger navigation
            }
        } catch {
            print("Error saving document: \(error)")
        }

        // Dismiss the screen or perform additional actions
        presentationMode.wrappedValue.dismiss()
    }

    private func fetchFolderById(_ id: UUID) -> FolderEntity? {
            let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let results = try viewContext.fetch(fetchRequest)
                return results.first
            } catch {
                print("Error fetching folder with ID \(id): \(error)")
                return nil
            }
        }



    private func deleteFolders(at offsets: IndexSet) {
            withAnimation {
                offsets.map { dataBaseManager.folders[$0] }.forEach(viewContext.delete)
                do {
                    try viewContext.save()
                } catch {
                    // Handle the error appropriately
                    print("Deletion error: \(error)")
                }
            }
        }
    
//    func addNewFolder() async  {
//        //google lo  create a new folder only when logged in with google
//        if (GoogleAuthentication.shared.isSignedIn) {
//            // sync this folder to google
//            await CreateSubFolderInGDrive(newFolderName: newFolderName)
//        }
//    }
}
extension DataBaseManager {
    func deleteFolder(_ folderEntity: FolderEntity) {
        context.delete(folderEntity)
        do {
            try context.save()
            refreshFolders()
        } catch {
            print("Error deleting folder: \(error)")
        }
    }
}

