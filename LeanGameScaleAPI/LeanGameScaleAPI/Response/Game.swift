//
//  Game.swift
//  LeanGameScaleAPI
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation

public struct Game: Decodable {
    public let id: Int?
    public let name: String?
    public let description: String?
    public let metacritic: Float?
    public let genres: [GameGenre]?
    private let websiteURLAsString: String? // URL?
    private let imageURLAsString: String? //URL?
    private let redditURLasString: String?//URL?
    public let redditName: String?
    
    enum CodingKeys: String, CodingKey {
        case name, description, id, genres, metacritic
        case websiteURLAsString = "website",
        imageURLAsString = "background_image",
        redditURLasString = "reddit_url",
        redditName = "reddit_name"
    }
}

extension Game {
    public var redditURL: URL? {
        redditURLasString.toURL
    }
    
    public var website: URL? {
        websiteURLAsString.toURL
    }
    
    public var backgroundImage: URL? {
        imageURLAsString.toURL
    }
    
    public func genresAsString() -> String? {
        genres?.compactMap({ $0.name }).joined(separator: ", ")
    }
}
