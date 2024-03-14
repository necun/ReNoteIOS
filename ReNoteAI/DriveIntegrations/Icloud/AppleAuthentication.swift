////
////  GoogleAuthentication.swift
////  ReNoteAI
////
////  Created by Sravan Kumar Kandukuru on 24/02/24.
////
//
//import Dependencies
//import Foundation
//import SwiftUI
//import SwiftData
//import AuthenticationServices
//
//class AppleAuthentication: ObservableObject {
//
//    static let shared = AppleAuthentication()
//    @Published var isSignedIn: Bool = false
//    var users: [User] = []
//    var modelContext: ModelContext?
//    
//    var appleSignInButton: some View {
//        CustomSingleSignOnButton(
//            backgroundColor: Color.blue,
//            imageName: "Google",
//            buttonText: "Sign in with Google Account",
//            textColor: .white,
//            buttonAction: {
//                self.appleSignIn()
//            }
//        )
//    }
//    
//    func appleSignIn() {
//        let provider = ASAuthorizationAppleIDProvider()
//               let request = provider.createRequest()
//               request.requestedScopes = [.fullName, .email]
//               let controller = ASAuthorizationController(authorizationRequests: [request])
//               controller.delegate = self
//               controller.performRequests()
//    }
//    
////    var appleSignInButton: some View {
////        Signinwith
////        
////        SignInWithAppleButton(
////            .continue,
////            onRequest: { request in
////                request.requestedScopes = [.fullName, .email]
////            },
////            onCompletion: { result in
////                switch result {
////                case .success(let authResults):
////                    switch authResults.credential {
////                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
////                        // Successfully logged in
////                        print("sign in details is", appleIDCredential)
//////                        let userIdentifier = appleIDCredential.user
//////                        appleUserID = userIdentifier // Save Apple ID
//////                        isLoggedIn = true
////                    default: break
////                    }
////                case .failure(let error):
////                    print("Authentication error: \(error.localizedDescription)")
////                }
////            }
////        )
////        .label("Sign in with Apple")
////    }
//    
//    func appleSignOut() {
//        
//    }
// }
//
