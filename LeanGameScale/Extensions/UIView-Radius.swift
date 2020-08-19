//
//  UIView-Radius.swift
//  LeanGameScale
//
//  Created by Unal Celik on 19.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
}
