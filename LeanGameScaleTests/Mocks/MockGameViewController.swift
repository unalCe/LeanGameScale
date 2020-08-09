//
//  MockGameViewController.swift
//  LeanGameScaleTests
//
//  Created by Unal Celik on 9.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation
import LeanGameScale

class MockGameViewController: GamesViewModelDelegate {
    var states: [GamesViewModelState] = []
    
    func handleGamesDataState(_ state: GamesViewModelState) {
        states.append(state)
    }
}
