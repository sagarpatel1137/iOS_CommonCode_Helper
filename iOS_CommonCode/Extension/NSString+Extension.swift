//
//  UIImageView+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 06/09/24.
//

import UIKit

extension NSString {
    
    func setAttributeToString(font1: UIFont, font2: UIFont, color1: UIColor, color2: UIColor, text: String) -> NSAttributedString {
        
        let substring1 = self as String

        let attributes1 = [NSMutableAttributedString.Key.font: font1, NSMutableAttributedString.Key.foregroundColor : color1]
        let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)

        let attributes2 = [NSMutableAttributedString.Key.font: font2, NSMutableAttributedString.Key.foregroundColor : color2]

        let range = self.range(of: text)
        attrString1.addAttributes(attributes2, range: range)
        return attrString1
    }
}

