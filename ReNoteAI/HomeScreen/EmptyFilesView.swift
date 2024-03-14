//
//  NoScannerView.swift
//  ReNoteAI
//
//  Created by Siddanathi Rohith on 02/03/24.
//

import SwiftUI

struct EmptyFilesView: View {
    var body: some View {
        VStack(){
            Image("Empty")
            Text("We don't see any files")
                .font(.title3)
                .foregroundColor(.gray)
            Text("Start scanning!")
                .font(.title)
            
        }
            }
}

#Preview {
    EmptyFilesView()
}
