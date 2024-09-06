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
