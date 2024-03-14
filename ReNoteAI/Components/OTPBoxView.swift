//
//  OTPBoxView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI
import Combine

struct OTPBoxView: View {
    @Binding var text: String
    let maxLength: Int = 1 // Define the maximum length of the text
    let nextResponder: () -> Void // Closure to move to the next responder
    
    var body: some View {
        TextField("", text: $text)
            .frame(width: 60, height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Theme.shared.themeColor, lineWidth: 1)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode) // For automatic OTP input, if available
            .onReceive(Just(text)) { input in // Limit text to maxLength
                guard input.count > maxLength else { return }
                let newText = String(input.prefix(maxLength))
                self.text = newText
            }
            .onChange(of: text) { newValue in // Move to next box when text is entered
                if newValue.count == maxLength {
                    self.nextResponder()
                }
            }
    }
}
