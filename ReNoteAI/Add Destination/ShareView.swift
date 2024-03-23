//
//  ShareView.swift
//  ReNoteAI
//
//  Created by Likhith Undabhatla on 21/03/24.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update the controller in this use case
    }
}
