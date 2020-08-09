//
//  GameTitleGradientView.swift
//  LeanGameScale
//
//  Created by Unal Celik on 9.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

class GameTitleGradientView: UIView {
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
    }
}
