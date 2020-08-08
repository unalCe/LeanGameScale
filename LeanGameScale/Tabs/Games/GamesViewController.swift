//
//  ViewController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 31.07.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: GamesCoordinator?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: GamesViewModelProtocol! {
        didSet {
            if viewModel != nil { viewModel.delegate = self }
        }
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchAllGames()
        
        setupSearchController()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePopBackCellsIsOpenedColor()
    }
    
    
    // MARK: - Setup UI
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = S.searchGames
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil),
                           forCellReuseIdentifier: S.cellIdentifier)
        tableView.rowHeight = 136
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: - Helper
    
    /// Reloads rows that are currently selected -> updates the backgroundcolor in (cellForRowAt: indexPath)
    private func updatePopBackCellsIsOpenedColor() {
        viewModel.updateAlreadyOpenedGames()
        
        /*
         After returning from a detail screen, the cell still remains selected. We detect that cell and reload it so we configure the cell again in cellForRowAt, this time isOpenedBefore will be set to true.
         */
        if let selectedCellsIndex = tableView.indexPathsForSelectedRows {
            tableView.reloadRows(at: selectedCellsIndex, with: .automatic)
            for cellIndex in selectedCellsIndex {
                tableView.deselectRow(at: cellIndex, animated: true)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension GamesViewController: UITableViewDataSource {
    // Handle empty data result
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.games.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            if let searchKeyword = viewModel.lastSearchedKeyword {
                tableView.setEmptyView(message: S.noGamesFound(for: searchKeyword))
            } else {
                tableView.setEmptyView(message: S.noGamesFound)
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: S.cellIdentifier, for: indexPath) as! GameTableViewCell
        
        let game = viewModel.games[indexPath.row]
        let isOpenedBefore = viewModel.isGameAlreadyOpened(game)
        cell.configure(with: GameTableCellViewModel(game: game,
                                                    isOpenedBefore: isOpenedBefore))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = viewModel.games[safe: indexPath.row], let gameId = game.id else {
            return
        }
        
        coordinator?.showDetail(with: gameId)
        viewModel.saveOpenedGame(with: gameId)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.games.count) - 1  {
            viewModel.fetchMoreForNewPage()
        }
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
        DispatchQueue.main.async {
            switch state {
            case .isLoadingData(let isLoading):
                isLoading ? self.startAnimating() : self.stopAnimating()
            case .dataReady:
                self.tableView.reloadData()
            case .requestFailed(let error):
                debugPrint(error.localizedDescription)
            case .noNetworkConnection:
                debugPrint("No network connection..")
                // TODO: Offline capabilities
            }
        }
    }
}

