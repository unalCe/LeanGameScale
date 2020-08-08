//
//  GameTableCellViewModel.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScaleAPI

struct GameTableCellViewModel {
    
    private var game: GamesResult?
    private var favoriteGame: FavoritedGames?
    
    /// This viewModel is used in both GamesViewController and FavoritesViewController
    /// - Parameters:
    ///   - game: Game object if set from GamesViewController
    ///   - favoriteGame: Game object if set from FavoritesViewController
    ///   - isOpenedBefore: Determines if this cell is opened before / only used in GamesViewController
    init(game: GamesResult? = nil, favoriteGame: FavoritedGames? = nil, isOpenedBefore: Bool = false) {
        self.game = game
        self.favoriteGame = favoriteGame
        self.isOpenedBefore = isOpenedBefore
    }
    
    private(set) var isOpenedBefore: Bool
    
    var gameName: String? {
        game?.name ?? favoriteGame?.name
    }
    
    var gameImageUrl: URL? {
        game?.backgroundImage
    }
    
    var favoriteImage: Data? {
        favoriteGame?.imageData
    }
    
    var metacriticScore: String? {
        if game?.metacritic != nil {
            return "\(game!.metacritic!)"
        } else if favoriteGame?.metacritic != nil {
            return "\(favoriteGame!.metacritic)"
        } else {
            return "N/A"
        }
    }
    
    var genres: String? {
        game?.genresAsString() ?? favoriteGame?.genres
    }
}
