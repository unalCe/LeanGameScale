//
//  GameTableViewCell.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit
import Kingfisher

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var metacriticPointLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        nameLabel.text = ""
        metacriticPointLabel.text = ""
        genreLabel.text = ""
    }
    
    public func configure(with viewModel: GameTableCellViewModel) {
        nameLabel.text = viewModel.gameName
        metacriticPointLabel.text = viewModel.metacriticScore
        genreLabel.text = viewModel.genres
        
        gameImageView.kf.setImage(with: viewModel.gameImageUrl,
                                      options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
        ])
    }
}
