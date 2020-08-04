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
    
    var favGames: [CDGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favorites")
        tableView.dataSource = self
        tableView.rowHeight = 90
                
        
        let fetchReq: NSFetchRequest<CDGame> = CDGame.fetchRequest()
        
        do {
            favGames = try PersistanceService.context.fetch(fetchReq)
            tableView.reloadData()
        } catch(let err) {
            debugPrint(err.localizedDescription)
        }
        
        
    }
}


extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorites", for: indexPath)
        cell.textLabel?.text = favGames[safe: indexPath.row]?.name
        return cell
    }
    
    
}
