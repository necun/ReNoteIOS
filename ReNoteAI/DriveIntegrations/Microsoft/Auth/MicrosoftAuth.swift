import MSAL
import SwiftUI
import UIKit

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    
    private var applicationContext: MSALPublicClientApplication?
    var account: MSALAccount?
    private var accessToken: String?
    var webParameters : MSALWebviewParameters?
    
    var isUserLoggedIn = false
    
    private let kClientID = "fb456815-9bbf-4718-aae7-b01d6df36c06" // Replace with your Azure AD client ID
    private let kAuthority = "https://login.microsoftonline.com/c18ddec1-cd5d-4575-94ec-2c8dadc24941" // Replace with your Azure AD tenant ID
    private let kRedirectUri = "msauth.com.ReNoteAI.ReNoteAI://auth" // Replace with your redirect URI
    private let kScopes: [String] = ["Files.ReadWrite", "User.Read"]
    
    private init() {
        setupMSAL()
    }
    
    private func setupMSAL() {
        guard let authorityURL = URL(string: kAuthority) else {
            print("Unable to create authority URL")
            return
        }
        
        do {
            let authority = try MSALAuthority(url: authorityURL)
            let msalConfig = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: kRedirectUri, authority: authority)
            applicationContext = try MSALPublicClientApplication(configuration: msalConfig)
        } catch {
            print("Unable to create MSAL Public Client Application, error: \(error)")
        }
    }
    
    func signIn(completion: @escaping (String?, String?, Error?) -> Void) {
        guard let applicationContext = applicationContext else {
            completion(nil, nil, NSError(domain: "MSALApplicationContextError", code: 0, userInfo: nil))
            return
        }
        
        webParameters = MSALWebviewParameters(parentViewController: UIApplication.shared.windows.first!.rootViewController!)
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: self.webParameters ?? MSALWebviewParameters())
        
        
        applicationContext.acquireToken(with: interactiveParameters) { (result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, nil, error)
                    return
                }
                
                guard let accessToken = result?.accessToken else {
                    completion(nil, nil, NSError(domain: "MSALResultError", code: 0, userInfo: nil))
                    return
                }
                AuthenticationManager.shared.account = result?.account
                AuthenticationManager.shared.isUserLoggedIn = true
                completion(accessToken, result?.account.username, nil)
            }
        }
    }
    
    
    func loadCurrentAccount(completion: @escaping (MSALAccount?, Error?) -> Void) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        let msalParameters = MSALParameters()
        msalParameters.completionBlockQueue = DispatchQueue.main
        
        applicationContext.getCurrentAccount(with: msalParameters, completionBlock: { (currentAccount, previousAccount, error) in
            
            if let error = error {
                print("Couldn't query current account with error: \(error)");
                return
            }
            
            if let currentAccount = currentAccount {
                print("Found a signed in account \(String(describing: currentAccount.username)). Updating data for that account...")
                self.account = currentAccount;
                AuthenticationManager.shared.isUserLoggedIn = true
                
                completion(currentAccount, nil)
                
                return
            }
            
            // If testing with Microsoft's shared device mode, see the account that has been signed out from another app. More details here:
            // https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-ios-shared-devices
            if let previousAccount = previousAccount {
                print("The account with username \(String(describing: previousAccount.username)) has been signed out.");
            } else {
                print("Account signed out. Updating UX");
                completion(nil,NSError(domain: "MSALResultError", code: 0, userInfo: nil))

            }
            
            self.accessToken = ""
            self.account = nil

            
        })
    }
    
    func acquireTokenSilently(completion: @escaping (String?, Error?) -> Void) {
        guard let account = self.account else {
            completion(nil, NSError(domain: "MSALAccountError", code: 0, userInfo: nil))
            return
        }
        
        let parameters = MSALSilentTokenParameters(scopes: ["Files.ReadWrite"], account: account)
        applicationContext?.acquireTokenSilent(with: parameters) { (result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(result?.accessToken, nil)
            }
        }
    }

    func signOut(completion: @escaping (Bool, Error?) -> Void) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        guard let account = self.account else { return }
        
        do {
            let signoutParameters = MSALSignoutParameters(webviewParameters: MSALWebviewParameters(parentViewController: UIApplication.shared.windows.first!.rootViewController!))
            signoutParameters.signoutFromBrowser = true
            
            
            
            applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {(success, error) in
                
                if let error = error {
                    print("Couldn't sign out account with error: \(error)")
                    return
                }
                
                print("Sign out completed successfully")
                self.accessToken = ""
                self.account = nil
                completion(true, nil)
            })
            
        }
    }
}

struct LoginPageViewMicrosoft: View {
    @Binding var isUserLoggedIn: Bool
        @Binding var username: String
        @Binding var isShowingScanner: Bool
        @State private var navigateToContentView = false
    
    // Access the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Let's get started")
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .white : .black) // Adapt text color based on the scheme
                    .padding(.top)

                Text("Sign-In with")
                    .font(.title)
                    .foregroundColor(Color(red: 18.0, green: 175.0, blue: 58.0))
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)

            Button(action: {
                // Simulate signIn method
                AuthenticationManager.shared.signIn { (accessToken, email, error) in
                    if let accessToken = accessToken, error == nil {
                        DispatchQueue.main.async {
                            // Update state variables on successful login
                            self.isUserLoggedIn = true
                            self.username = email ?? ""
                            self.isShowingScanner = true
                            self.navigateToContentView = true // Trigger navigation to ContentView
                        }
                    } else {
                        // Handle error case
                        print("Authentication error: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            })
            {
                HStack {
                    Image("Image2") // Ensure this image is adaptable for dark mode or use SF Symbols
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                    Text("Microsoft Account")
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black) // Adapt text color based on the scheme
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color.black : Color.white) // Use the original background color
                .overlay(
                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.1)
                        .fill(Color.gray.opacity(0.2)) // Light gray overlay with some transparency
                )
                .cornerRadius(UIScreen.main.bounds.width * 0.1)
                .shadow(radius: 4)
                .padding(.horizontal)
            }
//            NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
//                EmptyView()
//            }
//            .hidden()

            
            Spacer()
        }
        .background(colorScheme == .dark ? Color.black : Color.white) // Adapt overall background based on the scheme
        .edgesIgnoringSafeArea(.all)
        .onAppear {
                    AuthenticationManager.shared.loadCurrentAccount { currentAccount, error in
                        if error == nil {
                            AuthenticationManager.shared.account = currentAccount
                            isUserLoggedIn = true
                            username = currentAccount?.username ?? ""
                            self.isShowingScanner = true
                            self.navigateToContentView = true // Set this to true to navigate to ContentView
                        }
                    }
                }
            }
        }
