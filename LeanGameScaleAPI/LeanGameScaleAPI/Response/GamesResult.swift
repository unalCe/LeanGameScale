//
//  GamesResult.swift
//  LeanGameScaleAPI
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation

public struct GamesResult: Decodable {
    public let id: Int?
    public let name: String?
    public let backgroundImage: URL?
    public let rating: Float?
    public let metacritic: Float?
    public let genres: [GameGenre]?
    
    public enum CodingKeys: String, CodingKey {
        case name, rating, metacritic, genres, id
        case backgroundImage = "background_image"
    }
}

extension GamesResult {
    public func genresAsString() -> String? {
        genres?.compactMap({ $0.name }).joined(separator: ", ")
    }
}
