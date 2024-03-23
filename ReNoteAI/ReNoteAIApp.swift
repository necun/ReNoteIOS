import SwiftUI
import CoreData
import FirebaseCore
import Firebase



@main
struct ReNoteAIApp: App {
    // Use the AppDelegate adaptor for initializing Core Data stack in older iOS versions if needed
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    var navigationViewModel = NavigationViewModel()

    // Create an instance of PersistenceController
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            // Provide your initial ContentView
            ContentView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environmentObject(DataBaseManager(context: persistenceController.container.viewContext))

        }
    }
}
