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
    private var lastSearchedKeyword: String?
    
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
        if isAlreadyFetching() { return }
        
        isSearching = false
        state = .isLoadingData(true)
        ServiceManager.shared.fetchAllGames(in: page) { (result) in
            self.state = .isLoadingData(false)
            switch result {
            case .success(let response):
                self.allGames.append(contentsOf: response.results)
                self.state = .dataReady
                self.page += 1
            case .failure(let err):
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
        ServiceManager.shared.searchGames(with: keyword, in: searchingPage) { (result) in
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
    
    func handlePagination() {
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
}
