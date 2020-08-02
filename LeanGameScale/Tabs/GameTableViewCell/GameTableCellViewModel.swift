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
    
    init(game: GamesResult) {
        self.game = game
    }
    
    var gameName: String? {
        game.name
    }
    
    var metacriticScore: String? {
        game.metacritic == nil ? "N/A" : "\(game.metacritic!)"
    }
    
    var genres: String? {
        game.genres?.compactMap({ $0.name }).joined(separator: ", ")
    }
}
