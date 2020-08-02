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
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: GamesCoordinator?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: GamesViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchAllGames()
        
        setupSearchController()
        setupTableView()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "denemeCell")
        tableView.rowHeight = 120
        tableView.dataSource = self
    }
}

extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "denemeCell", for: indexPath)
        
        let game = viewModel.games[indexPath.row]
        
        cell.textLabel?.text = game.name
        
        return cell
    }
}


// MARK: - UISearchResultsUpdating
extension GamesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text != "" {
            viewModel.searchGames(with: text)
        } else {
            viewModel.fetchAllGames()
        }
    }
}


// MARK: - GamesViewModelDelegate
extension GamesViewController: GamesViewModelDelegate {
    func handleGamesDataState(_ state: GamesViewModelState) {
        switch state {
        case .isLoadingData(let isLoading):
            isLoading ? startAnimating() : stopAnimating()
        case .dataReady:
            tableView.reloadData()
        case .requestFailed(let error):
            debugPrint(error.localizedDescription)
        }
    }
}

