//
//  GameDetailViewModel.swift
//  LeanGameScale
//
//  Created by Unal Celik on 6.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScaleAPI

final class GameDetailViewModel: GameDetaiViewModelProtocol {
    
    // MARK: - Properties
    
    weak var delegate: GameDetailViewModelDelegate?
    
    private var state: GameDetailModelState? {
        didSet {
            if state != nil {
                delegate?.handleGameDetailState(state!)
            }
        }
    }
    
    // Game object that will be filled after the request from service
    var game: Game?
    
    private var gameID: Int
    
    var isGameFavorited: Bool {
        persistanceService.isGameFavorited(gameID)
    }
    
    
    // MARK: - Initialization
    
    init(gameID: Int) {
        self.gameID = gameID
        fetchGameDetails(with: gameID)
    }
    
    
    // MARK: - Service
    
    private func fetchGameDetails(with gameID: Int) {
        state = .isLoadingData(true)
        ServiceManager.shared.gameDetail(with: gameID) { (result) in
            //self.state = .isLoadingData(false)
            switch result {
            case .success(let gameResponse):
                self.game = gameResponse
                self.state = .dataReady
            case .failure(let err):
                self.state = .requestFailed(err)
            }
        }
    }
    
    
    // MARK: - Helpers
    
    /// Saves a favorited game on CoreData
    /// - Parameter imageData: game image data to be saved
    func saveFavoritedGame(with imageData: Data?) {
        guard let game = game else {
            assertionFailure("Game object cannot be nil")
            return
        }
        persistanceService.saveFavoritedGame(game, imageData: imageData)
        delegate?.updateFavoriteStatus(isGameFavorited)
    }
    
    /// Deletes the favorited game if already exists in CoreData
    func removeFavoritedGame() {
        persistanceService.removeFavoritedGame(gameID)
        delegate?.updateFavoriteStatus(isGameFavorited)
    }
}
