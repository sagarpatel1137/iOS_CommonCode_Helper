//
//  SubTimelineVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 11/09/24.
//

import UIKit
import Lottie
import StoreKit
import RevenueCat
import MarqueeLabel

public enum ButtonBGType {
    case solidColor
    case gradientColor
    case image
    case animateJson
}

public enum ViewAllPlanType {
    case allPlan
    case morePlan
}

//MARK: Cusmization
public struct UICustomizationSubTimelineTheme {
    public var themeColor: UIColor?
    public var imgTimelineRight: UIImage?
    public var imgTimelineLock: UIImage?
    public var imgTimelineBell: UIImage?
    public var imgTimelineStar: UIImage?
    public var featureListTextColor: UIColor?
    public var featureInfoTextColor: UIColor?
    public var viewProgressColor: UIColor?
    public var viewLockColor: UIColor?
    public var lblCancelAnytimeColor: UIColor?
    public var imgShieldCancel: UIImage?
    public var lblTitleColor: UIColor?
    public var viewShieldColor: UIColor?
    public var viewMainColor: UIColor?
    public var lblUnderlineViewAllPlan: UIColor?
    public var viewLine: UIColor?
    public var isShowRestoreButton: Bool = false
    public var buttonBGType: ButtonBGType = .animateJson
    public var btnContinueSolidColor: UIColor?
    public var btnContinueFromColor: UIColor?
    public var btnContinueToColor: UIColor?
    public var btnContinueImageiPhone: UIImage?
    public var btnContinueImageiPad: UIImage?
    public var btnJsonFilenameiPhone: String?
    public var btnJsonFilenameiPad: String?
    public var btnRestoreTextColor: UIColor?
    
    public init(themeColor: UIColor? = nil, imgTimelineRight: UIImage? = nil, imgTimelineLock: UIImage? = nil, imgTimelineBell: UIImage? = nil, imgTimelineStar: UIImage? = nil, featureListTextColor: UIColor? = nil, featureInfoTextColor: UIColor? = nil, viewProgressColor: UIColor? = nil, viewLockColor: UIColor? = nil, lblCancelAnytimeColor: UIColor? = nil, imgShieldCancel: UIImage? = nil, lblTitleColor: UIColor? = nil, viewShieldColor: UIColor? = nil, viewMainColor: UIColor? = nil, lblUnderlineViewAllPlan: UIColor? = nil, viewLine: UIColor? = nil, isShowRestoreButton: Bool = false, buttonBGType: ButtonBGType = .animateJson, btnContinueSolidColor: UIColor? = nil, btnContinueFromColor: UIColor? = nil, btnContinueToColor: UIColor? = nil, btnContinueImageiPhone: UIImage? = nil, btnContinueImageiPad: UIImage? = nil, btnJsonFilenameiPhone: String? = nil, btnJsonFilenameiPad: String? = nil, btnRestoreTextColor: UIColor? = nil) {
        self.themeColor = themeColor ?? hexStringToUIColor(hex: "1B79FF")
        self.imgTimelineRight = imgTimelineRight ?? ImageHelper.image(named: "ic_timeline_right")
        self.imgTimelineLock = imgTimelineLock ?? ImageHelper.image(named: "ic_timeline_lock")
        self.imgTimelineBell = imgTimelineBell ?? ImageHelper.image(named: "ic_timeline_bell")
        self.imgTimelineStar = imgTimelineStar ?? ImageHelper.image(named: "ic_timeline_star")
        self.featureListTextColor = featureListTextColor ?? hexStringToUIColor(hex: "1E2128")
        self.featureInfoTextColor = featureInfoTextColor ?? hexStringToUIColor(hex: "6C7379")
        self.viewProgressColor = viewProgressColor ?? hexStringToUIColor(hex: "0075FF")
        self.viewLockColor = viewLockColor ?? hexStringToUIColor(hex: "0075FF", alpha: 0.13)
        self.lblCancelAnytimeColor = lblCancelAnytimeColor ?? hexStringToUIColor(hex: "424242")
        self.imgShieldCancel = imgShieldCancel ?? ImageHelper.image(named: "ic_shield")
        self.lblTitleColor = lblTitleColor ?? hexStringToUIColor(hex: "1B79FF")
        self.viewShieldColor = viewShieldColor ?? hexStringToUIColor(hex: "F1F5F4")
        self.viewMainColor = viewMainColor ?? .systemBackground
        self.lblUnderlineViewAllPlan = lblUnderlineViewAllPlan ?? hexStringToUIColor(hex: "6C7379")
        self.viewLine = viewLine ?? hexStringToUIColor(hex: "EBF1EF")
        self.isShowRestoreButton = isShowRestoreButton
        self.buttonBGType = buttonBGType
        self.btnContinueSolidColor = btnContinueSolidColor ?? .clear
        self.btnContinueFromColor = btnContinueFromColor ?? .clear
        self.btnContinueToColor = btnContinueToColor ?? .clear
        self.btnContinueImageiPhone = btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_timeline_iphone")
        self.btnContinueImageiPad = btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_timeline_ipad")
        self.btnJsonFilenameiPhone = btnJsonFilenameiPhone ?? "lottie_subscription_continue_bg"
        self.btnJsonFilenameiPad = btnJsonFilenameiPad ?? "lottie_subscription_continue_bg"
        self.btnRestoreTextColor = btnRestoreTextColor ?? .white
    }
}

