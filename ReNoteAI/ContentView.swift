import SwiftUI
import SwiftData
 
struct ContentView: View {
    
  
    @State private var selectedTab = "One"
    @State private var scannedImages: [UIImage] = []
    @State private var showingScanner = false
        @State private var scannedCode: String?
        @StateObject private var scannerViewModel = ScannerViewModel()
    @State private var showingImportScreen = false
 
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    VStack{
                        Image(selectedTab == "One" ? "Homefill" : "Home")
                            .foregroundColor(selectedTab == "One" ? .green : .gray)
                        Text("Home")
                            .foregroundColor(selectedTab == "One" ? .green : .gray)
                    }
                }
                .tag("One")
            //            CameraView(image: $image, documents: $documents)
            ScannerView(viewModel: scannerViewModel)
                                        .tabItem {
                                            VStack {
                                                Image(selectedTab == "Two" ? "Qrfill" : "Qr")
                                                    .foregroundColor(selectedTab == "Two" ? .green : .gray)
                                                Text("QR Scan")
                                                    .foregroundColor(selectedTab == "Two" ? .green : .gray)
                                            }
                                        }
                                        .tag("Two")
                                        .ignoresSafeArea()
            //            CameraView(image: $image, documents: $documents)
            DocumentScanner(scannedImages: $scannedImages) {
                showingImportScreen = true
            }
            .tabItem {
                VStack{
                    Image("Camera")
                        .foregroundColor(selectedTab == "Three" ? .green : .gray)
                    Text("")
                        .foregroundColor(selectedTab == "Three" ? .green : .gray)
                }
            }
            .sheet(isPresented: $showingImportScreen) {
                ImportScreen(
                    onSaveFolder: { folder in
                        // Your code to handle folder selection
                    },
                    scannedImages: $scannedImages,
                    dataBaseManager: DataBaseManager.shared
                )
            }

            .ignoresSafeArea()
            .tag("Three")
            //            CameraView(image: $image, documents: $documents)
            Button("Show Tab 2") {
                selectedTab = "Four"
            }
            .tabItem {
                VStack{
                    Image(selectedTab == "Four" ? "OCRfill" : "OCR")                        .foregroundColor(selectedTab == "Four" ? .green : .gray)
                    Text("OCR Scan")
                        .foregroundColor(selectedTab == "Four" ? .green : .gray)
                }
            }
            .tag("Four")
            
            AddDocumentView()
                .tabItem {
                    VStack{
                        Image(selectedTab == "Five" ? "Importfill" : "Import")
                            .foregroundColor(selectedTab == "Five" ? .green : .gray)
                        Text("Import")
                            .foregroundColor(selectedTab == "Five" ? .green : .gray)
                    }
                }
                .tag("Five")
            
        }
        
        
        .onAppear() {
//            GoogleAuthentication.shared.checkIsSignedIn()
            scannerViewModel.showingScanner = true
            // Automatically show scanner when tab is selected
        }
    }
    
    func onTabIndexChanged() {
        
    }
}
