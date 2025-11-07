//
//  TestCasesApp.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import SwiftUI

@main
struct TestCasesApp: App {
    let persistenceController = PersistenceController.shared  // Xcode creates this when you choose Core Data template

    var body: some Scene {
        WindowGroup {
            ChatView()
          // ContentView()
            //UsersView()
            
//            ContentViewcoreData()
//                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            //UserListView()
          //  AsyncAwait()
        }
    }
}
