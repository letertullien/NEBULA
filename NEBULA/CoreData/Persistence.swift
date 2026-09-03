//
//  Persistence.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "NEBULA")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Erreur de chargement Core Data : \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
