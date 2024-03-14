import Dependencies
import SwiftUI
import GoogleDriveClient
import SwiftData
import AuthenticationServices

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Query private var folders: [Folder]
    @Query private var documents: [Document]

    @StateObject var googleAuthentication = GoogleAuthentication.shared
    @State private var isGoogleSignedIn:Bool = false
    @State private var isOneDriveSignedIn:Bool = false
    @State private var isICloudSignedIn:Bool = false
    @State private var showingAppleSignInView = false
    
    @State private var showingSignUpScreen = false
    @State private var showingSignInView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingLoginPageMicrosoft = false

    var body: some View {
        
        NavigationView {
            VStack {
                if (isGoogleSignedIn || isOneDriveSignedIn || isICloudSignedIn) {
                    VStack {
                        if (isGoogleSignedIn) {
                            CustomSingleSignOnButton(
                                backgroundColor: Color.blue,
                                imageName: "Google",
                                buttonText: "Already signed in with Google",
                                textColor: .white,
                                buttonAction: {
                                    googleAuthentication.googleSignOut()
                                }
                            )
                        }
                        
                    }
                }
                else {
                   
                    Logo()
                    Spacer()
                    
                    googleAuthentication.googleSignInButton
                    
                    CustomSingleSignOnButton(
                        backgroundColor: Color.white,
                        imageName: "Microsoft",
                        buttonText: "Sign in with Microsoft Account",
                        textColor: .black,
                        buttonAction: {
                            self.showingLoginPageMicrosoft = true
                        }
                    )
                    
//                    AppleAuthentication.shared.appleSignInButton
//
//                    
//                    HStack {
//                        Line()
//                        Text("OR")
//                            .foregroundColor(.gray)
//                            .padding(.horizontal, 5)
//                        Line()
//                    }
                    .padding(.vertical, UIScreen.main.bounds.size.height * 0.02)

//                    NavigationLink(destination: SignUpView(showingSignUpView: $showingSignUpScreen), isActive: $showingSignUpScreen) {
//                        EmailSignUpButton()
//                    }

                    Spacer()
//                    HStack {
//                        Text("Already have an account?")
//                        Button(action: {
//                            self.showingSignInView = true
//                        }) {
//                            Text("Sign in")
//                                .foregroundColor(Theme.shared.themeColor)
//                                .underline()
//
//                        }
//                    }
                    .padding(.bottom, UIScreen.main.bounds.size.height * 0.05)
                }
                
            }
            .onReceive(googleAuthentication.$isSignedIn) { newValue in
                isGoogleSignedIn = newValue
            }
            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
            .background(NavigationLink(destination: SignInView(), isActive: $showingSignInView) { EmptyView() }.hidden()) // Add this line to create a hidden navigation link
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showingLoginPageMicrosoft) {
                // Present LoginPageViewMicrosoft as a sheet
                LoginPageViewMicrosoft(isUserLoggedIn: $showingSignInView, username: .constant(""), isShowingScanner: .constant(false))
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
        .navigationBarItems(leading: CustomBackButton(action: {
            self.presentationMode.wrappedValue.dismiss()
        }))
        .onOpenURL { url in
            googleAuthentication.onOpenURL(url: url)
//            googleAuthentication.checkIsSignedIn()
            //get the list of files
            //filter the files with folder 
            
        }
        .onAppear() {
            DataBaseManager.shared.modelContext = self.modelContext
            DataBaseManager.shared.users = self.users
            DataBaseManager.shared.folders = self.folders
            DataBaseManager.shared.fetchDocumentsFromDatabase() // Adjusted call

            googleAuthentication.checkIsSignedIn()
            print("folders count is", folders)
        }
    }

}


//struct Line: View {
//    var body: some View {
//        Rectangle()
//            .frame(height: 1)
//            .foregroundColor(.gray)
//            .opacity(0.5) // Adjust for desired opacity
//    }
//}
//
//struct EmailSignUpButton: View {
//    var body: some View {
//        NavigationLink(destination: SignUpView(showingSignUpView: .constant(false))) {
//            Text("Sign-up with Email")
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Theme.shared.themeColor)
//                .cornerRadius(50)
//        }
//    }
//}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

