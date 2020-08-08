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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView()
        selectedView.backgroundColor = C.openedCellColor
        selectedBackgroundView = selectedView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
        gameImageView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        nameLabel.text = ""
        metacriticPointLabel.text = ""
        genreLabel.text = ""
    }
    
    public func configure(with viewModel: GameTableCellViewModel) {
        backgroundColor = viewModel.isOpenedBefore ? C.openedCellColor : UIColor.white
        nameLabel.text = viewModel.gameName
        metacriticPointLabel.text = viewModel.metacriticScore
        genreLabel.text = viewModel.genres
        
        // This will only happen in favorites view controller
        if let favImageData = viewModel.favoriteImage {
            let favImage = UIImage(data: favImageData)
            gameImageView.image = favImage
            return
        }
        
        gameImageView.kf.indicatorType = .activity
        gameImageView.kf.setImage(with: viewModel.gameImageUrl,
                                      options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(0.5)),
                                        .cacheOriginalImage
        ])
    }
}
