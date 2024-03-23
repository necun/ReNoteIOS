import SwiftUI
import QCropper

struct CroppingScreen: UIViewControllerRepresentable {
    var originalImage: UIImage
    @Binding var isPresented: Bool
    var onCropped: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let cropper = CropperViewController(originalImage: originalImage)
        cropper.delegate = context.coordinator
        return cropper
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CropperViewControllerDelegate {
        var parent: CroppingScreen
        
        init(_ parent: CroppingScreen) {
            self.parent = parent
        }
        
        func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
            if let state = state, let image = cropper.originalImage.cropped(withCropperState: state) {
                parent.onCropped(image)
            }
            parent.isPresented = false
        }
    }
}
