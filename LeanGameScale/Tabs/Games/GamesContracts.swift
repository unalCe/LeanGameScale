//
//  GamesContracts.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScaleAPI

protocol GamesViewModelProtocol {
    var delegate: GamesViewModelDelegate? { get set }
    init(service: ServiceManagerProtocol)
    var games: [GamesResult] { get }
    var lastSearchedKeyword: String? { get }
    func isGameAlreadyOpened(_ game: GamesResult) -> Bool
    func saveOpenedGame(with gameID: Int)
    func updateAlreadyOpenedGames()
    func fetchAllGames()
    func searchGames(with keyword: String)
    func fetchMoreForNewPage()
}

public protocol GamesViewModelDelegate: class {
    func handleGamesDataState(_ state: GamesViewModelState)
}

public enum GamesViewModelState: Equatable {
    case isLoadingData(Bool)
    case dataReady
    case requestFailed(APIError)
    case noNetworkConnection
}