public class SubTimelineVC: UIViewController {
    
    //MARK: -
    @IBOutlet weak var imgTimelineRight: UIImageView!
    @IBOutlet weak var imgTimelineLock: UIImageView!
    @IBOutlet weak var imfTimelineBell: UIImageView!
    @IBOutlet weak var imgTimelineStar: UIImageView!
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var lblSubTitle: MarqueeLabel!
    
    @IBOutlet weak var lblStack_Now: MarqueeLabel!
    @IBOutlet weak var lblStack_Today: MarqueeLabel!
    @IBOutlet weak var lblStack_Day5: MarqueeLabel!
    @IBOutlet weak var lblStack_Day7: MarqueeLabel!
    @IBOutlet weak var lblStack_Now_Detail: UILabel!
    @IBOutlet weak var lblStack_Day5_Detail: UILabel!
    @IBOutlet weak var lblStack_Day7_Detail: UILabel!
    @IBOutlet weak var lblStack_Feature1: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature2: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature3: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature4: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature5: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature6: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature7: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature8: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature9: MarqueeLabel!
    @IBOutlet weak var lblStack_Feature10: MarqueeLabel!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var viewLock: UIView!
    
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var viewJson: LottieAnimationView!
    @IBOutlet var btnStrtTrial: UIButton!
    @IBOutlet weak var lblStartTrial: UILabel!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var btnMorePlans: UIButton!
    @IBOutlet var btnTermsOfUse: UIButton!
    @IBOutlet var btnPrivacyPolicy: UIButton!
    
    @IBOutlet weak var viewShield: UIView!
    @IBOutlet weak var lblPayNothing: UILabel!
    @IBOutlet weak var lblCancelAnytime: MarqueeLabel!
    @IBOutlet weak var lblFreeTrialText: UILabel!
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var viewMain_Bottom: NSLayoutConstraint!
    @IBOutlet weak var imgShieldCancel: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblUnderlineViewAllPlan: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var imgContinue: UIImageView!
    
    private var selected_Plan : SubscriptionConst.PlanInfo!
    var completionTimeline: ((SubCloseCompletionBlock, [String: String]?)->())?
    
