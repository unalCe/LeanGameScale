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
    weak var coordinator: FavoritesCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    var favGames: [FavoritedGames] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favorites")
        tableView.dataSource = self
        tableView.rowHeight = 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: In View Model
        favGames = persistanceService.fetchFavoritedGames()
    }
}


extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorites", for: indexPath)
        cell.textLabel?.text = favGames[safe: indexPath.row]?.name
        // debugPrint(favGames[safe: indexPath.row]?.imageData)
        return cell
    }
}
