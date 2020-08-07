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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favorites")
        tableView.dataSource = self
        tableView.rowHeight = 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableData()
    }
    
    
    // MARK: - Helper
    private func updateTableData() {
        viewModel.fetchFavoritedGames()
        tableView.reloadData()
    }
}


// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gameCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorites", for: indexPath)
        let game = viewModel.game(at: indexPath.row)
        cell.textLabel?.text = game?.name
        // debugPrint(favGames[safe: indexPath.row]?.imageData)
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: push detail from coordinator
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeGame(at: indexPath.row) { (success) in
                if success {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}