    //MARK: Cusmization properties
    public var featureList: [String] = []
    public var arrFeature: [FeatureModel] = []
    public var arrReview: [ReviewModel] = []
    public var subsciptionContinueBtnTextIndex = 0
    public var viewAllPlanType: ViewAllPlanType? = .morePlan
    public var customizationSubTimelineTheme = UICustomizationSubTimelineTheme()
    public var customizationSubRatingData: UICustomizationSubRatingData?
    public var customizationSubMorePlan: UICustomizationSubMorePlan?
    public var customizationWebViewData: UICustomizationWebView?
    public var customizationAllPlan: UICustomizationAllPlan?
    public var enableRatingAutoScroll = false
    public var isRatingScrollEnable = true
    public var lifetimeDiscountVal = 80
    public var isOpenFrom = ""
    public var isPresentSubAlertSheet = true
    public var modalTransitionStyleForWebVC: UIModalTransitionStyle = .crossDissolve
    public var selectedPlanIndex = 1
    
    /*
    enum PlansType: Int {
        case week = 3
        case month = 1
        case year = 2
        case lifetime = 0
    }
     */
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: -
    public override func viewDidLoad() {
        super.viewDidLoad()
        if selectedPlanIndex == 2 {
            selected_Plan = SubscriptionConst.ActivePlans.one_Year
            AddFirebaseEvent(eventName: .SubYearlyTimeLimeShow, parameters: ["from": self.isOpenFrom])
        } else if selectedPlanIndex == 3 {
            selected_Plan = SubscriptionConst.ActivePlans.one_Week
            AddFirebaseEvent(eventName: .SubWeeklyTimeLimeShow, parameters: ["from": self.isOpenFrom])
        } else {
            selected_Plan = SubscriptionConst.ActivePlans.one_Month
            AddFirebaseEvent(eventName: .SubMonthltyTimeLimeShow, parameters: ["from": self.isOpenFrom])
        }
        
        AddNotification()
        
        setUpUI()
        setUpText()
        setUpFont()
        setUpGestures()
        
        setPlanDetail()
        updateUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.viewJson.play()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewContinue.layer.cornerRadius = self.viewContinue.bounds.height/2
        self.viewContinue.clipsToBounds = true
        self.viewShield.layer.cornerRadius = self.viewShield.bounds.height/2
        self.viewLock.layer.cornerRadius = self.viewLock.bounds.height/2
        self.viewProgress.layer.cornerRadius = self.viewProgress.bounds.width/2
        self.btnMorePlans.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Set Up
    private func setUpUI() {
        btnMorePlans.titleLabel?.adjustsFontSizeToFitWidth = true
        btnMorePlans.titleLabel?.minimumScaleFactor = 0.5
        btnPrivacyPolicy.titleLabel?.numberOfLines = 0
        btnTermsOfUse.titleLabel?.numberOfLines = 0
        
        btnMorePlans.isHidden = false
        lblFreeTrialText.text = nil
        btnClose.setImage(ImageHelper.image(named: "ic_sub_close")!, for: .normal)
    }
    
    private func setUpText() {
        btnRestore.setTitle("Restore Purchase".localized(), for: .normal)
        lblStartTrial.text = "Continue".localized().uppercased()
        lblTitle.text = "HAVE DOUBTS?".localized()
        lblSubTitle.text = "Start with a free trial".localized()
        
        btnMorePlans.setTitle("View All Plans".localized(), for: .normal)
        btnPrivacyPolicy.setTitle("Privacy Policy".localized(), for: .normal)
        btnTermsOfUse.setTitle("Terms of Use".localized(), for: .normal)
        
        lblCancelAnytime.text = "Cancel anytime. Secure with App Store".localized()
        lblPayNothing.text = "Pay Nothing Now".localized()
        lblStartTrial.adjustsFontSizeToFitWidth = true
        lblStartTrial.minimumScaleFactor = UIDevice.current.isiPhone ? 0.5 : 0.7
        
        lblStack_Now.text = "NOW".localized()
        lblStack_Today.text = "Today: Get Instant Access".localized()
        if selected_Plan.plan_Free_Trail.duration == 3 {
            lblStack_Day5.text = "Day 2: Trial Reminder".localized()
            lblStack_Day7.text = "Day 3: Premium Begins".localized()
        } else {
            lblStack_Day5.text = "Day 5: Trial Reminder".localized()
            lblStack_Day7.text = "Day 7: Premium Begins".localized()
        }
        lblStack_Now_Detail.text = "Unlock all the features.".localized()
        lblStack_Day5_Detail.text = "Get a reminder about when your free trial will end. Cancel anytime in 15 seconds.".localized()
        lblStack_Day7_Detail.text = "Your trial will convert to full price unless cancelled.".localized()
        lblStack_Feature1.text = "•  " + "Al Voices".localized()
        lblStack_Feature2.text = "•  " + "All Voice Effect".localized()
        lblStack_Feature3.text = "•  " + "Share Voice Message".localized()
        lblStack_Feature4.text = "•  " + "Adjust Effects".localized()
        lblStack_Feature5.text = "•  " + "iCloud Synchronization".localized()
        lblStack_Feature6.text = "•  " + "iCloud Synchronization".localized()
        lblStack_Feature7.text = "•  " + "iCloud Synchronization".localized()
        lblStack_Feature8.text = "•  " + "iCloud Synchronization".localized()
        lblStack_Feature9.text = "•  " + "iCloud Synchronization".localized()
        lblStack_Feature10.text = "•  " + "iCloud Synchronization".localized()
    }
    
    private func setUpFont() {

        lblTitle.font = setCustomFont(name: .Avenir_Black, iPhoneSize: 21, iPadSize: 31)
        lblSubTitle.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 21, iPadSize: 31)
        lblStack_Now.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Today.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Day5.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Day7.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        btnRestore.titleLabel?.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Now_Detail.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Day5_Detail.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Day7_Detail.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature1.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature2.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature3.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature4.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature5.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature6.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature7.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature8.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature9.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature10.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        
        lblFreeTrialText.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 20)
        lblCancelAnytime.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 10, iPadSize: 14)
        lblPayNothing.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 15, iPadSize: 22)
        
        lblStartTrial.font = setCustomFont(name: .Avenir_Heavy, iPhoneSize: 15, iPadSize: 22)
        btnMorePlans.titleLabel?.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 16)
        btnTermsOfUse.titleLabel?.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 16)
        btnPrivacyPolicy.titleLabel?.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 16)
        
        if Locale.current.languageCode == "ur" {
            lblFreeTrialText.font = UIFont(name: lblFreeTrialText.font.fontName, size: lblFreeTrialText.font.pointSize-2)
            lblCancelAnytime.font = UIFont(name: lblCancelAnytime.font.fontName, size: lblCancelAnytime.font.pointSize-2)
            lblStartTrial.font = UIFont(name: lblStartTrial.font.fontName, size: lblStartTrial.font.pointSize-2)
            btnMorePlans.titleLabel?.font = UIFont(name: btnMorePlans.titleLabel!.font.fontName, size: btnMorePlans.titleLabel!.font.pointSize-2)
            btnTermsOfUse.titleLabel?.font = UIFont(name: btnTermsOfUse.titleLabel!.font.fontName, size: btnTermsOfUse.titleLabel!.font.pointSize-2)
            btnPrivacyPolicy.titleLabel?.font = UIFont(name: btnPrivacyPolicy.titleLabel!.font.fontName, size: btnPrivacyPolicy.titleLabel!.font.pointSize-2)
        }
    }
    
    private func setUpGestures() {
        lblPayNothing.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnCloseAction))
        lblPayNothing?.addGestureRecognizer(tapGesture)
    }
    
    private func openSubAllPlanVC() {
        
        self.openSubAllPlanVC(isFromTimeline: true,
                              arrFeature: self.arrFeature,
                              arrReview: self.arrReview,
                              subsciptionContinueBtnTextIndex: subsciptionContinueBtnTextIndex,
                              customizationAllPlan: customizationAllPlan,
                              customizationSubRatingData: customizationSubRatingData,
                              customizationWebViewData: customizationWebViewData,
                              enableRatingAutoScroll: enableRatingAutoScroll,
                              isRatingScrollEnable: isRatingScrollEnable,
                              isPresentSubAlertSheet: isPresentSubAlertSheet,
                              lifetimeDiscountVal: lifetimeDiscountVal,
                              isOpenFrom: isOpenFrom) { (result, param) in
            if result == .purchaseSuccess || result == .restoreSuccess || result == .trialSuccess {
                self.dismiss(animated: true, completion: {
                    self.completionTimeline!(result, param)
                })
            }
        }
    }
    
    private func openSubMorePlanVC() {
        self.openSubMorePlanVC(isFromTimeline: true,
                               arrReview: self.arrReview,
                               subsciptionContinueBtnTextIndex: subsciptionContinueBtnTextIndex,
                               isPresentSubAlertSheet: isPresentSubAlertSheet,
                               customizationSubMorePlan: customizationSubMorePlan,
                               customizationSubRatingData: customizationSubRatingData,
                               customizationWebViewData: customizationWebViewData,
                               isOpenFrom: isOpenFrom) { (result, param) in
            if result == .purchaseSuccess || result == .restoreSuccess || result == .trialSuccess {
                self.dismiss(animated: true, completion: {
                    self.completionTimeline!(result, param)
                })
            }
        }
    }
    
    //MARK: -
    @IBAction func btnRestoreAction(_ sender: UIButton) {
        restoreByRevenueKit()
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        if isPresentSubAlertSheet {
            presentSubAlertSheet(on: self) { _ in
                self.dismiss(animated: true, completion: {
                    self.completionTimeline?(.close, [:])
                })
            }
        } else {
            self.dismiss(animated: true, completion: {
                self.completionTimeline?(.close, [:])
            })
        }
    }
    
    @IBAction func btnMorePlansAction(_ sender: Any) {
        if let viewAllPlanType = self.viewAllPlanType {
            if viewAllPlanType == .allPlan {
                self.openSubAllPlanVC()
            } else if viewAllPlanType == .morePlan {
                self.openSubMorePlanVC()
            }
        } else {
            self.openSubAllPlanVC()
        }
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
        let param = [
            "from": self.isOpenFrom,
            "sku" : self.selected_Plan.plan_Id,
            "type" : self.selected_Plan.plan_Type.rawValue
        ]
    
        if selectedPlanIndex == 2 {
            AddFirebaseEvent(eventName: .SubYearlyTimeLimeClick, parameters: param)
        } else if selectedPlanIndex == 3 {
            AddFirebaseEvent(eventName: .SubWeeklyTimeLimeClick, parameters: param)
        } else {
            AddFirebaseEvent(eventName: .SubMonthltyTimeLimeClick, parameters: param)
        }
        
        purchaseByRevenueKit()
    }
    
    @IBAction func btnTermasofUse(_ sender: UIButton) {
        self.openWebVC(titleStr:"Terms of Use".localized(), urlStr: Pod_AppTermsAnsConditionURL, customization: self.customizationWebViewData, modalTransitionStyle: self.modalTransitionStyleForWebVC)
    }
    
    @IBAction func btnPrivacyPolicy(_ sender: UIButton) {
        self.openWebVC(titleStr: "Privacy Policy".localized(), urlStr: Pod_AppPrivacyPolicyURL, customization: self.customizationWebViewData, modalTransitionStyle: self.modalTransitionStyleForWebVC)
    }
}

