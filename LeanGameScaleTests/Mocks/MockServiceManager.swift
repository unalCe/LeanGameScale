//
//  MockServiceManager.swift
//  LeanGameScaleTests
//
//  Created by Unal Celik on 9.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScaleAPI

class MockServiceManager: ServiceManagerProtocol {
    
    var gamesResult: BaseGamesResponse!
    var gameDetail: Game!
    
    func fetchAllGames(in page: Int, completion: @escaping (Result<BaseGamesResponse, APIError>) -> Void) {
        if page <= 0 {  // Enter page less than 1 for testing failure
            completion(.failure(APIError.decodingError))
        }
        completion(.success(gamesResult))
    }
    
    func gameDetail(with gameId: Int, completion: @escaping (Result<Game, APIError>) -> Void) {
//        if gameId == 1995 {
//            completion(.success(try! MockDataLoader.loadGame(resource: .game2)))
//        } else if gameId == 2020 {
//            completion(.success(try! MockDataLoader.loadGame(resource: .game3)))
//        }
//        completion(.success(try! MockDataLoader.loadGame(resource: .game1)))
        completion(.success(gameDetail))
    }
    
    func searchGames(with keyword: String, in page: Int, completion: @escaping (Result<BaseGamesResponse, APIError>) -> Void) {
        if page <= 0 {
            completion(.failure(APIError.invalidResponse))
        }
        completion(.success(gamesResult))
    }
}
