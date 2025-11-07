//
//  DataManager.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import Foundation

import CoreData


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TestCases") // 👈 must match your .xcdatamodeld file name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
    }
}
