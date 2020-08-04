//
//  UITableView-EmptyDataView.swift
//  LeanGameScale
//
//  Created by Unal Celik on 5.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setEmptyView(message: String) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0),
                          size: CGSize(width: self.bounds.size.width,
                                       height: self.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.backgroundColor = UIColor(named: "openedCellBackground")
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }
}
