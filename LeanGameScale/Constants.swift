//
//  Constants.swift
//  LeanGameScale
//
//  Created by Unal Celik on 8.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import UIKit

typealias S = StringConstants
typealias C = ColorConstants

struct StringConstants {
    static let cellIdentifier = "GameTableCell"
    static let favorite = "Favorite"
    static let favorited = "Favorited"
    static let visitWeb = "Visit Website"
    static let visitReddit = "Visit Reddit"
    static let searchGames = "Search for games"
    static let noGamesFound = "No games found."
    
    static func noGamesFound(for keyword: String) -> String {
        "No games found for \"\(keyword)\""
    }
    
    static func favorites(count: Int? = nil) -> String {
        if let count = count, count > 0 {
            return "Favorites(\(count))"
        }
        return "Favorites"
    }
    
    static let noFavorites = "There is no favorite game."
}

struct ColorConstants {
    static let openedCellColor = UIColor(named: "openedCellBackground")
}
