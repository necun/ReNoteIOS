//
//  ContentView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 14/02/24.
//

import SwiftUI
import SwiftData

struct DocumentDetailsViewExtention: View {
    @Bindable var document: Document

    var body: some View {
        Form() {
            TextField("Name", text: $document.name)
                .onChange(of: document.name) { oldValue, newValue in
                    document.updatedDate = Date.now
                    document.isSynced = false
                }
        }
    }
}

struct DocumentDetailView: View {
    @Bindable var document: Document
   
    var body: some View {
        DocumentDetailsViewExtention(document: document)
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Document.self, configurations: config)
//        let folder = Folder.init(id: "", name: "", updatedDate: Date.now, createdDate: Date.now, isSyced: false, isFavourite: true, isPin: true, driveType: StoragePlace.Google.rawValue, fileCount: 10)
//        
//        let example = Document(id: "", name: "", createdDate: Date.now, updatedDate: Date.now, fileData: Data(), isSynced: true, isPin: false, isFavourite: false, folderId: "", tagId: "", openCount: 0, localFilePathIos: "", localFilePathAndroid: "", driveType: "", fileExtension: "");
//        return DocumentDetailView(document: example).modelContainer(container)
//    }
//    catch{
//        fatalError("Failed to create")
//    }
//    
//}

