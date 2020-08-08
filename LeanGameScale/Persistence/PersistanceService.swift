//
//  PersistanceService.swift
//  LeanGameScale
//
//  Created by Unal Celik on 3.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import LeanGameScaleAPI
import Foundation
import CoreData

/// This is a globally reachable persistenceService endpoint for  simpler use.
let persistanceService = PersistanceService.shared

/// Singleton class for handling Core Data related functionality
final class PersistanceService {
    
    static public let shared = PersistanceService()
    
    private init() { }
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    
    private func fetchEntities<T: NSManagedObject>(entity: T.Type, predicateFilter: NSPredicate? = nil) -> [T]? {
        var results: [T]?
        
        if let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
            fetchRequest.predicate = predicateFilter
            do {
                results = try context.fetch(fetchRequest)
            } catch  {
                assert(false, error.localizedDescription)
                return nil
            }
        } else {
            assert(false,"Error: cast to NSFetchRequest<T> failed")
            return nil
        }
        
        return results
    }
    
    
    // MARK: - Opened Games Actions
    
    public func saveOpenedGame(gameId: Int) {
        let openedGame = OpenedGames(context: context)
        openedGame.gameId = Int32(gameId)
        saveContext()
    }
    
    public func fetchOpenedGamesIDs() -> [Int] {
        if let openedGames = fetchEntities(entity: OpenedGames.self) {
            return openedGames.map({ Int($0.gameId)} )
        } else {
            return []
        }
    }
    
    
    // MARK: - Favorite Games
    
    /// Returns true if game exists in favorited database, false otherwise. Returns nil if fetch fails.
    /// - Parameter game: GameID to be searched in favorites
    public func isGameFavorited(_ gameID: Int) -> Bool {
        if let favorited = fetchFavoritedGames(with: gameID) {
            return !favorited.isEmpty
        }
        return false
    }
    
    public func fetchFavoritedGames() -> [FavoritedGames] {
        if let favorited = fetchEntities(entity: FavoritedGames.self) {
            return favorited
        }
        return []
    }
    
    private func fetchFavoritedGames(with gameID: Int) -> [FavoritedGames]? {
        let id = Int32(gameID)
        let predicate = NSPredicate(format: "id == %d", id)
        
        return fetchEntities(entity: FavoritedGames.self, predicateFilter: predicate)
    }
    
    public func saveFavoritedGame(_ game: Game, imageData: Data? = nil) {
        guard let gameID = game.id else { return }
        
        let favoritedGame = FavoritedGames(context: context)
        favoritedGame.id = Int32(gameID)
        favoritedGame.imageData = imageData
        favoritedGame.name = game.name
        favoritedGame.genres = game.genresAsString()
        favoritedGame.metacritic = game.metacritic ?? 0
        saveContext()
    }
    
    public func removeFavoritedGame(_ gameID: Int,
                                    completion: ((_ isSuccessful: Bool) -> Void)? = nil) {
        guard let favGames = fetchFavoritedGames(with: gameID) else {
            completion?(false)
            return
        }
        
        for favGame in favGames {
            context.delete(favGame)
        }
        
        saveContext()
        completion?(true)
    }
    
    
    // MARK: - Core Data stack

    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LeanGameScale")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // This should never happen in a live app, so crash the app while in development.
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
            
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return container
    }()

    // MARK: - Core Data Saving support

    /// Saves the container context -- Always use on the main thread
    public func saveContext () {
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
