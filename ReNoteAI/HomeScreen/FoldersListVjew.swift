import SwiftUI
import SwiftData
 
struct FoldersListView: View {
    
    
    @ObservedObject var dataBaseManager: DataBaseManager
    // Use `dataBaseManager.folders` to populate your view
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Folder.updatedDate, order: .reverse), SortDescriptor(\Folder.name, order: .reverse)])
    var folders: [Folder]
 
    init(dataBaseManager: DataBaseManager, sort: SortDescriptor<Folder>, searchString: String) {
        self.dataBaseManager = dataBaseManager
        _folders = Query(filter: #Predicate{
            if searchString.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
 
    
    var body: some View {
        ScrollView(.horizontal) {
            // 2
            LazyHStack {
                ForEach(dataBaseManager.folders) { folder in
                    ZStack(alignment: .topLeading) { // Align content to the top left
                        // Background rectangle
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.05)) // Background color of the rectangle
                            .shadow(radius: 10, x: 10, y: 10) // Slight shadow for depth
                        
                        VStack(alignment: .leading) {
                            HStack {
                                HStack{
                                    Image("GdriveFolder") // Your folder image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40) // Adjust the size as needed
                                        .padding(.top, 10)
                                        .padding(.leading, 10)
                                }
                                
                                Spacer(minLength: 20)
                                
                                // File count and sync status
                                // Three dots button
                                HStack(spacing: 10){
                                    
                                    HStack{
                                        Text(String(folder.fileCount)) // Replace with your file count
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    HStack {
                                        Button(action: {
                                            // Your action here
                                        }) {
                                            Image("Pin") // Use your actual image name if it's different
                                                .foregroundColor(.gray)
                                                .imageScale(.small)
                                        }
                                    }
 
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
                                .padding()
                    
                            
 
                            }
                            // Folder name and email
                            
                            HStack{
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(folder.name) // The folder's name
                                        .font(.headline) // Adjust font as needed
                                        .lineLimit(1) // Ensures text does not wrap
                                    
                                    Text(folder.id) // Replace with actual property
                                        .font(.caption) // Adjust font as needed
                                        .foregroundColor(.gray) // Adjust text color as needed
                                }
                                .padding([.leading], 10) // Align text with the image above
                                .padding([.bottom], 10) // Padding at the bottom
                                
                                Spacer()
                                
                                HStack{
                                    Image("Cloud1")
                                        .imageScale(.small)
                                        
                                }
                                .padding(.horizontal)
                                
                                
                            }
                            
                            Spacer() // Pushes everything to the top
                        }
                    }
                    .frame(width: 169, height: 100) // Adjust the size as needed
                    .contextMenu {
                        Button(action: {
                            // Delete action
                            dataBaseManager.deleteFolder(folder)
                        }) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading) // Ensures the HStack takes full available width
            .padding(.horizontal, 18) // Horizontal padding
            
        }
    }
}
