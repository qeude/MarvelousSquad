//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import CoreData
import Foundation

public class Squad: NSManagedObject {}

public extension Squad {
    static func getSquad(with persistentContainer: PersistentContainer) -> Squad {
        let request: NSFetchRequest<Squad> = Squad.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            if let squad = try persistentContainer.viewContext.fetch(request).first {
                return squad
            }
        } catch {
            print("Detele all data in SuperHero error :", error)
        }
        let squad = Squad(context: persistentContainer.viewContext)
        squad.identifier = UUID()
        squad.superheroes = []
        persistentContainer.saveContext()
        return squad
    }
}
