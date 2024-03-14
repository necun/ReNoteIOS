//
//  ReNoteAIApp.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 14/02/24.
//

import SwiftData
import SwiftUI

@main
struct ReNoteAIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Folder.self,
            Tag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                           .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
