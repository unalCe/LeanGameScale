//
//  GamesResponse.swift
//  LeanGameScaleAPI
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation

public struct BaseGamesResponse: Decodable {
    public let count: Int?
    public let next: URL?
    public let previous: URL?
    public let results: [GamesResult]
}
