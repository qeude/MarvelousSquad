//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import CoreData
import Foundation

public final class PersistentContainer: NSPersistentContainer {
    public init(name: String, bundle: Bundle = .main, inMemory _: Bool = false) {
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to create mom")
        }
        super.init(name: name, managedObjectModel: mom)

        loadPersistentStores { storeDescription, error in
            self.viewContext.automaticallyMergesChangesFromParent = true
            self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            print("Core Data stack has been initialized with description: \(storeDescription)")
        }
    }

    public func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
