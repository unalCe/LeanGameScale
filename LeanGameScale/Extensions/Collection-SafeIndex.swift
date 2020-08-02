//
//  Collection-SafeIndex.swift
//  LeanGameScale
//
//  Created by Unal Celik on 2.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation

public extension Collection {
    /// Search contains index of array, if it exists returns element otherwise returns nil.
    /// That extension prevents fatal error about index out of range
    ///
    /// - Parameter index: Index tried to be accessed
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self [index] : nil
    }
}
