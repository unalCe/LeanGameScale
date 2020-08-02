//
//  UIViewController-LoadingAnimation.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func startAnimating() {
        debugPrint("Loading Started")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopAnimating() {
        debugPrint("Loading Stopped")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
