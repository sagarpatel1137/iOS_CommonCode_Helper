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
    public func isSubDiscountAvailable(planInfo: SubscriptionConst.PlanInfo) -> Bool {
        
        if (!Purchase_flag && SubscriptionConst.isGet && !planInfo.plan_Free_Trail.isFreeTrail && !planInfo.plan_Promotional_Offer.isPromotionalOffer) {
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


extension UIViewController
{
    public func openRatingAlert(rateURL: String, mailRecipientEmail: String, mailSubject: String, mailBody: String, complition: ((RatingResponse)-> Void)? = nil)
    {
        let vc = RatingVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.rateURL = rateURL
        vc.mailRecipientEmail = mailRecipientEmail
        vc.mailSubject = mailSubject
        vc.mailBody = mailBody
        vc.completion = { ratingResponse in
            complition?(ratingResponse)
        }
        self.present(vc, animated: true, completion: nil)
    }
}
