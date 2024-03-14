//
//  SignUpView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @Binding var showingSignUpView: Bool
    @State private var showingOTPView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var isSignUpButtonEnabled: Bool {
            return validateAllFields()
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
                
                Spacer(minLength: 20)
                VStack{
                    EmailTextField(email: $email, emailError: $emailError)
                           .onTapGesture {
                               // Call validateEmail when the email field is tapped
                               validateEmail()
                           }


                    
                    PasswordTextField(password: $password, passwordError: $passwordError)
                        .onTapGesture {
                            // Call validateEmail when the email field is tapped
                            validatePassword()
                        }

                    
                    ConfirmPasswordTextField( confirmPassword: $confirmPassword, confirmPasswordError: $confirmPasswordError)
                }
                .padding()
                .padding(.horizontal)
                
                NavigationLink(
                                    destination: SignInOTPView(isPresented: $showingOTPView).navigationBarBackButtonHidden(true),
                                    isActive: $showingOTPView
                                ) {
                                    Button(action: {
                                        self.signUp()
                                    }) {
                                        Text("Sign-Up")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                            .background(isSignUpButtonEnabled ? Theme.shared.themeColor : Color.gray)
                                            .cornerRadius(25)
                                            .disabled(!isSignUpButtonEnabled)
                                    }
                                    .padding()
                                }
                                
                                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("") // Hide navigation title
            .navigationBarBackButtonHidden(true) // Hide back button
            .navigationBarItems(leading: CustomBackButton(action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            
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
    }
    
    func signUp() {
        // Perform validation before signing up
        if !validateAllFields() {
            return
        }
        
        // Implement your sign-up logic here
        // If sign up is successful:
        self.showingOTPView = true // This will trigger the NavigationLink to OTPView
    }
    
    func validateAllFields() -> Bool {
        return validateEmail() && validatePassword() && validateConfirmPassword()
    }
    
    func validateEmail() -> Bool {
        if showingOTPView { // Check if Sign-Up button is pressed
            if email.isEmpty {
                // Update email error message
                self.emailError = "Email should not be empty"
                return false
            } else if textFieldValidatorEmail(email) {
                // Update email error message for invalid email format
                self.emailError = "Please enter a valid email"
                return false
            }
            // Clear the email error message if email is valid
            self.emailError = nil
        }
        return true
    }



    func validatePassword() -> Bool {
        if let error = validate(password: password) {
            // Update password error message
            self.passwordError = error
            return false
        }
        return true
    }

    func validateConfirmPassword() -> Bool {
        if let error = confirmPasswordValidator(password: password, confirmPassword: confirmPassword) {
            // Update confirm password error message
            self.confirmPasswordError = error
            return false
        }
        return true
    }
}

// Your other structs and extensions...

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showingSignUpView: .constant(true))
    }
}
