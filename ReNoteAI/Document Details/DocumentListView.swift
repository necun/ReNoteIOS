//
//  ContentView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 14/02/24.
//

import SwiftUI
import SwiftData

struct DocumentListView: View {
    @Bindable var document: Document
    
    var body: some View {
        VStack(alignment: .leading){
            Text(document.name)
                .font(.headline)
            HStack{
                Text(document.createdDate, format: Date.FormatStyle(date: .numeric, time: .standard))
                if (document.createdDate != document.updatedDate) {
                    Text(document.updatedDate, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
            }
            .font(.caption)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Document.self, configurations: config)

        let example = Document(id: "", name: "", createdDate: Date.now, updatedDate: Date.now, fileData: Data(), isSynced: true, isPin: false, isFavourite: false, folderId: "", tagId: "", openCount: 0, localFilePathIos: "", localFilePathAndroid: "", driveType: "", fileExtension: "");
        return DocumentListView(document: example).modelContainer(container)
    }
    catch{
        fatalError("Failed to create")
    }
    
}

