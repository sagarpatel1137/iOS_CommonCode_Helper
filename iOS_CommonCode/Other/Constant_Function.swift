//
//  Constant_Function.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import UIKit
import Foundation

public func funGetTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
    
    if let nav = base as? UINavigationController {
        return funGetTopViewController(base: nav.visibleViewController)
        
    } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
        return funGetTopViewController(base: selected)
        
    } else if let presented = base?.presentedViewController {
        return funGetTopViewController(base: presented)
    }
    return base
}

public func hexStringToUIColor (hex:String, alpha:CGFloat = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}
