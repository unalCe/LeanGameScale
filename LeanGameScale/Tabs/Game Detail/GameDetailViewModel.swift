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
    
    var game: Game?
    
    init(gameID: Int) {
        fetchGameDetails(with: gameID)
    }
    
    private func fetchGameDetails(with gameID: Int) {
        ServiceManager.shared.gameDetail(with: gameID) { (result) in
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
    
    private func isAlreadyFetching() -> Bool {
        switch state {
        case .isLoadingData(let isLoading):
            return isLoading
        default:
            return false
        }
    }
}
