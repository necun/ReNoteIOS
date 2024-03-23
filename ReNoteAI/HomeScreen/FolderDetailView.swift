import SwiftUI
import CoreData

struct FolderDetailsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""

    let folder: FolderEntity

    // FetchRequest to get documents related to the selected folder
    var fetchRequest: FetchRequest<DocumentEntity>
    var documents: FetchedResults<DocumentEntity> { fetchRequest.wrappedValue }

    init(folder: FolderEntity) {
        self.folder = folder
        self.fetchRequest = FetchRequest<DocumentEntity>(
            entity: DocumentEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \DocumentEntity.createdDate, ascending: true)],
            predicate: NSPredicate(format: "folder == %@", folder)
        )
    }
    
    var body: some View {
        VStack {
            // Logo and Search field
            VStack {
                HStack{
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 80)
                    
                    Image("Logo1")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 80)
                    Spacer()
                }
                //                .frame(maxWidth: 200, alignment: .leading)
                .padding(.leading)
                .padding(.bottom, 10)
                
                
                
                
                // Replace with your second logo image name if needed
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.white))
                        .cornerRadius(50)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.gray, lineWidth: 1) // You can adjust the color and line width as needed.
                        )
                    
                    Button(action: {
                        
                    }){
                        Image("Logo")
                    }
                    
                    
                    
                }
                .frame(height: 36) // Adjust to match your design
                .padding(.horizontal)
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            
            // Breadcrumbs
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Home")
                        .foregroundColor(.black)
                }
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
                
                Text(folder.name ?? "")
                    .foregroundColor(.green)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            ScrollView {
                ForEach(documents, id: \.self) { document in
                    NavigationLink(destination: MultiImageDisplayView(document: document)) {
                        DocumentCellView(document: document)
                    }
                }
                .onDelete(perform: deleteDocuments) // Ensure this is applied directly to the ForEach
            }

        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
    
    
    func DocumentCellView(document: DocumentEntity) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.05)) // Background color of the rectangle
                .shadow(radius: 10, x: 10, y: 10) // Slight shadow for depth
            HStack(spacing: 12) {
                Image("Thumbnail1") // Replace with appropriate icons
                    .resizable()
                    .frame(width: 66, height: 62)
                
                Text(document.name ?? "")
                    .font(.footnote)
                
                // NavigationLink aligned beside the image
                //                            NavigationLink(destination: DocumentDetailView(document: document)) {
                //                                DocumentListView(document: document)
                //                            }
                
                    .frame(alignment: .leading)
                
                
                Spacer()
                
                VStack{
                    HStack(spacing: 15) {
                        Button(action: {
                            // Favorite action
                        }) {
                            Image("Pin") // Favorite (pin) icon
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            // More options action
                        }) {
                            Image("Share") // Use systemName for sharing icon
                                .foregroundColor(.gray)
                        }
                    }
                    .imageScale(.large)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                    
                    HStack {
                        // Then, add the "Personal" text below the buttons HStack
                        Text("Personal")
                            .font(.caption) // Customize the font as needed
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    // Additional modifiers for the VStack can be placed here if needed
                    
                    Spacer()
                    
                    // Aligns buttons to the right
                    HStack(spacing : 17) {
                        Button(action: {
                            // Sync action
                        }) {
                            Image("Cloud1") // Sync icon
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            // Favorite action
                        }) {
                            Image(systemName: "star") // Favorite icon
                                .foregroundColor(.gray)
                        }
                        
                        HStack(alignment: .lastTextBaseline){
                            Menu {
                                Button("Rename", action: { /* sorting by name */ })
                                Button("Update", action: { /* sorting by date created */ })
                                Divider()
                                Button("Delete", action: { /* sorting by date modified */ })
                                    .foregroundColor(.red)
                            } label: {
                                Image("Options")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .imageScale(.medium)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                .padding()
                
            }
            .padding(.horizontal, 12)
            
            // Add padding inside HStack for better spacing
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity,maxHeight: 180)
        .contextMenu { // Context menu added here
            Button(action: {
                // Delete action
                deleteDocument(document)
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    
    private func deleteDocument(_ documentToDelete: DocumentEntity) {
        viewContext.delete(documentToDelete)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
    private func deleteDocuments(at offsets: IndexSet) {
        for index in offsets {
            let document = documents[index]
            viewContext.delete(document)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
