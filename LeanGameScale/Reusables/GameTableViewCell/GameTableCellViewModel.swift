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
    
    private var game: GamesResult
    
    init(game: GamesResult, isOpenedBefore: Bool = false) {
        self.game = game
        self.isOpenedBefore = isOpenedBefore
    }
    
    private(set) var isOpenedBefore: Bool
    
    var gameName: String? {
        game.name
    }
    
    var gameImageUrl: URL? {
        game.backgroundImage
    }
    
    var metacriticScore: String? {
        game.metacritic == nil ? "N/A" : "\(game.metacritic!)"
    }
    
    var genres: String? {
        game.genresAsString()
    }
}
