//
//  Coordinators.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    // func start()
}

// This is a common use in both GamesCoordinator and FavoritesCoordinator
extension Coordinator {
    public func showDetail(with gameId: Int) {
        let detailViewController = GameDetailViewController.instantiate(storyboard: .GameDetail)
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        
        detailViewController.viewModel = GameDetailViewModel(gameID: gameId)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

