//
//  UIViewController+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import UIKit

extension UIViewController
{
    //Native Ads
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
    
    //Subscription
    public func isSubDiscountAvailable() -> Bool {
        
        let monthPlan = SubscriptionConst.ActivePlans.one_Month
        if (!Purchase_flag && SubscriptionConst.isGet && !monthPlan.plan_Free_Trail.isFreeTrail && !monthPlan.plan_Promotional_Offer.isPromotionalOffer) {
            return true
        } else {
            return false
        }
    }
    
    //Alert
    public func systemAlert(title: String?, message: String?, actionDestructive: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: actionDestructive, style: .destructive, handler: nil)
        alertVC.addAction(action1)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    public func systemAlert(title: String?, message: String?, actionDestructive: String, actionDefault: String, complitionDestructive : (()-> Void)? = nil, complitionDefault : (()-> Void)? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: actionDestructive, style: .destructive) { action in
            complitionDestructive?()
        }
        alertVC.addAction(action1)
        let action2 = UIAlertAction(title: actionDefault, style: .default) { action in
            complitionDefault?()
        }
        alertVC.addAction(action2)
        self.present(alertVC, animated: true, completion: nil)
    }
}

