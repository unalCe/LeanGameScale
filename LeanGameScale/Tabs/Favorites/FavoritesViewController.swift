//
//  FavoritesViewController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit
import CoreData

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gameCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: S.cellIdentifier, for: indexPath)
        let game = viewModel.game(at: indexPath.row)
        cell.textLabel?.text = game?.name
        // debugPrint(favGames[safe: indexPath.row]?.imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeGame(at: indexPath.row) { (success) in
                if success {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.updateTableData(shouldReload: false)
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
