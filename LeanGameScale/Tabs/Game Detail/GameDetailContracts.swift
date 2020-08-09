//
//  GameDetailContracts.swift
//  LeanGameScale
//
//  Created by Unal Celik on 6.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScaleAPI

protocol GameDetaiViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? { get set }
    var game: Game? { get set }
    init(gameID: Int, service: ServiceManagerProtocol)
}

protocol GameDetailViewModelDelegate: class {
    func handleGameDetailState(_ state: GameDetailModelState)
    func updateFavoriteStatus(_ isFavorite: Bool)
}

public enum GameDetailModelState {
    case isLoadingData(Bool)
    case dataReady
    case requestFailed(Error)
}
