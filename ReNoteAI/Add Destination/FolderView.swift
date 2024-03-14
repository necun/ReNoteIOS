import SwiftUI
import SwiftData
import CoreData
 
 
struct ImportScreen: View {
    @Environment(\.modelContext) private var modelContext
    var folders: [Folder] {
        dataBaseManager.folders
    }
    var onSaveFolder: ((Folder) -> Void)
    
 
    @State private var isScannerPresented = false
    @Binding var scannedImages: [UIImage]

    
    @ObservedObject var dataBaseManager = DataBaseManager.shared
    @State private var sortOrder = SortDescriptor(\Folder.name)
    @State private var selectedFolderID: String?
    @State private var searchString = ""
    @State private var showingAddFolderAlert = false
       @State private var newFolderName = ""
    @State private var showingAddFolderModal = false
    @State private var showDocumentScanner = false
 
 
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedSegment = 0
       @State private var searchText = ""
    
    struct folder: Identifiable {
        var id = UUID()
        var name: String
        // Add other properties you need
    }
 
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
                           ForEach(dataBaseManager.folders) { folder in
                               Button(action: {
                                   // Toggle selection
                                   withAnimation {
                                       if selectedFolderID == folder.id {
                                           // If this folder is already selected, deselect it
                                           selectedFolderID = nil
                                       } else {
                                           // Otherwise, select this folder
                                           selectedFolderID = folder.id
                                       }
                                   }
                                   onSaveFolder(folder)
                               }) {
                                   HStack {
                                       Text(folder.name)
                                       Spacer()
                                       if selectedFolderID == folder.id {
                                           Image(systemName: "checkmark")
                                               .foregroundColor(.blue)
                                       }
                                   }
                               }
                               .padding()
                               .background(selectedFolderID == folder.id ? Color.blue.opacity(0.2) : Color.clear) // Change background based on selection
                               .cornerRadius(5)
                           }
                           .onDelete(perform: deleteItems)
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
       }
    
    private func saveScannedImages() {
        for image in scannedImages {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Failed to convert one of the images to JPEG.")
                continue
            }

            let documentName = "Scanned Image \(Date())"
            print("Saving document named: \(documentName) with folderId: \(String(describing: selectedFolderID))")
            dataBaseManager.saveDocument(name: documentName, fileData: imageData, folderId: selectedFolderID)
        }
        scannedImages.removeAll()
        presentationMode.wrappedValue.dismiss()
    }

       



    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let folder = folders[index]
                dataBaseManager.deleteFolder(folder)
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
    func deleteFolder(_ folder: Folder) {
        guard let id = UUID(uuidString: folder.id) else { return }
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let folderEntity = results.first {
                context.delete(folderEntity)
                try context.save()
                
                // Optionally, refresh the folders to reflect this deletion in the UI
                refreshFolders()
            }
        } catch {
            print("Error deleting folder: \(error)")
        }
    }
}
