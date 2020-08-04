//
//  PersistanceService.swift
//  LeanGameScale
//
//  Created by Unal Celik on 3.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceService {
    
    private init() { }
    
    static public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Opened Games Actions
    
    static public func saveOpenedGame(gameId: Int) {
        let openedGame = OpenedGames(context: context)
        openedGame.gameId = Int32(gameId)
        saveContext()
    }
    
    static public func fetchOpenedGames() -> [Int] {
        let fetchRequest: NSFetchRequest<OpenedGames> = OpenedGames.fetchRequest()
        do {
            let openedGames =  try context.fetch(fetchRequest)
            return openedGames.map({ Int($0.gameId) })
        } catch(let err) {
            assertionFailure("failed to fetch opened games: \(err.localizedDescription)")
            return []
        }
    }
    
    
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LeanGameScale")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // This should never happen in a live app, so crash the app while in development.
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
