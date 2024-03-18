import SwiftUI
import CoreData

struct MultiImageDisplayView: View {
    let document: DocumentEntity

    var body: some View {
        ScrollView {
            VStack {
                ForEach(document.imagesArray, id: \.self) { imageEntity in
                    if let imageData = imageEntity.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
}

extension DocumentEntity {
    var imagesArray: [ImageEntity] {
        // Assuming 'images' is the correct relationship name
        let set = self.image as? Set<ImageEntity> ?? []
        return Array(set).sorted { $0.createdDate ?? Date() < $1.createdDate ?? Date() }
    }
}



//struct DocumentSummaryView: View {
//    let document: DocumentEntity
//
//    var body: some View {
//        HStack {
//        }
//        .padding()
//    }
//}
