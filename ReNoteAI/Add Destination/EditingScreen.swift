import SwiftUI


class NavigationViewModel: ObservableObject {
    // This property triggers the navigation when set to true
    @Published var shouldNavigateToHome = false
}

struct PreviewAndEditingScreen: View {
    @Binding var scannedImages: [UIImage] // Changed to @Binding
    @State private var currentIndex: Int = 0
    @State private var showingFilterSelection = false
    @Binding var selectedFilter: PreviewAndEditingScreen.FilterType
    @Binding var filterContrast: CGFloat
    @State private var isAutoEnhanceSelected: Bool = false
    @State private var isCropSelected: Bool = false
    @State private var isFilterSelected: Bool = false
    @State private var showingShareSheet = false
    @State private var showingShareOptions = false
    @State private var shareOption: ShareOption = .single
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isCroppingPresented = false
    @Environment(\.managedObjectContext) var managedObjectContext
//    @State private var navigateToHome = false

    
    
    
    


    
    
    // Define your action closures
        var autoEnhance: () -> Void
        var cropImage: () -> Void
        var applyFilter: () -> Void
        var rotateImage: () -> Void
        var deleteImage: () -> Void
        var goBack: () -> Void
        var retake: () -> Void
        var scanMore: () -> Void
        var share: () -> Void
        var save: () -> Void
    
    
    enum FilterType {
        case original
        case grayscale
        case blackAndWhite
       
    }
    
