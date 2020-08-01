//
//  MainTabBarController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    let games = GamesCoordinator()
    let favorites = FavoritesCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [games.navigationController, favorites.navigationController]
    }
}
