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
    var games: [GamesResult] { get }
    func isGameAlreadyOpened(_ game: GamesResult) -> Bool
    func saveOpenedGame(with gameID: Int)
    func fetchAlreadyOpenedGames()
    func fetchAllGames()
    func searchGames(with keyword: String)
    func fetchMoreForNewPage()
}

protocol GamesViewModelDelegate: class {
    func handleGamesDataState(_ state: GamesViewModelState)
}

public enum GamesViewModelState {
    case isLoadingData(Bool)
    case dataReady
    case requestFailed(Error)
}
