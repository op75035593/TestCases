//
//  ContentView.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    func name(){
      
    }
}

#Preview {
    ContentView()
}
import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                Text(user.name)
            }
            .navigationTitle("Users")
            .task {
                await viewModel.loadUsers()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}





import SwiftUI
import CoreData

struct ContentViewcoreData: View {
    // Access Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name: String = ""
    
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)],
            animation: .default
        )
        private var people: FetchedResults<Person>
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("Save") {
                savePerson()
               
            }
            .buttonStyle(.borderedProminent)
            List(people) { person in
                               Text(person.name ?? "Unknown")
                           }
        }
        .padding()
    }
    
    // ✅ Save to Core Data
    private func savePerson() {
        //        let person = Person(context: viewContext)
        //        person.name = name
        //
        //        do {
        //            try viewContext.save()
        //            print("✅ Saved successfully: \(name)")
        //            name = "" // Clear text field
        //        } catch {
        //            print("❌ Failed to save: \(error.localizedDescription)")
        //        }
      
        
        
        
        let person = Person(context: viewContext)
        person.name = "Alice"
        try? viewContext.save()
    }
}
