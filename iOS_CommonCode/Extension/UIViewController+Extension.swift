//
//  UIViewController+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import UIKit
import MBProgressHUD

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
    public func startLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    public func stopLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // Push
    func pushVC(vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func pushVCId(withIdentifier: String, animated:Bool) {
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: withIdentifier) {
            self.navigationController?.pushViewController(newVC, animated: animated)
        }
    }
    
    // Pop
    func popVC(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func popSpecificVC(vc: UIViewController.Type, animated: Bool) {
        guard let navigationController = self.navigationController else { return }
        
        for controller in navigationController.viewControllers as Array {
            if controller.isKind(of: vc.self) {
                navigationController.popToViewController(controller, animated: animated)
                break
            }
        }
    }
    
    // Present
    func presentView(withIdentifier: String) {
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: withIdentifier) {
            newVC.modalPresentationStyle = .overFullScreen
            self.present(newVC, animated: true, completion: nil)
        }
    }
    
    func presentVC(vc: UIViewController,_ isAnimation : Bool = true) {
        DispatchQueue.main.async{
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: isAnimation, completion: nil)
        }
    }
    
    public func openRatingAlert(rateURL: String, mailRecipientEmail: String, mailSubject: String, mailBody: String, complition: ((RatingResponse)-> Void)? = nil) {
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
    
    public func openFeedbackVC(customization: UICustomizationFeedback? = nil) {
        let feedbackVC = FeedbackVC()
        feedbackVC.customization = customization ?? UICustomizationFeedback()
        pushVC(vc: feedbackVC, animated: true)
    }
    
    public func openWebVC(titleStr: String, urlStr: String, customization: UICustomizationWebView? = nil) {
        let feedbackVC = webVC()
        feedbackVC.titleStr = titleStr
        feedbackVC.urlStr = urlStr
        feedbackVC.customization = customization ?? UICustomizationWebView()
        pushVC(vc: feedbackVC, animated: true)
    }
    
    public func openSubTimelineVC(
        featureList: [String],
        arrFeature: [FeatureModel],
        arrReview: [ReviewModel],
        subsciptionContinueBtnTextIndex: Int,
        customizationSubTimelineTheme: UICustomizationSubTimelineTheme,
        completionTimeline: @escaping (SubCloseCompletionBlock) -> Void
    ) {
        let subTimelineVC = SubTimelineVC()
        subTimelineVC.featureList = featureList
        subTimelineVC.arrFeature = arrFeature
        subTimelineVC.arrReview = arrReview
        subTimelineVC.subsciptionContinueBtnTextIndex = subsciptionContinueBtnTextIndex
        subTimelineVC.customizationSubTimelineTheme = customizationSubTimelineTheme
        subTimelineVC.completionTimeline = { result in
            completionTimeline(result)
        }
        subTimelineVC.modalPresentationStyle = .fullScreen
        subTimelineVC.modalTransitionStyle = .crossDissolve
        self.present(subTimelineVC, animated: true, completion: nil)
    }
    
    public func openSubAllPlanVC(
        isFromTimeline: Bool,
        arrFeature: [FeatureModel],
        arrReview: [ReviewModel],
        subsciptionContinueBtnTextIndex: Int,
        customizationSubRatingData: UICustomizationSubRatingData,
        completionMorePlan: @escaping (SubCloseCompletionBlock) -> Void
    ) {
        let subAllPlanVC = SubAllPlanVC()
        subAllPlanVC.isFromTimeline = isFromTimeline
        subAllPlanVC.arrFeature = arrFeature
        subAllPlanVC.arrReview = arrReview
        subAllPlanVC.subsciptionContinueBtnTextIndex = subsciptionContinueBtnTextIndex
        subAllPlanVC.customizationSubRatingData = customizationSubRatingData
        subAllPlanVC.completionMorePlan = { result in
            completionMorePlan(result)
        }
        subAllPlanVC.modalPresentationStyle = .fullScreen
        self.present(subAllPlanVC, animated: true, completion: nil)
    }
    
    public func openSubDiscountVC(
        customizationSubDiscountTheme: UICustomizationSubDiscountTheme,
        completionDiscount: @escaping (SubCloseCompletionBlock) -> Void
    ) {
        let vc = SubDiscountVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.customizationSubDiscountTheme = customizationSubDiscountTheme
        vc.completionDiscount = { result in
            completionDiscount(result)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    public func openThankYouVC(
        customizationSubThankYouTheme: UICustomizationSubThankYouTheme? = nil,
        customizationSubThankYouData: UICustomizationSubThankYouData? = nil
    ) {
        let thankYouVC = ThankYouVC()
        thankYouVC.customizationSubThankYouTheme = customizationSubThankYouTheme ?? UICustomizationSubThankYouTheme()
        thankYouVC.customizationSubThankYouData = customizationSubThankYouData ?? UICustomizationSubThankYouData()
        presentVC(vc: thankYouVC)
    }
}
