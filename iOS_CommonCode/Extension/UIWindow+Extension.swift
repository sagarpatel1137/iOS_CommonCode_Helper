//
//  UIWindow+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 06/09/24.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
