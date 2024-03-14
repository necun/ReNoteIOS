import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ScannerViewModel
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let scannerViewController = ScannerViewController()
        scannerViewController.completion = { code in
            viewModel.scannedCode = code
        }
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
    }
}




  
class ScannerViewModel: ObservableObject {
    @Published var showingScanner: Bool = false
    @Published var scannedCode: String? {
        didSet {
            if let scannedCode = scannedCode {
                // Perform an action with the scanned code, e.g., show an alert or navigate
                print("Scanned QR Code: \(scannedCode)")
                // Reset the scanner state if needed
                showingScanner = false
            }
        }
    }
}
