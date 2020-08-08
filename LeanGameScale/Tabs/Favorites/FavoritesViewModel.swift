//
//  FavoritesViewModel.swift
//  LeanGameScale
//
//  Created by Unal Celik on 7.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation

final class FavoritesViewModel {
    
    // MARK: - Properties
    private var favoritedGames: [FavoritedGames] = []
    
    func fetchFavoritedGames() {
        favoritedGames = persistanceService.fetchFavoritedGames()
    }
    
    var gameCount: Int {
        favoritedGames.count
    }
    
    func game(at index: Int) -> FavoritedGames? {
        favoritedGames[safe: index]
    }
    
    func removeGame(at index: Int, completion: @escaping (Bool) -> Void) {
        guard let gameID = game(at: index)?.id else {
            completion(false)
            return
        }
        
        persistanceService.removeFavoritedGame(Int(gameID)) { successful in
            if successful {
                self.favoritedGames.remove(at: index)
            }
            completion(successful)
        }
    }
}
