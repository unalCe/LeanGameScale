//
//  GamesCoordinator.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

final class GamesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        let viewController = GamesViewController.instantiate(storyboard: .Games)
        viewController.tabBarItem = UITabBarItem(title: Storyboards.Games.rawValue,
                                                 image: UIImage(named: "GamesTab"),
                                                 tag: 0)
        viewController.coordinator = self
        viewController.viewModel = GamesViewModel()

        navigationController.viewControllers = [viewController]
    }
    
    public func showDetail(with gameId: String) {
        let detailViewController = GameDetailViewController.instantiate(storyboard: .GameDetail)
        detailViewController.gameName = gameId
        detailViewController.image = #imageLiteral(resourceName: "GamesTab")
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
