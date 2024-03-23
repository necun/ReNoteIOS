import SwiftUI
import SwiftyDropbox
import CoreData
 
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
 
extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}


 
struct HomeScreen: View {
    
    
    @Environment(\.modelContext) private var modelContext
    @State var showBannerView: Bool = true
    @ObservedObject var dataBaseManager = DataBaseManager.shared
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    
    @State private var searchString = ""
    @FetchRequest(
           sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.email, ascending: true)],
           animation: .default)
       private var users: FetchedResults<UserEntity>
       
       @FetchRequest(
           sortDescriptors: [NSSortDescriptor(keyPath: \FolderEntity.name, ascending: true)],
           animation: .default)
       private var folders: FetchedResults<FolderEntity>
       
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \DocumentEntity.createdDate, ascending: false)],
            animation: .default)
        private var documents: FetchedResults<DocumentEntity>
    
    
    @State private var selectedDocument: DocumentEntity? = nil
       @State private var showDocumentListView: Bool = false
    @State private var isSearchActive = false
    @State private var sortAscending = true
    @State private var showAddDocumentView = false
    @State private var showProfileView = false
    @State private var selectedTag: String? = "All"
    @State private var showAddNewTagView = false
    @State private var showAddNewFolderView = false
    @State private var path: [AnyHashable] = []
    let sortOrderForFolders = NSSortDescriptor(keyPath: \FolderEntity.name, ascending: true)

 
    @State private var schemaTags: [String] = []
    let transitionAnimation: Animation = .easeInOut(duration: 0.5)
    
    
    
    
    var body: some View {
        NavigationStack(path: $path) {
            
            HStack {
                // Search bar
                TextField("Search", text: $searchString)
                    .padding(7)
                    .padding(.horizontal, 30)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isSearchActive && !searchString.isEmpty {
                                Button(action: {
                                    searchString = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation(transitionAnimation) {
                            isSearchActive = true
                        }
                    }
                
                if isSearchActive {
                    // Cancel button
                    Button("Cancel") {
                        withAnimation(transitionAnimation) {
                            isSearchActive = false
                            searchString = ""
                            hideKeyboard()
                        }
                    }
                    .foregroundColor(.red)
                } else {
                    // Side buttons
                    HStack(spacing: 17) {
                        Button(action: {
                            // Perform action for tag icon
                            self.showAddNewTagView = true
                        }) {
                            Image("Tag")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            // Perform action for folder plus icon
                            self.showAddNewFolderView = true
                        }) {
                            Image("Folderplus")
                                .foregroundColor(.gray)
                        }
                        

                        
                        Menu {
                            Button("Name", action: { /* sorting by name */ })
                            Button("Date Created", action: { /* sorting by date created */ })
                            Button("Date Modified", action: { /* sorting by date modified */ })
                            Divider()
                            HStack{
                                Button(sortAscending ? "Ascending" : "Descending", action: { sortAscending.toggle() })
                                Button(sortAscending ? "Descending" : "Ascending", action: { sortAscending.toggle() })
                            }
                        } label: {
                            Image("Options")
                                .frame(width: 16, height: 21)
                                .foregroundColor(.gray)
                            
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
            .padding()
            
//                    // Your existing code for body
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(spacing: 8) {
//                            ForEach(dataBaseManager.tags, id: \.self) { tag in // Use observed tags here
//                                TagView(title: tag.name, isSelected: tag.name == selectedTag)
//                                    .onTapGesture {
//                                        selectedTag = tag.name
//                                    }
//                            }
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: 60)
//                        .padding(.horizontal)
//                    }
//                    .onAppear {
//                        loadSchemaTags()
//                    }
 
            
            if dataBaseManager.folders.isEmpty&&dataBaseManager.documents.isEmpty {
                if (showBannerView) {
                    RegisterToSyncView(buttonAction: {
                        showBannerView = false
                    })
                }
            }
            
//            if dataBaseManager.folders.isEmpty&&dataBaseManager.documents.isEmpty {
//                    EmptyFilesView()
//                  }
           
            FoldersListView(sort: sortOrderForFolders, searchString: searchString)
                .onAppear {
                    dataBaseManager.refreshFolders()
                }

 
 
            
            
//            DocumentListingView(dataBaseManager: dataBaseManager)
//                            .onAppear {
//                                dataBaseManager.refreshDocuments()
//                            }
             
            ScrollView(.vertical){
                ForEach(documents) { document in
                    NavigationLink(destination: MultiImageDisplayView(document: document), isActive: .constant(false)) {
                                           DocumentCellView(document: document)
                                       }
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color.gray.opacity(0.05)) // Background color of the rectangle
//                                .shadow(radius: 10, x: 10, y: 10) // Slight shadow for depth
//                            HStack(spacing: 12) {
//                                Image("Thumbnail1") // Replace with appropriate icons
//                                    .resizable()
//                                    .frame(width: 66, height: 62)
//                                
//                                Text(document.name ?? "")
//                                    .font(.footnote)
//                                
//                                // NavigationLink aligned beside the image
//                                //                            NavigationLink(destination: DocumentDetailView(document: document)) {
//                                //                                DocumentListView(document: document)
//                                //                            }
//                                
//                                    .frame(alignment: .leading)
//                                
//                                
//                                Spacer()
//                                
//                                VStack{
//                                    HStack(spacing: 15) {
//                                        Button(action: {
//                                            // Favorite action
//                                        }) {
//                                            Image("Pin") // Favorite (pin) icon
//                                                .foregroundColor(.gray)
//                                        }
//                                        
//                                        Button(action: {
//                                            // More options action
//                                        }) {
//                                            Image("Share") // Use systemName for sharing icon
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                    .imageScale(.large)
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                    
//                                    Spacer()
//                                    
//                                    HStack {
//                                        // Then, add the "Personal" text below the buttons HStack
//                                        Text("Personal")
//                                            .font(.caption) // Customize the font as needed
//                                        
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                    
//                                    
//                                    // Additional modifiers for the VStack can be placed here if needed
//                                    
//                                    Spacer()
//                                    
//                                    // Aligns buttons to the right
//                                    HStack(spacing : 17) {
//                                        Button(action: {
//                                            // Sync action
//                                        }) {
//                                            Image("Cloud1") // Sync icon
//                                                .foregroundColor(.blue)
//                                        }
//                                        
//                                        Button(action: {
//                                            // Favorite action
//                                        }) {
//                                            Image(systemName: "star") // Favorite icon
//                                                .foregroundColor(.gray)
//                                        }
//                                        
//                                        HStack(alignment: .lastTextBaseline){
//                                            Menu {
//                                                Button("Rename", action: { /* sorting by name */ })
//                                                Button("Update", action: { /* sorting by date created */ })
//                                                Divider()
//                                                Button("Delete", action: { /* sorting by date modified */ })
//                                                    .foregroundColor(.red)
//                                            } label: {
//                                                Image("Options")
//                                                    .foregroundColor(.gray)
//                                            }
//                                        }
//                                    }
//                                    .imageScale(.medium)
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                    
//                                }
//                                .padding()
//                                
//                            }
//                            .padding(.horizontal, 12)
//                            
//                            // Add padding inside HStack for better spacing
//                        }
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity,maxHeight: 180)
                }
                .onAppear {
                    dataBaseManager.refreshDocuments() // Make sure this method exists and updates the documents
                }
            }


            
                           

                
            
                .toolbar {
                    
                    
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Image("Logo")
                                .resizable() // Make the image resizable.
                                .scaledToFit() // Keep the aspect ratio.
                                .frame(width: 70, height: 70) // Specify the desired width and height.
                            Image("Logo1")
                                .resizable() // Make the image resizable.
                                .scaledToFit() // Keep the aspect ratio.
                                .frame(width: 70, height: 70) // Specify the desired width and height.
                        }
                    }

                    
                    //                    ToolbarItem() {
                    //                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    //                            Picker("Sort", selection: $sortOrder) {
                    //                                Text("Name").tag(SortDescriptor(\Document.name))
                    //                                Text("Date").tag(SortDescriptor(\Document.createdDate, order:.reverse))
                    //                            }
                    //                            .pickerStyle(.inline)
                    //                        }
                    //                    }
                    
                    ToolbarItem() {
                        Button(action: showProfile) {
                            Image("Profile")
                        }
                    }
                }
            
            
            
            NavigationLink(
                destination: AddDocumentView(),
                isActive: $showAddDocumentView
            ) {
                EmptyView()
            }.isDetailLink(false)
            
            NavigationLink(
                destination: ProfileView(),
                isActive: $showProfileView
            ) {
                EmptyView()
            }.isDetailLink(false)
        }
        .sheet(isPresented: $showAddNewTagView) {
            AddNewTagFolderView(type: "tag") { newName in
                //Add new tag here
                print("New Tag is", newName);
                self.showAddNewTagView = false
            }
        }
        .sheet(isPresented: $showAddNewFolderView) {
            AddNewTagFolderView(type: "folder") { newName in
                //Add new tag here
                print("New folder is", newName);
                self.showAddNewFolderView = false
 
 
            }
        }
    }
    
//    private func loadSchemaTags() {
//        // Assuming schemaData() correctly fetches your schema data
//        if let schemaData = schemaData(),
//           let schema = try? JSONSerialization.jsonObject(with: schemaData, options: []) as? [String: Any],
//           let tagsDictionary = schema["tags"] as? [String: [String: Any]] {
//
//            let schemaTags = tagsDictionary.values.compactMap { $0["tagName"] as? String }
//
//            DispatchQueue.main.async {
//                // Update the local state property if needed
//                self.schemaTags = schemaTags
//
//                // Also, update DataBaseManager's tags if it's not already updated
//                for tag in schemaTags {
//                    if !self.dataBaseManager.tags.contains(where: { $0.name == tag }) {
//                        let newTag = Tag(id: UUID().uuidString, name: tag)
//                        self.dataBaseManager.tags.append(newTag)
//                    }
//                }
//            }
//        }
//    }
 
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
    }
        
        
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    
    private func addItem() {
        withAnimation {
            showAddDocumentView = true
        }
    }
    
    private func showProfile() {
        withAnimation {
            showProfileView = true
        }
    }
}

 
struct MyDetent: CustomPresentationDetent {
    // 1
    static func height(in context: Context) -> CGFloat? {
        // 2
        return max(50, context.maxDetentValue * 0.5)
    }
}
 
 
// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
