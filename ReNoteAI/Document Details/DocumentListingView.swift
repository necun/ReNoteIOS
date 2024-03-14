//
//  DocumentListingView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 15/02/24.
//

import Foundation
import SwiftData
import SwiftUI
import CoreData

struct DocumentListingView: View {
    var folderId: String?
    @ObservedObject var dataBaseManager = DataBaseManager.shared
    
    var fetchRequest: FetchRequest<DocumentEntity>
    var documents: FetchedResults<DocumentEntity> { fetchRequest.wrappedValue }
    
    
    init(folderId: String? = nil) {
        if let folderId = folderId {
            fetchRequest = FetchRequest<DocumentEntity>(
                entity: DocumentEntity.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \DocumentEntity.updatedDate, ascending: false)],
                predicate: NSPredicate(format: "folder.id == %@", folderId)
            )
        } else {
            // Fetch all documents
            fetchRequest = FetchRequest<DocumentEntity>(
                entity: DocumentEntity.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \DocumentEntity.updatedDate, ascending: false)]
            )
        }
    }

    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                List{
                    ForEach(dataBaseManager.documents, id: \.id) { document in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.05)) // Background color of the rectangle
                                .shadow(radius: 10, x: 10, y: 10) // Slight shadow for depth
                            HStack(spacing: 12) {
                                Image("Thumbnail1") // Replace with appropriate icons
                                    .resizable()
                                    .frame(width: 66, height: 62)
                                
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
                }
                //                .onDelete(perform: deleteItems)
                
            }
        }
        
        
    }
    
    //    init(folderId: String?) {
    //        self.folderId = folderId
    //        // Initialize fetch request if needed
    //    }
    
    
    //    init(sort: SortDescriptor<Document>, searchString: String) {
    //        _documents = Query(filter: #Predicate{
    //            if searchString.isEmpty {
    //                return true
    //            } else {
    //                return $0.name.localizedStandardContains(searchString)
    //            }
    //        }, sort: [sort])
    //    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            for index in offsets {
    //                modelContext.delete(documents[index])
    //            }
    //        }
    //    }
    //}
    
    //    private func deleteItems(offsets: IndexSet) {
    //           withAnimation {
    //               offsets.map { documents[$0] }.forEach(ManagedObjectContext.shared.delete)
    //               ManagedObjectContext.shared.saveContext()
    //           }
    //       }
    //   }
    //
    //extension ManagedObjectContext {
    //    static var shared: NSManagedObjectContext = {
    //        // return your CoreData managed object context
    //    }()
    //
    //    func saveContext() {
    //        if self.hasChanges {
    //            do {
    //                try save()
    //            } catch {
    //                // Handle the CoreData save error
    //            }
    //        }
    //    }
}
