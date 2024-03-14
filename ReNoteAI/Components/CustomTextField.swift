//
//  CustomTextField.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isError: Bool = false // New argument for error state
    var errorMessage: String = "" // New argument for error message
    var onEditingChanged: (Bool) -> Void = { _ in } // New argument for editing change callback
    
    @State private var isSecureTextEntry: Bool // Use state property to toggle secure text entry
    
    init(placeholder: String, text: Binding<String>, isSecure: Bool = false, isError: Bool = false, errorMessage: String = "", onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.isError = isError
        self.errorMessage = errorMessage
        self.onEditingChanged = onEditingChanged
        self._isSecureTextEntry = State(initialValue: isSecure) // Initialize isSecureTextEntry based on isSecure
    }
    
    var body: some View {
        VStack {
            HStack {
                if isSecure {
                    if isSecureTextEntry {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text, onEditingChanged: onEditingChanged)
                    }
                } else {
                    TextField(placeholder, text: $text, onEditingChanged: onEditingChanged)
                }
                
                if isSecure {
                    Button(action: {
                        isSecureTextEntry.toggle() // Toggle isSecureTextEntry when tapped
                    }) {
                        Image(systemName: isSecureTextEntry ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
            }
            .padding(.vertical, 10) // Apply padding here to the HStack
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isError ? Color.red : Color.gray) // Set error color if isError is true
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside of text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        // Display error message if isError is true
        Text(errorMessage)
            .foregroundColor(.red)
            .font(.caption)
            .padding(.top, 4)
    }
}
