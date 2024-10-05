//
//  String+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 06/09/24.
//

import UIKit

extension String
{
    public func getWidthForString(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }

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

extension String {
    
    func localized() -> String
    {
        var defaultLanguage = Pod_AppLaungauge_Code
        if defaultLanguage.count == 0{
            defaultLanguage = "en"
        }
        if let path = Bundle.main.path(forResource: defaultLanguage, ofType: "strings") {
            if FileManager.default.fileExists(atPath: path) {
                let dicoLocalisation = NSDictionary(contentsOfFile: path)
                return dicoLocalisation?.value(forKey: self) as? String ?? self
            }
        }
        return self
    }
}
