import SwiftUI
import CoreData

struct DocumentListView: View {
    var document: DocumentEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(document.name ?? "")
                .font(.headline)
            
            HStack {
                if let createdDate = document.createdDate {
                    Text(createdDate, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
                
                if let updatedDate = document.updatedDate, updatedDate != document.createdDate {
                    Text(updatedDate, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
            }
            .font(.caption)
        }
    }
}
