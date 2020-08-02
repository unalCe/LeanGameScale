//
//  GameTableViewCell.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var metacriticPointLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        metacriticPointLabel.text = ""
        genreLabel.text = ""
    }
    
    public func configure(with viewModel: GameTableCellViewModel) {
        gameImageView.backgroundColor = .orange
        nameLabel.text = viewModel.gameName
        metacriticPointLabel.text = viewModel.metacriticScore
        genreLabel.text = viewModel.genres
    }
}
