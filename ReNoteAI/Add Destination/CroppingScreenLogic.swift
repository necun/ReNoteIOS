




// THIS CROPPING LOGIC IS NOT VERY ACCURATE.


import SwiftUI

struct CropScreen: View {
    var image: UIImage
    @Binding var isPresented: Bool
    @State private var croppingArea: CGRect = .zero
    var onComplete: (UIImage) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
                // Cropping area rectangle
                Rectangle()
                Path { path in
                    croppingArea// Your path drawing code here...
                }.stroke(Color.white, lineWidth: 2)
                    .foregroundColor(.white)
                
                    
                
                // Drag handles
                ForEach(Corner.allCases, id: \.self) { corner in
                    Circle()
                        .frame(width: 30, height: 30)
                        .position(croppingArea.corner(corner))
                        .foregroundColor(.white)
                        .padding(-10)
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged { gesture in
                                    croppingArea = croppingArea.resized(with: gesture.translation, corner: corner)
                                    croppingArea = croppingArea.clamped(to: geometry.frame(in: .local))
                                }
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            // Initialize the cropping area to the center of the image
            let size = CGSize(width: image.size.width / 3, height: image.size.height / 3)
            let origin = CGPoint(x: image.size.width / 3, y: image.size.height / 3)
            croppingArea = CGRect(origin: origin, size: size)
        }
        .navigationBarItems(trailing: Button("Done") {
            let croppedImage = cropImage(image: image, toRect: croppingArea)
            onComplete(croppedImage)
            isPresented = false
        })
    }

    private func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage {
        // Calculate scale factors
        let scaleX = image.size.width / UIScreen.main.bounds.width
        let scaleY = image.size.height / UIScreen.main.bounds.height

        // Translate the rectangle to the image's scale
        let cropRect = CGRect(
            x: rect.origin.x * scaleX,
            y: rect.origin.y * scaleY,
            width: rect.size.width * scaleX,
            height: rect.size.height * scaleY
        )

        // Perform cropping in the Core Graphics context
        guard let cgImage = image.cgImage,
              let croppedCgImage = cgImage.cropping(to: cropRect) else {
            return image // Return original image if cropping fails
        }

        return UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)
    }

}

enum Corner: CaseIterable {
    case topLeft, topRight, bottomLeft, bottomRight
}

private extension CGRect {
    func corner(_ corner: Corner) -> CGPoint {
        switch corner {
        case .topLeft:
            return CGPoint(x: minX, y: minY)
        case .topRight:
            return CGPoint(x: maxX, y: minY)
        case .bottomLeft:
            return CGPoint(x: minX, y: maxY)
        case .bottomRight:
            return CGPoint(x: maxX, y: maxY)
        }
    }

    func resized(with translation: CGSize, corner: Corner) -> CGRect {
        var rect = self
        switch corner {
        case .topLeft:
            rect.origin.x += translation.width
            rect.origin.y += translation.height
            rect.size.width -= translation.width
            rect.size.height -= translation.height
        case .topRight:
            rect.origin.y += translation.height
            rect.size.width += translation.width
            rect.size.height -= translation.height
        case .bottomLeft:
            rect.origin.x += translation.width
            rect.size.width -= translation.width
            rect.size.height += translation.height
        case .bottomRight:
            rect.size.width += translation.width
            rect.size.height += translation.height
        }
        return rect
    }

    func clamped(to boundary: CGRect) -> CGRect {
        let width = min(boundary.maxX, maxX) - max(boundary.minX, minX)
        let height = min(boundary.maxY, maxY) - max(boundary.minY, minY)
        let origin = CGPoint(
            x: max(boundary.minX, minX),
            y: max(boundary.minY, minY)
        )
        return CGRect(origin: origin, size: CGSize(width: width, height: height))
    }
}
