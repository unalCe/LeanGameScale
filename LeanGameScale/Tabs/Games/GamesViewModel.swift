//
//  GamesViewModel.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScaleAPI

final class GamesViewModel: GamesViewModelProtocol {
    
    // MARK: - Properties
    
    weak var delegate: GamesViewModelDelegate?
    
    private var state: GamesViewModelState? {
        didSet {
            if state != nil {
                delegate?.handleGamesDataState(state!)
            }
        }
    }
    
    /// Current search state of the viewModel
    private(set) var isSearching: Bool = false
    private(set) var lastSearchedKeyword: String?
    
    /// Current page that will be requested
    private(set) var page: Int = 1
    private(set) var searchingPage: Int = 1
    
    private var allGames: [GamesResult] = []
    private var searchedGames: [GamesResult] = []
    
    // This is the only reachable endpoint for games objects
    /// Returns viewModel's games according to search state
    public var games: [GamesResult] {
        isSearching ? searchedGames : allGames
    }
    
    private var previouslyOpenedGamesIDs: [Int] = []
    
    // MARK: - Initialization - DI
    private var service: ServiceManagerProtocol!
    
    init(service: ServiceManagerProtocol = ServiceManager.shared) {
        self.service = service
    }
    
    // MARK: - Service
    
    func fetchAllGames() {
        if isAlreadyFetching() { return }
        
        isSearching = false
        state = .isLoadingData(true)
        service.fetchAllGames(in: page) { (result) in
            self.state = .isLoadingData(false)
            switch result {
            case .success(let response):
                self.allGames.append(contentsOf: response.results)
                self.state = .dataReady
                self.page += 1
            case .failure(let err):
                if err == .noConnection {
                    self.state = .noNetworkConnection
                    return
                }
                self.state = .requestFailed(err)
            }
        }
    }
    
    /// Search games with the given keyword
    /// - Parameter keyword: Search text
    func searchGames(with keyword: String) {
        if isAlreadyFetching() { return }
        
        // If the user entered a new search keyword, reset existing search data
        if keyword != lastSearchedKeyword {
            searchedGames = []
            searchingPage = 1
            lastSearchedKeyword = keyword
        }
        
        isSearching = true
        state = .isLoadingData(true)
        service.searchGames(with: keyword, in: searchingPage) { (result) in
            self.state = .isLoadingData(false)
            switch result {
            case .success(let response):
                self.searchedGames.append(contentsOf: response.results)
                self.state = .dataReady
                self.searchingPage += 1
            case .failure(let err):
                self.state = .requestFailed(err)
            }
        }
    }
    
    func fetchMoreForNewPage() {
        if isSearching, let lastSearchKeyword = lastSearchedKeyword {
            searchGames(with: lastSearchKeyword)
        } else {
            fetchAllGames()
        }
    }
    
    private func isAlreadyFetching() -> Bool {
        switch state {
        case .isLoadingData(let isLoading):
            return isLoading
        default:
            return false
        }
    }
    
    
    // MARK: - Opened Games Stack
    
    func updateAlreadyOpenedGames() {
        previouslyOpenedGamesIDs = persistanceService.fetchOpenedGamesIDs()
    }
    
    func saveOpenedGame(with gameID: Int) {
        persistanceService.saveOpenedGame(gameId: gameID)
        previouslyOpenedGamesIDs.append(gameID)
    }
    
    func isGameAlreadyOpened(_ game: GamesResult) -> Bool {
        guard let gameID = game.id else {
            return false
        }
        
        return previouslyOpenedGamesIDs.contains(gameID)
    }
}
