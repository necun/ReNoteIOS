import SwiftUI
 
struct AddNewTagFolderView: View {
    @State private var newName: String
    var type = ""
    var buttonAction: (_ newName: String) -> Void
    @State private var selectedAccount = "Select Account"
       @State private var emailAddress: String = ""
    @Environment(\.presentationMode) var presentationMode // Used for dismissing the view
 
 
    
    init(type: String, buttonAction: @escaping (_ newName: String) -> Void) {
        self._newName = State(initialValue: "") // Initialize the state variable here
        self.type = type
        self.buttonAction = buttonAction
    }
 
    
var body: some View {
        VStack(spacing: 20) {
            headerView()
            
            Divider().padding(.horizontal)
            
            nameInputView()
            
            accountSelectionView()
            
            emailPhoneInputView()
            
            createFolderButton()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
    
    @ViewBuilder
    private func headerView() -> some View {
            HStack {
                Image("Folderplus") // Replace with the appropriate icon
                Text("New Folder")
                    .font(.headline)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("Cross")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
    
    
    @ViewBuilder
    private func nameInputView() -> some View {
        HStack {
            Text("Name")
                .frame(width: 100, alignment: .leading)
            TextField("Enter Name", text: $newName)
                .customTextFieldStyle(cornerRadius: 25) // Use your desired corner radius
                .foregroundColor(.gray)
                .onChange(of: newName) { newValue in
                    self.newName = sanitizedInput(input: newValue)
                }
        }
        .padding(.horizontal)
    }
    
    private func sanitizedInput(input: String) -> String {
        let trimmedString = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let noDots = trimmedString.replacingOccurrences(of: ". ", with: " ")
        return noDots.replacingOccurrences(of: "  ", with: " ")
    }
    
    @ViewBuilder
    private func accountSelectionView() -> some View {
        HStack {
            Text("Save/ Share")
                .frame(width: 100, alignment: .leading)
            
            Menu {
                Button("Device", action: { self.selectedAccount = "Device" })
                Button("Sync to GDrive", action: { self.selectedAccount = "Sync to GDrive" })
            } label: {
                HStack {
                    Text(selectedAccount)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .strokeBorder(Color.gray, lineWidth: 1)
                )
            }
        }
        .padding(.horizontal)
    }
 
    
    @ViewBuilder
    private func emailPhoneInputView() -> some View {
        HStack {
            Text("Email/Phone")
                .frame(width: 100, alignment: .leading)
            TextField("oliviahye@gmail.com", text: $emailAddress)
                .customTextFieldStyle(cornerRadius: 25)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func createFolderButton() -> some View {
        Button(action: {
            let folderName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !folderName.isEmpty {
                // Assuming there's a way to check if the user is signed into Google within your code
                if GoogleAuthentication.shared.isSignedIn {
                    // Code to save the folder to Google Drive
                    // This part should call a function that saves the folder to Google Drive
                } else {
                    // Code to save the folder locally
                    DataBaseManager.shared.saveFolderLocally(name: folderName)
                }
                presentationMode.wrappedValue.dismiss()
            }
        })  {
            Text("Create Folder")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
        .padding(.horizontal)
        .presentationDetents([.custom(MyDetent.self)])
        .safeAreaInset(edge: .bottom) {
            
        }
    }
        
 
}
struct CustomTextFieldStyle: ViewModifier {
    var cornerRadius: CGFloat
 
    func body(content: Content) -> some View {
        content
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.gray, lineWidth: 1))
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white))
    }
}
 
extension View {
    func customTextFieldStyle(cornerRadius: CGFloat) -> some View {
        self.modifier(CustomTextFieldStyle(cornerRadius: cornerRadius))
    }
}
 
 
 
//extension DataBaseManager {
//    func addNewTag(name: String, completion: @escaping () -> Void) {
//        let newTag = Tag(id: UUID().uuidString, name: name)
//        self.tags.append(newTag) // Add the tag locally
//        saveTags() // Save all tags, including the new one, to UserDefaults
//        completion()
//    }
//}