    enum ShareOption {
        case single, all
    }

    
    var body: some View {
        NavigationView{
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Background extends to the edges
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Preview")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    
                    Divider().background(Color.white)
                    
                    Spacer()
                    
                    // Scanned Document Image Placeholder
                    TabView(selection: $currentIndex) {
                        ForEach(scannedImages.indices, id: \.self) { index in
                            Image(uiImage: scannedImages[index])
                                .resizable()
                                .scaledToFit()
                                .tag(index) // Ensure each page in the TabView is tag with its index
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Use .always to always show the index
                    
                    .onAppear {
                        currentIndex = 0 // Reset currentIndex to 0 when view appears
                    }
                    
                    
                    // Page indicator at the bottom
                    HStack {
                        Spacer()
                        Text("\(currentIndex + 1)/\(scannedImages.count)")
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    
                    // Custom bottom bar with tools
                    customBottomBar
                }
                
            }
        }
        // Inside the body of PreviewAndEditingScreen
    }

    // Extracted custom bottom bar view to clean up body
    var customBottomBar: some View {
        VStack(spacing: 20) {
           
            HStack {
                Spacer()
                Button(action: {
                    isAutoEnhanceSelected = true
                    isCropSelected = false
                    isFilterSelected = false
                    autoEnhance()

                })  {
                    VStack {
                        Image("Auto")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(/*isAutoEnhanceSelected ?*/ Color.green /*: Color.black*/)                        
                        Text("Auto")
                            .font(.system(size: 12))
                            .foregroundColor(/*isAutoEnhanceSelected ?*/ Color.green /*: Color.black*/)
                    }
                }
                Spacer()
                Button(action: {
                    isCroppingPresented = true
                }) {
                    VStack {
                        Image("Crop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(isCropSelected ? Color.green : Color.black)

                        Text("Crop")
                            .font(.system(size: 12))
                            .foregroundColor(isCropSelected ? Color.green : Color.black)


                    }
                }
                .fullScreenCover(isPresented: $isCroppingPresented) {
                    CroppingScreen(originalImage: scannedImages[currentIndex], isPresented: $isCroppingPresented) { croppedImage in
                        scannedImages[currentIndex] = croppedImage
                        // Perform any additional updates if needed
                    }
                }
                Spacer()
                
                
                Button(action: {
                    showingFilterSelection.toggle()
                    isFilterSelected = showingFilterSelection
                    isAutoEnhanceSelected = false
                    isCropSelected = false
                    applyFilter()
                }) {
                    VStack {
                        Image("Filter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(/*isFilterSelected ? Color.green :*/ Color.black)

                        Text("Filter")
                            .font(.system(size: 12))
                            .foregroundColor(/*isFilterSelected ? Color.green :*/ Color.black)


                    }
                }
                .fullScreenCover(isPresented: $showingFilterSelection) {
                    FilterSelectionView(
                        selectedFilter: $selectedFilter,
                        filterContrast: $filterContrast,
                        applyFilter: { filterType in
                            // Here, you would apply the filter to the current image
                            // This requires moving some of the image processing logic into PreviewAndEditingScreen or its view model
                        },
                        onDone: { editedImage in
                            // Optionally update the current image with the edited image
                            if let editedImage = editedImage, currentIndex < scannedImages.count {
                                scannedImages[currentIndex] = editedImage
                            }
                        }, scannedImages: $scannedImages,
                        currentImage: scannedImages[currentIndex]
                    )
                }

                Spacer()
                Button(action:  rotateImageAtIndex) {
                    VStack {
                        Image("Rotate")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Rotate")
                            .font(.system(size: 12))

                    }
                }
                Spacer()
                Button(action: {
                    deleteImageAtIndex()
                }) {
                    VStack {
                        Image("Delete")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Delete")
                            .font(.system(size: 12))

                    }
                }
                Spacer()
            }
            
            // Footer with additional actions
            HStack {
                Spacer()
                Button(action: {
//                    if navigationViewModel.shouldNavigateToHome {
//                        HomeScreen()
//                            .onAppear {
//                                navigationViewModel.shouldNavigateToHome = false
//                            }
//                    }
                   
                }) {
                    VStack {
                        Image("Back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)

                        Text("Back")
                            .font(.system(size: 12))

                    }
                }

                
                
                Spacer()
                Button(action: retake) {
                    VStack {
                        Image("Retake")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Retake")
                            .font(.system(size: 12))

                    }
                }
                Spacer()
                Button(action: scanMore) {
                    VStack {
                        Image("Scanmore")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Scan More")
                            .font(.system(size: 12))

                    }
                }
                Spacer()
                Button(action: {
                    showingShareOptions = true
                }) {
                    VStack {
                        Image("Share1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Share")
                            .font(.system(size: 12))

                    }
                }
                .actionSheet(isPresented: $showingShareOptions) {
                    ActionSheet(
                        title: Text("Share Options"),
                        message: Text("Choose an option to share"),
                        buttons: [
                            .default(Text("Share This Image")) {
                                shareOption = .single
                                showingShareSheet = true // Trigger the share sheet after selection
                            },
                            .default(Text("Share All Images")) {
                                shareOption = .all
                                showingShareSheet = true // Trigger the share sheet after selection
                            },
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $showingShareSheet) {
                    // This logic assumes `showingShareSheet` is only true after a selection from the action sheet
                    if shareOption == .single {
                        let imageToShare =  scannedImages[currentIndex]
                        ShareSheet(items: [imageToShare])
                            .presentationDetents([.medium])
                    } else {
                        // Create an array of non-nil edited images, falling back to original images if necessary
                        let imagesToShare = (0..<scannedImages.count).compactMap {  scannedImages[$0] }
                        ShareSheet(items: imagesToShare)
                            .presentationDetents([.medium])
                    }
                }
                Spacer()
                Button(action: {
                    
                    saveScannedImages() // Call the saving function directly here
                    presentationMode.wrappedValue.dismiss()
                }) {
                    VStack {
                        Image("Save")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Save")
                            .font(.system(size: 12))

                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.8)) // Set the bottom bar background to a lighter black by adjusting opacity
        .foregroundColor(.black) // Set the icon and text color to white
        .cornerRadius(30) // Adjust to match your design
        .shadow(color: .gray, radius: 2, x: 0, y: -1)
    }
    
    func deleteImageAtIndex() {
        // Check if the current index is within range
        guard scannedImages.indices.contains(currentIndex) else { return }

        // Remove the image at the current index
        scannedImages.remove(at: currentIndex)

        // After deletion, if no images are left, navigate back
        if scannedImages.isEmpty {
            // Assuming you have a navigation view model or similar logic
            // This example will use `presentationMode` for simplicity
            presentationMode.wrappedValue.dismiss()
        } else {
            // Adjust currentIndex to prevent out-of-range errors
            currentIndex = max(currentIndex - 1, 0)
        }
    }
    
    func saveScannedImages() {
        let newDocument = DocumentEntity(context: managedObjectContext)

        // Set the document's properties
        newDocument.createdDate = Date()
        newDocument.name = "Document \(Date())"
        newDocument.id = UUID()

        // Add the scanned images to the document
        for image in scannedImages {
            let imageData = ImageEntity(context: managedObjectContext)
            imageData.imageData = image.jpegData(compressionQuality: 1.0)
            newDocument.addToImage(imageData) // Assuming your relationship is called `images`
        }

        do {
            try managedObjectContext.save()
            // Optionally perform actions after saving, such as showing an alert or updating a state variable
        } catch {
            // Handle the error appropriately
            print("Error saving document: \(error)")
        }
    }
    
    
    
    func rotateImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        var transform = CGAffineTransform(rotationAngle: -.pi / 2)
        let rotatedSize = CGRect(origin: .zero, size: image.size).applying(transform).size
        transform = transform.translatedBy(x: 0, y: rotatedSize.width)
        transform = transform.scaledBy(x: rotatedSize.height/rotatedSize.width, y: rotatedSize.width/rotatedSize.height)
        
        UIGraphicsBeginImageContext(rotatedSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: -.pi / 2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
    
    
    
    func rotateImageAtIndex() {
        guard scannedImages.indices.contains(currentIndex), let rotatedImage = rotateImage(scannedImages[currentIndex]) else {
            return
        }

        // Update the image at the current index with the rotated image
        scannedImages[currentIndex] = rotatedImage
    }



    
    
}

// The rest of your code for the DocumentScannerViewModel goes here...

    // Replace with actual logic for your ViewModel
    class DocumentScannerViewModel: ObservableObject {
        @Published var scannedImages: [UIImage] = []
        @State private var showingFilterSelection = false


        func autoEnhance() {
            // Logic for auto enhancing
        }

//        func cropImage() {
//            // Logic for cropping image
//        }

        func applyFilter() {
            showingFilterSelection = true
        }

        func rotateImage() {
            // Logic for rotating image
        }

//        func deleteImage() {
//            // Logic for deleting image
//        }

        func goBack() {
            // Logic for going back
        }

        func retake() {
            // Logic for retaking
        }

        func addScannedImages(_ newImages: [UIImage]) {
            scannedImages.append(contentsOf: newImages)
            // Logic for scanning more images
        }

        func share() {
            // Logic for sharing
        }

        func save() {
            // Logic for saving
        }
    }







struct PreviewAndEditingScreen_Previews: PreviewProvider {
    @State static var scannedImages: [UIImage] = [UIImage(named: "SampleImage")].compactMap { $0 }
    @State static var selectedFilter: PreviewAndEditingScreen.FilterType = .original
    @State static var filterContrast: CGFloat = 1.0

    static var previews: some View {
        // Bind the state variables to PreviewAndEditingScreen
        PreviewAndEditingScreen(
            scannedImages: .constant(scannedImages),
            selectedFilter: .constant(selectedFilter),
            filterContrast: .constant(filterContrast),
            autoEnhance: {},
            cropImage: {},
            applyFilter: {},
            rotateImage: {},
            deleteImage: {},
            goBack: {},
            retake: {},
            scanMore: {},
            share: {},
            save: {}
        )
    }
}