//MARK: -
extension SubTimelineVC
{
    func setPlanDetail()
    {
        self.startPriceLoader()
        
        if let plan = selected_Plan, selected_Plan.plan_Id != ""
        {
            let freeTrial = plan.plan_Free_Trail
            let tempPriceString = plan.plan_Price_String
            
            if freeTrial.isFreeTrail {
                if selectedPlanIndex == 2 {
                    self.lblFreeTrialText.text = "\(plan.plan_Free_Trail.duration) \(plan.plan_Free_Trail.unittype.localized()) \("free".localized()), \("then".localized()) \(tempPriceString) \("per".localized()) \("year".localized())"
                } else if selectedPlanIndex == 3 {
                    self.lblFreeTrialText.text = "\(plan.plan_Free_Trail.duration) \(plan.plan_Free_Trail.unittype.localized()) \("free".localized()), \("then".localized()) \(tempPriceString) \("per".localized()) \("week".localized())"
                } else {
                    self.lblFreeTrialText.text = "\(plan.plan_Free_Trail.duration) \(plan.plan_Free_Trail.unittype.localized()) \("free".localized()), \("then".localized()) \(tempPriceString) \("per".localized()) \("month".localized())"
                }
                if subsciptionContinueBtnTextIndex == 1 {
                    self.lblStartTrial.text =  "Start My Free Trial".localized().uppercased() + " "
                }
                else if subsciptionContinueBtnTextIndex == 2 {
                    self.lblStartTrial.text = "\("Try".localized()) \(plan.plan_Free_Trail.duration) \(plan.plan_Free_Trail.unittype.localized()) \("for".localized()) \(plan.plan_Currancy_Code)0"
                }
            }
            else {
                if selectedPlanIndex == 2 {
                    self.lblFreeTrialText.text = "\(tempPriceString)/\("Year".localized()), \("Cancel Anytime".localized())."
                } else if selectedPlanIndex == 3 {
                    self.lblFreeTrialText.text = "\(tempPriceString)/\("Week".localized()), \("Cancel Anytime".localized())."
                } else {
                    self.lblFreeTrialText.text = "\(tempPriceString)/\("Month".localized()), \("Cancel Anytime".localized())."
                }
            }
        }
        self.stopPriceLoader()
    }
}

