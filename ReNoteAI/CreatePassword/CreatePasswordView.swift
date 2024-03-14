//
//  CreatePasswordView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct CreatePasswordView: View {
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordError: String?
    @State private var confirmPasswordError: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView{
            VStack {
                HStack {
                    Spacer()
                    Image("Logo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 174, height: 48)
                    Spacer()
                }
                Spacer(minLength: 80)
                Text("Create New Password 🔐")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.shared.themeColor)
                    .padding(.trailing, 30)
                
                Text("Enter your new password. If you forget it, then you have to do forgot password.")
                    .foregroundColor(.gray)
                    .padding()
                
                VStack{
                    PasswordTextField(password: $password, passwordError: $passwordError)
                    ConfirmPasswordTextField(confirmPassword: $confirmPassword, confirmPasswordError: $confirmPasswordError)
                }
                .padding(.horizontal)
                .padding()
                
                Spacer(minLength: 20)
                
                Button(action: {
                    // Validate passwords before proceeding
                    if validatePasswords() {
                        // Implement the action to create a new password here
                    }
                })
                {
                    HStack {
                        Spacer()
                        Text("Let's go")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(isSignUpButtonEnabled ? Theme.shared.themeColor : Color.gray)
                    .cornerRadius(50)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
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
        .onTapGesture {
            // Dismiss the keyboard when tapped outside of text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    }
    
    var isSignUpButtonEnabled: Bool {
        return validatePasswords()
    }
    
    func validatePasswords() -> Bool {
        return validatePassword() && validateConfirmPassword()
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
        if password != confirmPassword {
            // Update confirm password error message
            self.confirmPasswordError = "Passwords didn't match"
            return false
        }
        return true
    }
}


struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}
