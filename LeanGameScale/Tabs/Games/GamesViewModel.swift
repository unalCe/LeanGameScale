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
    private var isSearching: Bool = false
    
    /// Current page that will be requested
    private var page: Int = 1
    private var searchingPage: Int = 1
    
    private var allGames: [GamesResult] = []
    private var searchedGames: [GamesResult] = []
    
    // This is the only reachable endpoint for games objects
    /// Returns viewModel's games according to search state
    public var games: [GamesResult] {
        isSearching ? searchedGames : allGames
    }
    
    // MARK: - Service
    func fetchAllGames() {
        isSearching = false
        state = .isLoadingData(true)
        ServiceManager.shared.fetchAllGames(in: page) { (result) in
            self.state = .isLoadingData(false)
            switch result {
            case .success(let response):
                self.allGames = response.results
                self.state = .dataReady
            case .failure(let err):
                self.state = .requestFailed(err)
            }
        }
    }
    
    /// Search games with the given keyword
    /// - Parameter keyword: Search text
    func searchGames(with keyword: String) {
        isSearching = true
        state = .isLoadingData(true)
        ServiceManager.shared.searchGames(with: keyword, in: searchingPage) { (result) in
            self.state = .isLoadingData(false)
            switch result {
            case .success(let response):
                self.searchedGames = response.results
                self.state = .dataReady
            case .failure(let err):
                self.state = .requestFailed(err)
            }
        }
    }
}