//MARK: - Purchase
extension SubTimelineVC
{
    func purchaseByRevenueKit(){
        self.Pod_startLoader()
        if let tempPlan = selected_Plan
        {
            RevenueCat_Manager.shared.purchaseProduct(ProductID: tempPlan.plan_Id) { [self] (state, info, error,isCancel) in
                self.funManagePurchaseResponse(state: state, info: info, error: error, isCancel: isCancel)
            }
        }
    }
    
    func funManagePurchaseResponse(state: Bool, info: CustomerInfo?, error: Error?, isCancel: Bool) {
        
        self.Pod_stopLoader()
        if state {
            if !isCancel {
                if let error = error  {
                    systemAlert(title: "Sorry can't connect iTunes Store".localized(), message: "\(error.localizedDescription)", actionDestructive: "OK".localized())
                    return
                }
                if let _ = info {
                    self.purchaseSuccess()
                }
            }
        }
        else {
            if Reachability_Manager.isConnectedToNetwork() {
                systemAlert(title: "Alert".localized(), message: "Purchase failed or something went wrong.".localized(), actionDestructive: "OK".localized())
            }
            else {
                systemAlert(title: "Alert".localized(), message: "Check your internet connection".localized(), actionDestructive: "OK".localized())
            }
        }
    }
    
    
    func restoreByRevenueKit() {
        
        self.Pod_startLoader()
        RevenueCat_Manager.shared.restoreProduct { (state, info, error) in
            self.Pod_stopLoader()
            if error != nil {
                self.systemAlert(title: "Error".localized(), message: "Something went wrong, Please try again.".localized(), actionDestructive: "OK".localized())
                return
            }
            else {
                if let activepurchases = info?.entitlements.active {
                    if activepurchases.count == 0 {
                        self.systemAlert(title: "Alert".localized(), message: "Restore failed Or Nothing to Restore First Purchase.".localized(), actionDestructive: "OK".localized())
                    }
                    else{
                        self.restoreSucess()
                    }
                }
                
            }
        }
    }
    
