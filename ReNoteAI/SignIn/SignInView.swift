//
//  SignInView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailError: String? // New state for email validation error
    @State private var passwordError: String? // New state for password validation error
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var isLoginButtonEnabled: Bool {
        return validateEmail() && validatePassword()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 163, height: 97)
                
                Image("Logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 174, height: 48)
                    .padding(.top, 20)
                
                Spacer(minLength: 40)
                
                VStack {
                    EmailTextField(email: $email, emailError: $emailError)
                           .onTapGesture {
                               // Call validateEmail when the email field is tapped
                               validateEmail()
                           }
                    PasswordTextField(password: $password, passwordError: $passwordError)
                }
                .padding()
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password ?")
                            .foregroundColor(Theme.shared.themeColor)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 50)
                Button(action: {
                    // Handle login action
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(minWidth: 140)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 50).fill(Theme.shared.themeColor))
                        .disabled(!isLoginButtonEnabled) // Disable the button based on validation
                }
                
                Spacer()
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                // Check if the drag is horizontal and the user dragged towards the right
                if value.translation.width > 100 { // Adjust the sensitivity as needed
                    // Dismiss the view
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        )
        .navigationBarBackButtonHidden(true) // Hide default back button
        .navigationBarItems(leading: CustomBackButton(action: {
            self.presentationMode.wrappedValue.dismiss()
        }))
        .onTapGesture {
            // Dismiss the keyboard when tapped outside of text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func validateEmail() -> Bool {
        if email.isEmpty {
            // Update email error message
            self.emailError = "Email should not be empty"
            return false
        }
        // Clear the email error message if email is valid
        self.emailError = nil
        return true
    }
    
    func validatePassword() -> Bool {
        if password.isEmpty {
            // Update password error message
            self.passwordError = "Password should not be empty"
            return false
        }
        // Clear the password error message if password is valid
        self.passwordError = nil
        return true
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

