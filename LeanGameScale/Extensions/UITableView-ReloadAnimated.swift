//
//  UITableView-ReloadAnimated.swift
//  LeanGameScale
//
//  Created by Unal Celik on 3.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadAnimated() {
        DispatchQueue.main.async {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.reloadData() },
                              completion: nil)
        }
    }
}
