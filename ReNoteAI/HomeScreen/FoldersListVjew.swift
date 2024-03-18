import SwiftUI
import CoreData

struct FoldersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let searchString: String
    var fetchRequest: FetchRequest<FolderEntity>
    var folders: FetchedResults<FolderEntity> { fetchRequest.wrappedValue }

    init(sort: NSSortDescriptor, searchString: String) {
        self.searchString = searchString
        self.fetchRequest = FetchRequest<FolderEntity>(
            entity: FolderEntity.entity(),
            sortDescriptors: [sort],
            predicate: searchString.isEmpty ? nil : NSPredicate(format: "name CONTAINS[cd] %@", searchString)
        )
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(folders, id: \.self) { folder in
                    NavigationLink(destination: FolderDetailsView(folder: folder)) {
                        ZStack(alignment: .topLeading) { // Align content to the top left
                            // Background rectangle
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.05)) // Background color of the rectangle
                                .shadow(radius: 10, x: 10, y: 10) // Slight shadow for depth

                            VStack(alignment: .leading) {
                                HStack {
                                    Image("GdriveFolder") // Your folder image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40) // Adjust the size as needed
                                        .padding(.top, 10)
                                        .padding(.leading, 10)

                                    Spacer(minLength: 20)

                                    HStack(spacing: 10) {
                                        Text(String(folder.fileCount)) // File count
                                            .font(.caption)
                                            .foregroundColor(.gray)

                                        Button(action: {
                                            // Action for pin button
                                        }) {
                                            Image("Pin") // Use your actual image name if it's different
                                                .foregroundColor(.gray)
                                                .imageScale(.small)
                                        }

                                        Menu {
                                            Button("Rename", action: { /* Rename action */ })
                                            Button("Update", action: { /* Update action */ })
                                            Divider()
                                            Button("Delete", action: { /* Delete action */ })
                                                .foregroundColor(.red)
                                        } label: {
                                            Image("Options")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                }

                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(folder.name ?? "")
                                            .font(.headline)
                                            .lineLimit(1)

                                        Text(folder.id?.uuidString ?? "")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding([.leading], 10)
                                    .padding([.bottom], 10)

                                    Spacer()

                                    Image("Cloud1")
                                        .imageScale(.small)
                                        .padding(.horizontal)
                                }

                                Spacer() // Pushes everything to the top
                            }
                        }
                        .frame(width: 169, height: 100) // Adjust the size as needed
                        .contextMenu {
                            Button(action: {
                                // Delete action for the folder
                            }) {
                                Label("Delete", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading) // Ensures the HStack takes full available width
            .padding(.horizontal, 18) // Horizontal padding
        }
    }
}
