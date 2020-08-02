//
//  Storyboarded.swift
//  LeanGameScale
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

public enum Storyboards: String {
    case Favorites
    case Games
    case GameDetail
}

/// A protocol that lets us instantiate view controllers from Main storyboard.
protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    // Creates a view controller from our storyboard. This relies on view controllers having the same storyboard identifier as their class name. This method shouldn't be overridden in conforming types.
    static func instantiate(storyboard: Storyboards? = nil) -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard?.rawValue ?? "Main", bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
