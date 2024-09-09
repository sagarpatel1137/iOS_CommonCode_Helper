//
//  String+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 06/09/24.
//

import UIKit

extension String
{
    // total width of text for const height
    public func getWidthForString(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    // total height of text for const width
    public func getHeightForString(withConstrainedWidth width: CGFloat, font: UIFont, maxLines: CGFloat = 0) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        let height = ceil(boundingBox.height)
        if maxLines > 0 {
            let lines = height / font.lineHeight
            
            if lines >= maxLines {
                return (boundingBox.height / lines) * maxLines
            }
        }
        
        return height
    }
    
    // count total numner of line of text for const width
    public func countNumberOfLine(font:UIFont,width:CGFloat) -> Int
    {
        let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = self
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    public func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}
