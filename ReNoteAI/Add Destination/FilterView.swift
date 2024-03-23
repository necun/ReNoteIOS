import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Combine




struct FilterSelectionView: View {
    @Binding var selectedFilter: PreviewAndEditingScreen.FilterType
    @Binding var filterContrast: CGFloat
    var applyFilter: (PreviewAndEditingScreen.FilterType) -> Void
    var onDone: (UIImage?) -> Void
    @Binding var scannedImages: [UIImage] // Changed to @Binding
    // Add a UIImage to hold the current image
    var currentImage: UIImage
    @State private var isAutoEnhanceSelected: Bool = false
    @State private var fileName: String = ""
    @State private var filterBrightness: CGFloat = 0.0
   

    
    
    
    // State for the preview image
    @State private var previewImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    enum FilterType {
        case original
        case grayscale
        case blackAndWhite
    }
    
    var body: some View {
        
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    TextField("File Name", text: $fileName)
                        .foregroundColor(.white) // Set text color to white
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 32)) // Adjust padding as needed
                        .background(Color.black) 
                        // Set the background color to black
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.green, lineWidth: 1) // Set the border color to green
//                        )
//                        .cornerRadius(10) // Round the corners of the TextField
                    
                    // Checkmark icon on the right side
                    Image(systemName: "pencil")
                        .foregroundColor(.green) // Set the icon color to green
                        .padding(.trailing, 8) // Add padding to align properly with the TextField
                }
                .ignoresSafeArea(.keyboard)
                .padding()
                Spacer()
                if let previewImage = previewImage{
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectedFilter = .original
                        updatePreview()
                    }) {
                        ZStack(alignment: .bottom) {
                            Image("Original")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("Filterbar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 67.62, height: 7) // Set the width slightly less to show the "Original" image edge if needed
                                        .overlay( // Nested overlay for the text
                                            Text("Original") // The text you want to display
                                                .foregroundColor(.white) // Set the text color
                                                .font(.system(size: 9))
                                                .padding(.horizontal, 4) // Add padding if needed to center the text properly
                                            , alignment: .center // Center the text on the "Filterbar"
                                                )
                                    , alignment: .bottom
                                )
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedFilter = .original
                        updatePreview()
                    })  {
                        ZStack(alignment: .bottom) {
                            Image("Original")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("Filterbar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 67.62, height: 7) // Set the width slightly less to show the "Original" image edge if needed
                                        .overlay( // Nested overlay for the text
                                            Text("AI Filter") // The text you want to display
                                                .foregroundColor(.white) // Set the text color
                                                .font(.system(size: 9))
                                                .padding(.horizontal, 4) // Add padding if needed to center the text properly
                                            , alignment: .center // Center the text on the "Filterbar"
                                                )
                                    , alignment: .bottom
                                )
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        selectedFilter = .grayscale
                        updatePreview()
                    }) {
                        ZStack(alignment: .bottom) {
                            Image("Original")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("Filterbar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 67.62, height: 7) // Set the width slightly less to show the "Original" image edge if needed
                                        .overlay( // Nested overlay for the text
                                            Text("Grey") // The text you want to display
                                                .foregroundColor(.white) // Set the text color
                                                .font(.system(size: 9))
                                                .padding(.horizontal, 4) // Add padding if needed to center the text properly
                                            , alignment: .center // Center the text on the "Filterbar"
                                                )
                                    , alignment: .bottom
                                )
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedFilter = .blackAndWhite
                        updatePreview()
                    })  {
                        ZStack(alignment: .bottom) {
                            Image("Original")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("Filterbar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 67.62, height: 7) // Set the width slightly less to show the "Original" image edge if needed
                                        .overlay( // Nested overlay for the text
                                            Text("B & W") // The text you want to display
                                                .foregroundColor(.white) // Set the text color
                                                .font(.system(size: 9))
                                                .padding(.horizontal, 4) // Add padding if needed to center the text properly
                                            , alignment: .center // Center the text on the "Filterbar"
                                                )
                                    , alignment: .bottom
                                )
                        }
                        
                        
                        
                    }
                    Spacer()
                    
                    //                    Button("done"){
                    //                        onDone(previewImage)  // Pass the enhanced image back
                    //                        presentationMode.wrappedValue.dismiss()
                    //
                    //                    }
                }
                .padding(.bottom, 30)
                
                if selectedFilter == .grayscale {
                    Slider(value: $filterContrast, in: 0.5...3.0, step: 0.1) {
                        Text("Contrast")
                    }
                    .onChange(of: filterContrast) { _ in
                        updatePreview()
                    }
                    .padding()
                }
                
                if selectedFilter == .blackAndWhite {
                    Slider(value: $filterContrast, in: 1.0...3.0, step: 0.1) {
                        Text("Contrast for B & W")
                    }
                    .onChange(of: filterContrast) { _ in
                        updatePreview()
                    }
                    .padding()
                }
                
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack{
                            Image("Crossbar")
                                .resizable()
                                .frame(width: 70, height: 65)
                                .foregroundColor(.red)
                            Image("Crossfilter")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }
                    }
                    
                    Spacer(minLength: 50)
                    
                    Button(action: {
                        // Action for the "Auto" button
                        isAutoEnhanceSelected.toggle()                            }) {
                            VStack {
                                Image("Auto")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(/*isAutoEnhanceSelected*/ /*? Color.green :*/ Color.white)
                                Text("Auto")
                                    .font(.system(size: 12))
                                    .foregroundColor(isAutoEnhanceSelected ? Color.green : Color.white)
                            }
                        }
                    
                    Spacer()
                    
                    VStack {
                        // Toggle switch
                        Toggle("", isOn: $isAutoEnhanceSelected)
                            .onChange(of: isAutoEnhanceSelected) { _ in
                                updatePreview()
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color.green))
                            .labelsHidden()
 // This will hide the label for the Toggle, showing only the switch itself
                        
                        // Text label below the toggle
                        Text("Apply to all pages")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                        
                    }
                    .frame(maxWidth: .infinity) // Ensure the VStack takes up full available width
                    // Additional padding and adjustments as necessary
                    
                    Spacer()
                    
                    
                    Button(action: {
                        onDone(previewImage)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack{
                            Image("Tickbar")
                                .resizable()
                                .frame(width: 70, height: 65)
                                .foregroundColor(.green)
                            
                            Image("Tickfilter")
                                .resizable()
                                .frame(width: 25, height: 20)
                        }
                    }
                }
                
                
                
            }
            
        }
       
        
        
        .navigationBarTitle("Select Filter", displayMode: .inline)
        .onAppear {
            // Initial preview update
            updatePreview()
        }
    }
    
    func selectFilter(_ filter: PreviewAndEditingScreen.FilterType) {
        selectedFilter = filter
        updatePreview()
    }
    
    // Function to update the preview image based on the current filter settings
    func updatePreview() {
        if isAutoEnhanceSelected {
            // Apply the filter to all scanned images
            scannedImages = scannedImages.map { image -> UIImage in
                applySelectedFilter(to: image) ?? image
            }
            // Update the preview image with the first image as an example
            previewImage = scannedImages.first
        } else {
            // Apply the filter only to the current image
            previewImage = applySelectedFilter(to: currentImage)
        }
    }

    
    func applySelectedFilter(to image: UIImage) -> UIImage? {
        guard let cgimg = image.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgimg)
        let context = CIContext()
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage

        switch selectedFilter {
        case .original:
            return image // No filter applied
        case .grayscale:
            filter.saturation = 0
            filter.brightness = 0
            filter.contrast = Float(filterContrast)
        case .blackAndWhite:
            filter.saturation = 0
            filter.brightness = 0
            filter.contrast = Float(filterContrast)
        }

        if let outputImage = filter.outputImage, let cgImageResult = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImageResult)
        }
        return nil
    }

    
    
}



struct FilterSelectionView_Previews: PreviewProvider {
    @State static var selectedFilter: PreviewAndEditingScreen.FilterType = .original
    @State static var filterContrast: CGFloat = 1.0
    // Create a static @State property for your array of UIImage
    @State static var scannedImages: [UIImage] = [UIImage(systemName: "photo")!]
    
    static var previews: some View {
        FilterSelectionView(
            selectedFilter: $selectedFilter,
            filterContrast: $filterContrast,
            applyFilter: { filterType in
                // This can be left empty for preview purposes
            },
            onDone: { _ in
                // This can also be left empty for preview purposes
            },
            scannedImages: $scannedImages, // Now this uses the static @State property
            currentImage: scannedImages.first ?? UIImage() // Use a placeholder or the first image from scannedImages
        )
        .preferredColorScheme(.light) // You can switch to .dark to test dark mode
    }
}
