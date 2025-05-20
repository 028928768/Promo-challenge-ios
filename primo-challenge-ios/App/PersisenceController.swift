//
//  PersisenceController.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation
import CoreData

// MARK: - CoreData Stack

@MainActor // - Make sure Coredata is access Thread safe!
final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "primo_challenge_iosApp")
        
        if inMemory {
            let storeDescription = NSPersistentStoreDescription()
            storeDescription.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [storeDescription]
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
