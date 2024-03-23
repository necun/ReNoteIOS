//
//  SignInOTPView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct SignInOTPView: View {
    @State private var otpCode: [String] = Array(repeating: "", count: 4)
    @State private var timeRemaining = 30
    @Binding var isPresented: Bool // Binding variable to control the presentation of OTPView
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var navigateToCreatePassword = false // State variable to control navigation to CreatePasswordView

    var body: some View {
        NavigationView {
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
                    
                    Text("Enter the OTP")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 18.0, green: 175.0, blue: 58.0))
                        .padding(.trailing, 170)
                    
                    
                    Text("We have sent the OTP verification code to your email address. Enter the code below.")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Spacer(minLength: 50)
                    HStack(spacing: 15) {
                        Spacer()
                        ForEach(0..<4) { index in
                            OTPBoxView(text: $otpCode[index], nextResponder: {})
                        }
                        Spacer()
                    }

                    
                    HStack {
                        Spacer()
                        OTPTimerView(timeRemaining: $timeRemaining)
                        Spacer(minLength: 140)
                        
                        ResendOTPButton(action: resendOTP)
                        Spacer()
                    }
                    .padding()// Add padding to match the edge alignment
                    Spacer(minLength: 50)
                    
                    Button(action: {
                        // Verify OTP
                        verifyOTP()
                    }) {
                        Text("Verify")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 18.0, green: 175.0, blue: 58.0))
                            .cornerRadius(50)
                    }
                    .padding(.horizontal) // Add padding to match the edge alignment
                    .background(NavigationLink(
                        destination: CreatePasswordView(),
                        isActive: $navigateToCreatePassword,
                        label: EmptyView.init
                    ))
                    
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
            .onTapGesture {
                // Dismiss the keyboard when tapped outside of text fields
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onAppear {
                resendOTP()
            }
            .navigationBarTitle("") // Hide navigation bar title
            .navigationBarHidden(true) // Hide navigation bar
        }
        .navigationBarBackButtonHidden(true) // Hide back button in navigation stack
        .navigationBarItems(leading: CustomBackButton(action: {
            self.presentationMode.wrappedValue.dismiss()
        }))
        .onDisappear {
            self.isPresented = false // Dismiss OTPView when it disappears
        }
    }

    func resendOTP() {
        // Implement the resend OTP functionality here
        timeRemaining = 30 // Reset the timer
    }

    func verifyOTP() {
        // Implement the OTP verification functionality here
        navigateToCreatePassword = true // Set the state variable to navigate to CreatePasswordView
    }
}

struct SignInOTPView_Previews: PreviewProvider {
    static var previews: some View {
        SignInOTPView(isPresented: .constant(false))
    }
}
