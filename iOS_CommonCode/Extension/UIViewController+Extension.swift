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
    
    public func openRatingAlert(
        rateURL: String,
        mailRecipientEmail: String,
        mailSubject: String,
        mailBody: String,
        isOpenFrom: String,
        complition: ((RatingResponse)-> Void)? = nil
    ) {
        let vc = RatingVC()
        vc.rateURL = rateURL
        vc.mailRecipientEmail = mailRecipientEmail
        vc.mailSubject = mailSubject
        vc.mailBody = mailBody
        vc.isOpenFrom = isOpenFrom
        vc.completion = { ratingResponse in
            complition?(ratingResponse)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    public func openFeedbackVC(customization: UICustomizationFeedback? = nil) {
        let feedbackVC = FeedbackVC()
        feedbackVC.customization = customization ?? UICustomizationFeedback()
        feedbackVC.modalPresentationStyle = .overFullScreen
        feedbackVC.modalTransitionStyle = .crossDissolve
        self.present(feedbackVC, animated: true, completion: nil)
    }
    
    public func openWebVC(
        titleStr: String,
        urlStr: String,
        customization: UICustomizationWebView? = nil,
        completion: (()-> Void)? = nil
    ) {
        let webVC = webVC()
        webVC.titleStr = titleStr
        webVC.urlStr = urlStr
        webVC.customization = customization ?? UICustomizationWebView()
        webVC.modalPresentationStyle = .overFullScreen
        webVC.modalTransitionStyle = .crossDissolve
        webVC.completionBack = {
            completion?()
        }
        self.present(webVC, animated: true, completion: nil)
    }
    
    public func openSubTimelineVC(
        viewAllPlanType: ViewAllPlanType,
        featureList: [String],
        arrFeature: [FeatureModel],
        arrReview: [ReviewModel],
        subsciptionContinueBtnTextIndex: Int,
        enableRatingAutoScroll: Bool = true,
        isRatingScrollEnable: Bool = true,
        customizationSubTimelineTheme: UICustomizationSubTimelineTheme? = nil,
        customizationSubMorePlan: UICustomizationSubMorePlan? = nil,
        customizationSubRatingData: UICustomizationSubRatingData?,
        lifetimeDiscountVal: Int = 80,
        isOpenFrom: String,
        completionTimeline: @escaping (SubCloseCompletionBlock, [String: String]?) -> Void
    ) {
        let subTimelineVC = SubTimelineVC()
        subTimelineVC.viewAllPlanType = viewAllPlanType
        subTimelineVC.featureList = featureList
        subTimelineVC.arrFeature = arrFeature
        subTimelineVC.arrReview = arrReview
        subTimelineVC.subsciptionContinueBtnTextIndex = subsciptionContinueBtnTextIndex
        subTimelineVC.enableRatingAutoScroll = enableRatingAutoScroll
        subTimelineVC.isRatingScrollEnable = isRatingScrollEnable
        subTimelineVC.customizationSubTimelineTheme = customizationSubTimelineTheme ?? UICustomizationSubTimelineTheme()
        subTimelineVC.customizationSubRatingData = customizationSubRatingData
        subTimelineVC.customizationSubMorePlan = customizationSubMorePlan
        subTimelineVC.lifetimeDiscountVal = lifetimeDiscountVal
        subTimelineVC.isOpenFrom = isOpenFrom
        subTimelineVC.completionTimeline = { (result, param) in
            completionTimeline(result, param)
        }
        subTimelineVC.modalPresentationStyle = .fullScreen
        subTimelineVC.modalTransitionStyle = .crossDissolve
        self.present(subTimelineVC, animated: true, completion: nil)
    }
    
    public func openSubMorePlanVC(
        isFromTimeline: Bool,
        arrReview: [ReviewModel],
        customizationSubMorePlan: UICustomizationSubMorePlan?,
        customizationSubRatingData: UICustomizationSubRatingData?,
        isOpenFrom: String,
        completionMorePlan: @escaping (SubCloseCompletionBlock, [String: String]?) -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            let subAllPlanVC = SubMorePlanVC()
            subAllPlanVC.isFromTimeline = isFromTimeline
            subAllPlanVC.arrReview = arrReview
            subAllPlanVC.customizationSubMorePlan = customizationSubMorePlan
            subAllPlanVC.customizationSubRatingData = customizationSubRatingData
            subAllPlanVC.isOpenFrom = isOpenFrom
            subAllPlanVC.completionMorePlan = { (result, param) in
                completionMorePlan(result, param)
            }
            subAllPlanVC.modalPresentationStyle = .fullScreen
            subAllPlanVC.modalTransitionStyle = .crossDissolve
            self.present(subAllPlanVC, animated: true, completion: nil)
        }
    }
    
    public func openSubAllPlanVC(
        isFromTimeline: Bool,
        arrFeature: [FeatureModel],
        arrReview: [ReviewModel],
        subsciptionContinueBtnTextIndex: Int,
        customizationSubRatingData: UICustomizationSubRatingData?,
        enableRatingAutoScroll: Bool = true,
        isRatingScrollEnable: Bool = true,
        lifetimeDiscountVal: Int = 90,
        isOpenFrom: String,
        completionMorePlan: @escaping (SubCloseCompletionBlock, [String: String]?) -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            let subAllPlanVC = SubAllPlanVC()
            subAllPlanVC.isFromTimeline = isFromTimeline
            subAllPlanVC.arrFeature = arrFeature
            subAllPlanVC.arrReview = arrReview
            subAllPlanVC.subsciptionContinueBtnTextIndex = subsciptionContinueBtnTextIndex
            subAllPlanVC.customizationSubRatingData = customizationSubRatingData
            subAllPlanVC.enableRatingAutoScroll = enableRatingAutoScroll
            subAllPlanVC.isRatingScrollEnable = isRatingScrollEnable
            subAllPlanVC.lifetimeDiscountVal = lifetimeDiscountVal
            subAllPlanVC.isOpenFrom = isOpenFrom
            subAllPlanVC.completionMorePlan = { (result, param) in
                completionMorePlan(result, param)
            }
            subAllPlanVC.modalPresentationStyle = .fullScreen
            subAllPlanVC.modalTransitionStyle = .crossDissolve
            self.present(subAllPlanVC, animated: true, completion: nil)
        }
    }
    
    public func openSubDiscountVC(
        customizationSubDiscountTheme: UICustomizationSubDiscountTheme? = nil,
        isOpenFrom: String,
        completionDiscount: @escaping (SubCloseCompletionBlock, [String: String]?) -> Void
    ) {
        let vc = SubDiscountVC()
        vc.customizationSubDiscountTheme = customizationSubDiscountTheme ?? UICustomizationSubDiscountTheme()
        vc.isOpenFrom = isOpenFrom
        vc.completionDiscount = { (result, param) in
            completionDiscount(result, param)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    public func openThankYouVC(
        customizationSubThankYouTheme: UICustomizationSubThankYouTheme? = nil,
        customizationSubThankYouData: UICustomizationSubThankYouData? = nil,
        subCloseCompletionBlock: SubCloseCompletionBlock,
        param: [String: String]?
    ) {
        let thankYouVC = ThankYouVC()
        thankYouVC.customizationSubThankYouTheme = customizationSubThankYouTheme ?? UICustomizationSubThankYouTheme()
        thankYouVC.customizationSubThankYouData = customizationSubThankYouData ?? UICustomizationSubThankYouData()
        thankYouVC.subCloseCompletionBlock = subCloseCompletionBlock
        thankYouVC.param = param
        thankYouVC.modalPresentationStyle = .fullScreen
        thankYouVC.modalTransitionStyle = .crossDissolve
        self.present(thankYouVC, animated: true, completion: nil)
    }
}
