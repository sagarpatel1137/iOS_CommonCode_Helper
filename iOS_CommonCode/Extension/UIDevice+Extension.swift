//
//  UIDevice+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import UIKit

extension UIDevice
{
    public var isiPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    public var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
