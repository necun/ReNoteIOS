//
//  ForgetPasswordView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var emailError: String? // New state for email validation error
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var navigateToOTPView = false // State to control navigation to OTP view
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        Image("Logo1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 174, height: 48)
                        Spacer()
                    }
                    
                    Spacer(minLength: 120)
                    VStack {
                        Text("Forgot password 🔑")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                            .foregroundColor(Theme.shared.themeColor)
                            .padding(.trailing, 100)
                        
                        Text("Enter your email address. We will send an OTP code for verification in the next step.")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)
                    }
                    ZStack{
                        HStack{
                            VStack{
                                EmailTextField(email: $email, emailError: $emailError)
                            }
                                .padding(.horizontal)
                            
                            NavigationLink(
                                destination: SignInOTPView(isPresented: $navigateToOTPView),
                                isActive: $navigateToOTPView
                            ) {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 44)
                                    .foregroundColor(emailError == nil && !email.isEmpty ? Theme.shared.themeColor : .gray)
                            }
                            .padding(.trailing, 30)
                            .disabled(emailError != nil || email.isEmpty)
                            
                        }
                    }
                }
                .padding(.bottom, 20) // Move padding here to create space between the button and error message
                
                // Error message display
                
                
                Spacer() // Move Spacer here to push content to the top
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
        .navigationTitle("") // Hide navigation title
        .navigationBarBackButtonHidden(true) // Hide default back button
        .navigationBarItems(leading: CustomBackButton(action: {
            self.presentationMode.wrappedValue.dismiss()
        }))
        .onTapGesture {
            // Dismiss the keyboard when tapped outside of text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
