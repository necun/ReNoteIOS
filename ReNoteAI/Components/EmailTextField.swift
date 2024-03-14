//
//  EmailTextField.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    @Binding var emailError: String?
    
    var body: some View {
        CustomTextField(
            placeholder: "Email",
            text: $email,
            isError: emailError != nil,
            errorMessage: emailError ?? "",
            onEditingChanged: { _ in }
        )
        .onChange(of: email) { _ in
            validateEmail()
        }
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email should not be empty"
        } else if textFieldValidatorEmail(email) {
            emailError = "Please enter a valid email"
        } else {
            emailError = nil
        }
    }
}
