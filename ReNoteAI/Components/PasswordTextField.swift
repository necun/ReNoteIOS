//
//  PasswordTextField.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct PasswordTextField: View {
    @Binding var password: String
    @Binding var passwordError: String?
    
    var body: some View {
        CustomTextField(
            placeholder: "Password",
            text: $password,
            isSecure: true,
            isError: passwordError != nil,
            errorMessage: passwordError ?? "",
            onEditingChanged: { _ in }
        )
    }
    
}
