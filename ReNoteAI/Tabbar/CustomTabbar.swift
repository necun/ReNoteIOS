////
////  CustomTabbar.swift
////  ReNoteAI
////
////  Created by Siddanathi Rohith on 24/02/24.
////
//
//import Foundation
//import SwiftUI
//import SwiftyDropbox
//
//
//
//struct QRScannerViewRepresentable: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//
//    func makeUIViewController(context: Context) -> QRScannerViewController {
//        let viewController = QRScannerViewController()
//        viewController.modalPresentationStyle = .fullScreen // Ensure full-screen presentation
//        // Setup any dismissal handling here if needed
//        return viewController
//    }
//
//    
//    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
//        // Update the view controller when SwiftUI state changes.
//    }
//    
//    typealias UIViewControllerType = QRScannerViewController
//    
//    class Coordinator {
//        var parent: QRScannerViewRepresentable
//        
//        init(_ parent: QRScannerViewRepresentable) {
//            self.parent = parent
//        }
//        
//        // Add any delegate methods if needed, for example, a method to handle QR code detection results.
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//}
//
//
//struct CustomTabbar: View {
//    
//    @Binding var selectedTabIndex: Int
//       @State private var showAddDocumentView = false
//    @State private var showCamera = false
//    @State private var image: UIImage?
//    @State private var showScanner = false
//    @Binding var isShowingScanner: Bool
//    @Binding var scannedImage: UIImage?
//    
//    var selectedIndex: Int = 0
//        var onTabItemSelected: (_ selectedIndex: Int) -> Void
//
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            HStack {
//                Spacer()
//                CustomTabbarButton(iconName: "Home", text: "Home", isSelected: selectedIndex == 0 ? true : false, buttonAction: ({
//                    onClcikOfTabbarSelected(0)
//                }))
//                Spacer()
//                
//                CustomTabbarButton(iconName: "Qr", text: "QR Scan", isSelected: false, buttonAction: ({
//                    showScanner = true
//        
//                }))
//                .fullScreenCover(isPresented: $showScanner) {
//                            QRScannerViewRepresentable(isPresented: $showScanner)
//                        }
//
//                
//                Spacer()
//                CustomTabbarButton(iconName: "Camera", text: "", isSelected: false, buttonAction: ({
//                    showCamera = true
//                }))
//                .ignoresSafeArea()
//                .fullScreenCover(isPresented: $showCamera) {
//                    // Pass the documents array to CameraView
////                    CameraView(image: $image, documents: $documents)
//                }
//
//                
//                
//                Spacer()
//                CustomTabbarButton(iconName: "OCR", text: "OCR Scan", isSelected: false, buttonAction: ({
//                    showCamera = true
//                }))
//                .ignoresSafeArea()
//                .fullScreenCover(isPresented: $showCamera) {
//                    // Pass the documents array to CameraView
////                    CameraView(image: $image, documents: $documents)
//                }
//                
//                
//                Spacer()
//                
//                CustomTabbarButton(iconName: "Import", text: "Import", isSelected: false, buttonAction: ({
//                    addItem()
//                }))
//                .background(NavigationLink("", destination: AddDocumentView(isShowingScanner: $isShowingScanner, scannedImage: $scannedImage), isActive: $showAddDocumentView))
//                
//                
//                Spacer()
//            }
//            .padding(10)
//            .background(Color.white)
//            // Use RoundedRectangle for more control over the roundness
//            .clipShape(RoundedRectangle(cornerRadius: 60)) // Adjust this value to increase or decrease roundness
//            .shadow(radius: 5)
//
//            //                .fullScreenCover(isPresented: $showCamera) {
//            //                    CameraView(image: $image, documents: .constant([]))
//            //                }
//        }
//        .padding(.bottom, 10)
//        .ignoresSafeArea()
//        .fullScreenCover(isPresented: $showAddDocumentView) {
//            // Embed AddDocumentView within NavigationView for the sheet presentation
//            NavigationView {
//                AddDocumentView()
//                    .navigationBarTitle("Add Document", displayMode: .inline) // Optional: Set a title for the navigation bar
//                    .toolbar {
//                        // Add a button to dismiss the view
//                        ToolbarItem(placement: .cancellationAction) {
//                            Button("Close") {
//                                showAddDocumentView = false // Dismiss the sheet view
//                            }
//                        }
//                    }
//            }
//        }
//    }
//    
//    
//    func onClcikOfTabbarSelected(_ index:Int) {
//        onTabItemSelected(index)
//    }
//
//    private func addItem() {
//        withAnimation {
//            showAddDocumentView = true
//        }
//    }
//}
