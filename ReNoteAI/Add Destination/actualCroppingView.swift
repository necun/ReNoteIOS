//
//  actualCroppingView.swift
//  ReNoteAI
//
//  Created by Likhith Undabhatla on 22/03/24.
//

import SwiftUI

struct CroppingInterfaceView: View {
    var originalImage: UIImage
    @Binding var croppedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Crop")
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                    Button(action: {
                        // Save or confirm the cropping action here
                    }) {
                        
                    }
                }
                .padding()
                .background(Color.black) // This is the navigation bar's color

                Spacer()

                // Your image view goes here, for now it's a placeholder
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()

                // Your custom cropping controls here
                HStack {
                    Button(action: {
                        // Cancel or reset the cropping action here
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        // Perform the actual cropping here
                    }) {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        // Maybe this is for advanced settings
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        // Perform the actual cropping here
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        // Perform the actual cropping here
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                }
                
                .padding()
            }
        }
    }
}

struct CroppingInterfaceView_Previews: PreviewProvider {
    // Create a static dummy image for preview purposes
    static let dummyImage = UIImage(systemName: "photo")!
    
    // Create a static binding for the preview
    @State static var dummyCroppedImage: UIImage? = nil
    
    static var previews: some View {
        // Use the static image and binding in the preview
        CroppingInterfaceView(originalImage: dummyImage, croppedImage: $dummyCroppedImage)
    }
}
