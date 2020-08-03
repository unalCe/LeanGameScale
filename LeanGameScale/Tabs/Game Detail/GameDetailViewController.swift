//
//  GameDetailViewController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 3.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController, Storyboarded {

    @IBOutlet weak var gameIDLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var isFavoritedLabel: UILabel!
    
    var gameName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gameNameLabel.text = gameName
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
    }
}
