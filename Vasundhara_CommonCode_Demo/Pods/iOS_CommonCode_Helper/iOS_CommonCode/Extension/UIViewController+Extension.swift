//
//  UIViewController+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import UIKit

extension UIViewController
{
    public func openAppStoreForNotClickableAd(_ headLine : String)
    {
        let tempCommonURl = "itms-apps://itunes.apple.com/app/id"
        var appID = ""
        
        if headLine.contains("Binomo") {
            appID = "1153982927"
        }
        else if headLine.contains("Olymp Trade") {
            appID = "1053416106"
        }
        
        if !appID.isEmpty {
            let url = URL(string: tempCommonURl + appID)!
            UIApplication.shared.canOpenURL(url)
        }
    }
}

