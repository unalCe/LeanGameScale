//
//  UIViewController-LoadingAnimation.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    internal var spinnerChildVC: SpinnerViewController? {
        children.first(where: { $0 is SpinnerViewController }) as? SpinnerViewController
    }
    
    func startAnimating() {
        if spinnerChildVC != nil {
            return
        }
        
        let spinner = SpinnerViewController()
        
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopAnimating() {
        if spinnerChildVC != nil {
            spinnerChildVC!.willMove(toParent: nil)
            spinnerChildVC!.view.removeFromSuperview()
            spinnerChildVC!.removeFromParent()
        }
    }
}
