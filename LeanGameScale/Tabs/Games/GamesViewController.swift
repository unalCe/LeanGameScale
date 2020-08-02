//
//  ViewController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 31.07.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit
import LeanGameScaleAPI

class GamesViewController: UIViewController, Storyboarded {
    weak var coordinator: GamesCoordinator?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()

//        ServiceManager.shared.fetchAllGames(in: 1) { (<#String?#>, <#Error?#>) in
//            <#code#>
//        }
    }
    
    
    // MARK: - Setup
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for games"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        //tableView.registe
    }
}

extension GamesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // debugPrint(searchController.searchBar.text)
    }
}

