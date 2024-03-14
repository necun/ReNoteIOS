import SwiftUI
import SwiftData
import PhotosUI
import UniformTypeIdentifiers
import VisionKit
 
 
 
struct DocumentScanner: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var scannedImages: [UIImage]
    var completion: (() -> Void)? // Completion closure
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
 
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
 
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScanner
 
        init(_ parent: DocumentScanner) {
            self.parent = parent
        }
 
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            parent.scannedImages = []
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                parent.scannedImages.append(image)
            }
            print("Scanned images count: \(parent.scannedImages.count)") // Check how many images are scanned
            parent.completion?() // Call the completion handler
            parent.presentationMode.wrappedValue.dismiss()
        }
 
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
 
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            // You could handle errors here if needed
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

 
 
 
enum FilePickerType: String, CaseIterable {
    case selectImage = "Select Image"
    case uploadDocument = "Upload Document"
    case camera = "Take a picture"
}
 
struct AddDocumentView: View {
//    //This is to send
    @State private var fileName: String = ""
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedFileURL: URL?
    
    @State private var showPhotosPicker: Bool = false
    @State private var showFilePicker: Bool = false
    @State private var showCamera: Bool = false
 
    @State private var showActionSheet = false
    @State private var showFoldersListScreen = false
    @State private var selectedFolder:Folder?
    @State private var selectedUIImage: UIImage? = nil
    @State private var scannedImages: [UIImage] = []
    @State private var showDocumentScanner = false
 
 
 
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading){
                    TextField("Name", text: $fileName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                VStack {
                    Button(action: {
                        self.showActionSheet = true
                    }) {
                        // If a selected UIImage is available, display it
                        if let selectedImage = selectedUIImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                        }
                        // If a file URL is selected and it's not an image, display a generic document view
                        else if let url = selectedFileURL, selectedUIImage == nil {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.05))
                                        .shadow(radius: 10, x: 10, y: 10)
                                    HStack(spacing: 12) {
                                        Image("Thumbnail1") // Ideally, replace with a document icon
                                            .resizable()
                                            .frame(width: 66, height: 62)
 
                                        Text(url.lastPathComponent)
                                            .font(.headline)
                                            .foregroundColor(Color.primary)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .padding(.horizontal, 10)
                                    }
                                    .frame(alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        // If scanned images are available, display the first one
                        else if !scannedImages.isEmpty {
                            Image(uiImage: scannedImages[0])
                                .resizable()
                                .scaledToFit()
                        }
                        // Default placeholder if no image or file is selected
                        else {
                            Image("UploadCl")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
 
                
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Choose an option"), buttons: [
                        .default(Text("Select Images")) { self.showPhotosPicker = true },
                        .default(Text("Camera")) { self.showDocumentScanner = true },
                        .default(Text("Upload Document")) { self.showFilePicker = true },
                        .cancel()
                    ])
                }
 
                .fullScreenCover(isPresented: $showDocumentScanner) {
                    DocumentScanner(scannedImages: $scannedImages)
                }
                
                
                VStack{
                    Button(action: {
                        self.showActionSheet = true
                    }) {
                        VStack {
                            Image("Upload") // SF Symbol for image placeholder
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                            
                            
                        }
                    }
                }
                .padding()
                
                
                
                
                VStack(spacing: 0) { // Set spacing to 0 to remove gaps between VStack children
                    Button(action: {
                        self.showFoldersListScreen = true
                    }) {
                        HStack {
                            Image(systemName: "folder") // Use the folder icon from SF Symbols
                                .foregroundColor(.blue) // Change the color to blue or as needed
                            Text("Folder")
                                .foregroundColor(.black) // Change the text color to black or as needed
                            Spacer() // This will push the icon and text to the left and the chevron to the right
                            Image(systemName: "chevron.right") // Use the chevron right icon from SF Symbols
                                .foregroundColor(.gray) // Change the color to gray or as needed
                        }
                        .padding(.vertical, 10) // Adjust vertical padding to match your UI needs
                        .padding(.horizontal) // Add horizontal padding
                        .frame(height: 40) // Set the button height
                        .cornerRadius(20) // Adjust the corner radius to match your UI
                    }
                    .padding()
                    
                    
                    Button("Save") {
//                        Task {
//                            await uploadFiles()
//                        }
                    }
                    
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8) // Reduced vertical padding for a smaller button
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40) // Reduced height
                    .background(Color.green)
                    .cornerRadius(20) // Adjusted corner radius to fit the smaller size
                }
                .padding()
                .padding(.bottom, 20) // This applies padding around the entire VStack, but not between the buttons
                Spacer()
                
                NavigationLink(
                    destination: ImportScreen(
                        onSaveFolder: { folder in
                            // Your code here
                            print("Selected folder is", folder.name)
                            self.saveSelectedFolder(folder: folder)
                            self.showFoldersListScreen = false
                        },
                        scannedImages: $scannedImages,
                        dataBaseManager: DataBaseManager.shared // Assuming DataBaseManager is a singleton
                    ),
                    isActive: $showFoldersListScreen
                ) {
                    EmptyView()
                }.isDetailLink(false)
            }
            
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedImages, maxSelectionCount: 1)
        .onChange(of: selectedImages) { items in
            // Handle the selected photos here
            processSelectedItem(selectedImages[0])
        }
        
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [UTType.item]) { result in
            switch result {
            case .success(let file):
                // Process the selected file
                self.selectedFileURL = file.startAccessingSecurityScopedResource() ? file : nil
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
 
//    func uploadFiles() async {
//        if let url = selectedFileURL{
//            if let folderID = selectedFolder?.id {
//                await GoogleAuthentication.shared.uploadFile(fileURL: url, fileName:fileName, folderID:folderID)
//            }
//            else {
//                let mainFolderID = DataBaseManager.shared.getMainFolderID()
//                if let id = mainFolderID {
//                    await GoogleAuthentication.shared.uploadFile(fileURL: url, fileName:fileName, folderID:mainFolderID)
//                }
//            }
//        }
//    }
    
   
    
    func processSelectedItem(_ selectedItem: PhotosPickerItem) {
            selectedItem.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.selectedUIImage = uiImage
                        }
                        // Convert the UIImage to a Document and append to the documents array
                        if let url = saveImageToTemporaryFile(image: uiImage) {
                            selectedFileURL = url
                        }
                    }
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
        }
 
    // Inside AddDocumentView
    func saveSelectedFolder(folder:Folder) {
        // Save or process the folder information as needed
        selectedFolder = folder
    }
}
 
 
func saveImageToTemporaryFile(image: UIImage) -> URL? {
    guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
    let temporaryDirectoryURL = FileManager.default.temporaryDirectory
    let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
    
    do {
        try data.write(to: fileURL)
        return fileURL
        
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
 
 
 
 
struct AddDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        AddDocumentView()
    }
}
