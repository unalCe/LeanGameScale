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
    public let website: URL?
    public let backgroundImage: URL?
    public let redditURL: URL?
    public let redditName: String?
    
    enum CodingKeys: String, CodingKey {
        case name, description, website, id
        case backgroundImage = "background_image", redditURL = "reddit_url", redditName = "reddit_name"
    }
}
