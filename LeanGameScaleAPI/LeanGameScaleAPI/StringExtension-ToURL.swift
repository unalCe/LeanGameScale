//
//  StringExtension-ToURL.swift
//  LeanGameScaleAPI
//
//  Created by Unal Celik on 8.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var toURL: URL? {
        if let str = self {
            return URL(string: str)
        }
        return nil
    }
}