    private func purchaseSuccess()
    {
        TikTok_Events.tikTokPurchaseSuccessEvent(plan: selected_Plan)
        Facebook_Events.addEventforSubscription(plan: selected_Plan)
        let param = [
            "from": self.isOpenFrom,
            "sku" : self.selected_Plan.plan_Id,
            "type" : self.selected_Plan.plan_Type.rawValue
        ]
        
        if selectedPlanIndex == 2 {
            AddFirebaseEvent(eventName: .SubWeeklyWeekTimeLimeTrial, parameters: param)
        } else if selectedPlanIndex == 3 {
            AddFirebaseEvent(eventName: .SubYearlyYearTimeLimeTrial, parameters: param)
        } else {
            AddFirebaseEvent(eventName: .SubMonthltyMonthTimeLimeTrial, parameters: param)
        }
        
        scheduleFreeTrialNotification(noOfDays: selected_Plan.plan_Free_Trail.duration)
        
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true, completion: {
            self.completionTimeline!(.trialSuccess, param)
        })
    }
    
    func restoreSucess()
    {
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true, completion: {
            self.completionTimeline!(.restoreSuccess, [:])
        })
    }
}

//MARK: -
extension SubTimelineVC
{
    private func startPriceLoader(){
        DispatchQueue.main.async {
            self.viewLoader.isHidden = false
            self.viewLoader.startAnimating()
        }
    }
    
