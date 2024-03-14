//
//  CustomTabbar.swift
//  ReNoteAI
//
//  Created by Siddanathi Rohith on 24/02/24.
//

import SwiftUI

struct CustomTabbarButton: View {
    var iconName: String
    var text: String
    var isSelected: Bool
    var buttonAction: () -> Void
    
    init(iconName: String, text: String, isSelected: Bool, buttonAction: @escaping () -> Void) {
        self.iconName = iconName
        self.text = text
        self.isSelected = isSelected
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button(action: buttonAction) {
            VStack {
                Image(systemName: iconName) // Assuming using SF Symbols, adjust if using custom images
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24) // Adjust size as needed
                    .foregroundColor(isSelected ? Color(red: 18.0, green: 175.0, blue: 58.0) : Color.black) // Change color based on selection
                
                if !text.isEmpty {
                    Text(text)
                        .foregroundColor(isSelected ? Color(red: 18.0, green: 175.0, blue: 58.0) : Color.black) // Change text color based on selection
                }
            }
        }
    }
    
    
    struct CustomTabbarButton_Previews: PreviewProvider {
        static var previews: some View {
            CustomTabbarButton(iconName: "", text: "", isSelected: true) {
                print("noithing")
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
