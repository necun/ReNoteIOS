//
//  CustomBackButton.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct CustomBackButton: View {
    var action: () -> Void // Action to perform when the button is tapped
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                
            }
            .foregroundColor(Theme.shared.themeColor)
            .padding()
        }
    }
}
