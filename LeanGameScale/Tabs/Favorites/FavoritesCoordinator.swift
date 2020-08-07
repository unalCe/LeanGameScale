//
//  FavoritesCoordinator.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        let viewController = FavoritesViewController.instantiate(storyboard: .Favorites)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        viewController.coordinator = self
        
        viewController.viewModel = FavoritesViewModel()

        navigationController.viewControllers = [viewController]
    }
    
}
