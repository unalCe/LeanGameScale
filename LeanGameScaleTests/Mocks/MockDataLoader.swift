//
//  MockDataLoader.swift
//  LeanGameScaleTests
//
//  Created by Unal Celik on 9.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScale
import LeanGameScaleAPI

class MockDataLoader: NSObject {
    
    enum GameResource: String {
        case game1
        case game2
        case game3
    }
    
    static func loadGame(resource: GameResource) throws -> Game {
        try bringJsonFrom(resource.rawValue, resultType: Game.self)
    }
    
    static func loadGamesResult() throws -> BaseGamesResponse {
        try bringJsonFrom("gameResults", resultType: BaseGamesResponse.self)
    }
    
    private static func bringJsonFrom<T: Decodable>(_ resource: String, resultType: T.Type) throws -> T {
        let bundle = Bundle(for: MockDataLoader.self)
        let url = bundle.url(forResource: resource, withExtension: "json")!
        let data = try Data(contentsOf: url)
        let object = try JSONDecoder().decode(T.self, from: data)
        return object
    }
}
