//
//  FavoritesViewController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: FavoritesCoordinator?
    var viewModel: FavoritesViewModel!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableData()
    }
    
    
    // MARK: - Setup
    
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
    
    private func updateTableData(shouldReload: Bool = true) {
        viewModel.fetchFavoritedGames()
        title = S.favorites(count: viewModel.gameCount)
        if shouldReload {
            tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    // Handle empty data result
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.gameCount > 0 || tableView.hasUncommittedUpdates {
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.setEmptyView(message: S.noFavorites)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gameCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: S.cellIdentifier, for: indexPath) as! GameTableViewCell
        
        let favoriteGame = viewModel.game(at: indexPath.row)
        cell.configure(with: GameTableCellViewModel(favoriteGame: favoriteGame))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeGame(at: indexPath.row) { (success) in
                if success {
                    self.updateTableData(shouldReload: false)
                    
                    tableView.beginUpdates()

                    // Either delete some rows within a section (leaving at least one) or the entire section.
                    if self.viewModel.gameCount > 0 {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        // Section is now completely empty, so delete the entire section.
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    }

                    tableView.endUpdates()
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let game = viewModel.game(at: indexPath.row) else {
            return
        }
        coordinator?.showDetail(with: Int(game.id))
    }
}