    private func stopPriceLoader(){
        DispatchQueue.main.async {
            self.viewLoader.isHidden = true
            self.viewLoader.stopAnimating()
        }
    }
}

//MARK: -
extension SubTimelineVC
{
    private func AddNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationWillResignActive(_ notification: NSNotification) {
        self.viewJson.pause()
    }
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.viewJson.play()
    }
}

//MARK: -
extension SubTimelineVC {
    private func updateUI() {
        imgContinue.isHidden = true
        viewJson.isHidden = true
        switch customizationSubTimelineTheme.buttonBGType {
        case .solidColor:
            self.btnStrtTrial.backgroundColor = customizationSubTimelineTheme.btnContinueSolidColor ?? .clear
        case .gradientColor:
            let from = self.customizationSubTimelineTheme.btnContinueFromColor ?? .clear
            let to = self.customizationSubTimelineTheme.btnContinueToColor ?? .clear
            self.btnStrtTrial.addGradient(colors: [from, to], cornerRadius: 20.0)
        case .image:
            imgContinue.isHidden = false
            if UIDevice.current.isiPhone {
                self.imgContinue.image = self.customizationSubTimelineTheme.btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_timeline_iphone")
            } else {
                self.imgContinue.image = self.customizationSubTimelineTheme.btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_timeline_ipad")
            }
        case .animateJson:
            imgContinue.isHidden = false
            viewJson.isHidden = false
            if UIDevice.current.isiPhone {
                self.imgContinue.image = self.customizationSubTimelineTheme.btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_timeline_iphone")
            } else {
                self.imgContinue.image = self.customizationSubTimelineTheme.btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_timeline_ipad")
            }
            if let btnJsonFilenameiPad = customizationSubTimelineTheme.btnJsonFilenameiPad,
               let btnJsonFilenameiPhone = customizationSubTimelineTheme.btnJsonFilenameiPhone {
                if UIDevice.current.isiPad {
                    if let loadJSONURL = PodBundleHelper.loadJSONFile(named: btnJsonFilenameiPad) {
                        viewJson.animation = LottieAnimation.filepath(loadJSONURL.path)
                        viewJson.contentMode = .scaleAspectFill
                        viewJson?.loopMode = .loop
                        viewJson.play()
                    }
                } else {
                    if let loadJSONURL = PodBundleHelper.loadJSONFile(named: btnJsonFilenameiPhone) {
                        viewJson.animation = LottieAnimation.filepath(loadJSONURL.path)
                        viewJson?.loopMode = .loop
                        viewJson.contentMode = .scaleAspectFill
                        viewJson.play()
                    }
                }
            }
        }
        
        if let featureInfoTextColor = customizationSubTimelineTheme.featureInfoTextColor {
            lblStack_Now_Detail.textColor = featureInfoTextColor
            lblStack_Day5_Detail.textColor = featureInfoTextColor
            lblStack_Day7_Detail.textColor = featureInfoTextColor
            btnMorePlans.setTitleColor(featureInfoTextColor, for: .normal)
            btnTermsOfUse.setTitleColor(featureInfoTextColor, for: .normal)
            btnPrivacyPolicy.setTitleColor(featureInfoTextColor, for: .normal)
        }
        
        if let themeColor = customizationSubTimelineTheme.themeColor {
            self.lblSubTitle.textColor = themeColor
            self.lblStack_Now.textColor = themeColor
            self.lblStack_Today.textColor = themeColor
            self.lblStack_Day5.textColor = themeColor
            self.lblStack_Day7.textColor = themeColor
            self.lblFreeTrialText.textColor = themeColor
            self.lblPayNothing.textColor = themeColor
        }
        
        if let viewProgressColor = customizationSubTimelineTheme.viewProgressColor {
            self.viewProgress.backgroundColor = viewProgressColor
        }
        
        if let viewLockColor = customizationSubTimelineTheme.viewLockColor {
            self.viewLock.backgroundColor = viewLockColor
        }
        
        if let lblCancelAnytimeColor = customizationSubTimelineTheme.lblCancelAnytimeColor {
            self.lblCancelAnytime.textColor = lblCancelAnytimeColor
        }
        
        if let imgShieldCancel = customizationSubTimelineTheme.imgShieldCancel {
            self.imgShieldCancel.image = imgShieldCancel
        }
        
        if let lblTitleColor = customizationSubTimelineTheme.lblTitleColor {
            self.lblTitle.textColor = lblTitleColor
        }
        
        if let viewShieldColor = customizationSubTimelineTheme.viewShieldColor {
            self.viewShield.backgroundColor = viewShieldColor
        }
        
        if let viewShieldColor = customizationSubTimelineTheme.viewMainColor {
            self.view.backgroundColor = viewShieldColor
            self.viewBottom.backgroundColor = viewShieldColor
        }
        
        self.btnRestore.isHidden = !customizationSubTimelineTheme.isShowRestoreButton
        self.btnRestore.setTitleColor(customizationSubTimelineTheme.btnRestoreTextColor ?? .white, for: .normal)
        
        if let lblUnderlineViewAllPlan = customizationSubTimelineTheme.lblUnderlineViewAllPlan {
            self.lblUnderlineViewAllPlan.backgroundColor = lblUnderlineViewAllPlan
        }
        
        if let viewLine = customizationSubTimelineTheme.viewLine {
            self.viewLine.backgroundColor = viewLine
        }
        
        if let imgTimelineRight = customizationSubTimelineTheme.imgTimelineRight {
            self.imgTimelineRight.image = imgTimelineRight
        }
        
        if let imgTimelineLock = customizationSubTimelineTheme.imgTimelineLock {
            self.imgTimelineLock.image = imgTimelineLock
        }
        
        if let imgTimelineBell = customizationSubTimelineTheme.imgTimelineBell {
            self.imfTimelineBell.image = imgTimelineBell
        }
        
        if let imgTimelineStar = customizationSubTimelineTheme.imgTimelineStar {
            self.imgTimelineStar.image = imgTimelineStar
        }
        
        let arrLabel = [
            lblStack_Feature1,
            lblStack_Feature2,
            lblStack_Feature3,
            lblStack_Feature4,
            lblStack_Feature5,
            lblStack_Feature6,
            lblStack_Feature7,
            lblStack_Feature8,
            lblStack_Feature9,
            lblStack_Feature10
        ]
        
        for (i, label) in arrLabel.enumerated() {
            
            label?.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
            
            if let featureListTextColor = customizationSubTimelineTheme.featureListTextColor {
                label?.textColor = featureListTextColor
            }
            
            if ((self.featureList.count != 0) && i <= ((self.featureList.count-1))) {
                label?.isHidden = false
                label?.text =  "•  " + featureList[i]
            } else {
                label?.isHidden = true
            }
        }
    }
}
