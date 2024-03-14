//
//  ConfirmPasswordTextField.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct ConfirmPasswordTextField: View {
    @Binding var confirmPassword: String
    @Binding var confirmPasswordError: String?
    
    var body: some View {
        CustomTextField(
            placeholder: "Confirm Password",
            text: $confirmPassword,
            isSecure: true,
            isError: confirmPasswordError != nil,
            errorMessage: confirmPasswordError ?? "",
            onEditingChanged: { _ in }
        )
    }
}
