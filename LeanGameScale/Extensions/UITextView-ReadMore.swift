//
//  UITextView-ReadMore.swift
//  LeanGameScale
//
//  Created by Unal Celik on 8.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit

extension UITextView {
    
    func addTrailing(with trailingText: String = "...", moreText: String, moreTextFont: UIFont? = nil, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        
        let trimmedString: String? = (mutableString as NSString).substring(to: lengthForVisibleString)
        
        if ((self.text?.count)! - lengthForVisibleString) <= 0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4
            let answerAttributed = NSMutableAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font: self.font!, NSAttributedString.Key.paragraphStyle: style])
            self.attributedText = answerAttributed
            return
        }
        
        let leviTrimmedForReadMore = String(trimmedString ?? "") + readMoreText
        self.text = leviTrimmedForReadMore
        let ddlengthForVisibleString: Int = self.vissibleTextLength
        if ((self.text?.count)! - ddlengthForVisibleString) <= 0 {
            
            let trimmedForReadMore: String = trimmedString! + trailingText
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!, NSAttributedString.Key.paragraphStyle: style])
            
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont ?? self.font!, NSAttributedString.Key.foregroundColor: moreTextColor, NSAttributedString.Key.paragraphStyle: style])
            
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
        else {
            let readMoreLength: Int = (readMoreText.utf16.count)
            
            let trimmedForReadMore: String = (trimmedString! as NSString).substring(to: (trimmedString?.utf16.count ?? 0) - readMoreLength) + trailingText
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4
            
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!, NSAttributedString.Key.paragraphStyle: style])
            
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont ?? self.font!, NSAttributedString.Key.foregroundColor: moreTextColor, NSAttributedString.Key.paragraphStyle: style])
            
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font ?? UIFont.systemFont(ofSize: 14)
        let mode: NSLineBreakMode = self.textContainer.lineBreakMode
        let labelWidth: CGFloat = self.bounds.size.width
        let labelHeight: CGFloat = self.textContainer.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
    // http://findnerd.com/list/view/How-to-detect-tapped-word-in-UItextview/771/
    
    func wordAtPosition(point: CGPoint) -> String? {
        var position = point
        position.y = point.y + contentOffset.y
        
        guard let tapPosition = closestPosition(to: position),
            let textRange = tokenizer.rangeEnclosingPosition(tapPosition,
                                                             with: .word,
                                                             inDirection: .layout(.right)) else {
                                                                return nil
        }
        
        return text(in: textRange)
    }
}

