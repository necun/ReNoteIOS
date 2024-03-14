//
//  CustomSingleSignOnButton.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import SwiftUI
import Combine


struct CustomSingleSignOnButton: View {
    var backgroundColor: Color
    var imageName: String
    var buttonText: String
    var buttonAction: () -> Void
    var textColor: Color // New property for text color
    
    init(backgroundColor: Color, imageName: String, buttonText: String, textColor: Color, buttonAction: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.imageName = imageName
        self.buttonText = buttonText
        self.textColor = textColor // Assign text color
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button(action: {
            buttonAction()
        }) {
            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(buttonText)
                    .foregroundColor(textColor) // Use provided text color
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(50)
            .padding(.vertical, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(backgroundColor == .white ? Color.black : Color.clear, lineWidth: 1) // Apply black outline only if the background color is white
                    .frame(height: 54)
            )
            
            
        }
    }
}


struct CustomSingleSignOnButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomSingleSignOnButton(backgroundColor: .red, imageName: "YourImageName", buttonText: "YourButtonText", textColor: .white) {
            // Action here
        }
        .previewLayout(.sizeThatFits)
    }
}
