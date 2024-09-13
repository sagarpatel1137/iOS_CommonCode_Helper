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
import iOS_CommonCode_Helper

class SubTimelineVC: UIViewController {

    //MARK: -
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var selected_Plan : SubscriptionConst.PlanInfo!
    var completionTimeline: ((String)->())?
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddFirebaseEvent(eventName: EventsValues.SubMonthltyShowTimeLime)
        
        AddNotification()
        
        setUpUI()
        setUpText()
        setUpFont()
        setUpAnimation()
        setUpGestures()
        
        setPlanDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewJson.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Set Up
    private func setUpUI() {
        
        viewShield.layer.cornerRadius = viewShield.bounds.height/2
        viewLock.layer.cornerRadius = viewLock.bounds.height/2
        viewProgress.layer.cornerRadius = viewProgress.bounds.width/2
        
        btnMorePlans.titleLabel?.adjustsFontSizeToFitWidth = true
        btnMorePlans.titleLabel?.minimumScaleFactor = 0.5
        btnPrivacyPolicy.titleLabel?.numberOfLines = 0
        btnTermsOfUse.titleLabel?.numberOfLines = 0
        
        btnMorePlans.isHidden = false
        lblFreeTrialText.text = nil
    }
    
    private func setUpText() {
        
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
        lblStack_Day5.text = "Day 2: Trial Reminder".localized()
        lblStack_Day7.text = "Day 3: Premium Begins".localized()
        lblStack_Now_Detail.text = "Unlock all the features.".localized()
        lblStack_Day5_Detail.text = "Get a reminder about when your free trial will end. Cancel anytime in 15 seconds.".localized()
        lblStack_Day7_Detail.text = "Your trial will convert to full price unless cancelled.".localized()
        lblStack_Feature1.text = "•  " + "Al Voices".localized()
        lblStack_Feature2.text = "•  " + "All Voice Effect".localized()
        lblStack_Feature5.text = "•  " + "iCloud Synchronization".localized()
        lblStack_Feature3.text = "•  " + "Share Voice Message".localized()
        lblStack_Feature4.text = "•  " + "Adjust Effects".localized()
    }
    
    private func setUpFont() {
        
        lblTitle.font = setCustomFont(name: Avenir_Black, iPhoneSize: 21, iPadSize: 31)
        lblSubTitle.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 21, iPadSize: 31)
        lblStack_Now.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Today.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Day5.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Day7.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 15, iPadSize: 23)
        lblStack_Now_Detail.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Day5_Detail.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Day7_Detail.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature1.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature2.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature3.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature4.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        lblStack_Feature5.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 19)
        
        lblFreeTrialText.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 20)
        lblCancelAnytime.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 10, iPadSize: 14)
        lblPayNothing.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 15, iPadSize: 22)
        
        lblStartTrial.font = setCustomFont(name: Avenir_Heavy, iPhoneSize: 15, iPadSize: 22)
        btnMorePlans.titleLabel?.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 16)
        btnTermsOfUse.titleLabel?.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 16)
        btnPrivacyPolicy.titleLabel?.font = setCustomFont(name: Avenir_Medium, iPhoneSize: 12, iPadSize: 16)
        
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
    
    private func setUpAnimation() {
        if UIDevice.current.isiPad {
            self.viewJson.animation = LottieAnimation.named("sub_timeline_ipad")
        } else {
            self.viewJson.animation = LottieAnimation.named("sub_timeline_iphone")
        }
        self.viewJson.loopMode = .loop
        self.viewJson.play()
    }
    
    //MARK: -
    @IBAction func btnCloseAction(_ sender: UIButton) {
        presentSubAlertSheet(on: self) { _ in
            self.dismiss(animated: true, completion: {
                self.completionTimeline?("close")
            })
        }
    }
    
    @IBAction func btnMorePlansAction(_ sender: Any) {
        let vc = SubAllPlanVC()
        vc.modalPresentationStyle = .fullScreen
        vc.isFromTimeline = true
        vc.completionMorePlan = { result in
            if result == "close" {
            }
            else if result == "success" {
                self.dismiss(animated: true, completion: {
                    self.completionTimeline!("success")
                })
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
        AddFirebaseEvent(eventName: EventsValues.SubMonthltyClickTimeLime)
        purchaseByRevenueKit()
    }
    
    @IBAction func btnTermasofUse(_ sender: UIButton) {
        let vc = webVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.titleStr = "Terms of Use"
        vc.urlStr = "https://vasundharaapps.com/voice-changer-male-to-female-ios/terms-of-use"
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnPrivacyPolicy(_ sender: UIButton) {
        let vc = webVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.titleStr = "Privacy Policy"
        vc.urlStr = "https://vasundharaapps.com/voice-changer-male-to-female-ios/privacy-policy"
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: -
extension SubTimelineVC
{
    func setPlanDetail()
    {
        selected_Plan = SubscriptionConst.ActivePlans.one_Month
        
        self.startPriceLoader()
        
        if SubscriptionConst.ActivePlans.one_Month.plan_Id != ""
        {
            let monthPlan = SubscriptionConst.ActivePlans.one_Month
            let freeTrialMonth = monthPlan.plan_Free_Trail
            let tempMonthlyPriceString = monthPlan.plan_Price_String
            
            if freeTrialMonth.isFreeTrail {
                self.lblFreeTrialText.text = "\(monthPlan.plan_Free_Trail.duration) \(monthPlan.plan_Free_Trail.unittype.localized()) \("free".localized()), \("then".localized()) \(tempMonthlyPriceString) \("per".localized()) \("month".localized())"
                
                if FirebaseRemote.shared.subShowConfig.subsciptionContinueBtnText == 1 {
                    self.lblStartTrial.text =  "Start My Free Trial".localized().uppercased() + " "
                }
                else if FirebaseRemote.shared.subShowConfig.subsciptionContinueBtnText == 2 {
                    self.lblStartTrial.text = "\("Try".localized()) \(monthPlan.plan_Free_Trail.duration) \(monthPlan.plan_Free_Trail.unittype.localized()) \("for".localized()) \(monthPlan.plan_Currancy_Code)0"
                }
            }
            else {
                self.lblFreeTrialText.text = "\(tempMonthlyPriceString)/\("Month".localized()), \("Cancel Anytime".localized())."
            }
        }
        self.stopPriceLoader()
    }
}

//MARK: - Purchase
extension SubTimelineVC
{
    func purchaseByRevenueKit(){
        self.view.startLoader()
        if let tempPlan = selected_Plan
        {
            RevenueCat_Manager.shared.purchaseProduct(ProductID: tempPlan.plan_Id) { [self] (state, info, error,isCancel) in
                self.funManagePurchaseResponse(state: state, info: info, error: error, isCancel: isCancel)
            }
        }
    }
    
    func funManagePurchaseResponse(state: Bool, info: CustomerInfo?, error: Error?, isCancel: Bool) {
        
        self.view.stopLoader()
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
            if Reachability.isConnectedToNetwork() {
                systemAlert(title: "Alert".localized(), message: "Purchase failed or something went wrong.".localized(), actionDestructive: "OK".localized())
            }
            else {
                systemAlert(title: "Alert".localized(), message: "Check your internet connection".localized(), actionDestructive: "OK".localized())
            }
        }
    }
    

    func restoreByRevenueKit() {
        
        self.view.startLoader()
        RevenueCat_Manager.shared.restoreProduct { (state, info, error) in
            self.view.stopLoader()
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
        
        AddFirebaseEvent(eventName: EventsValues.SubMonthltyMonthTrialTimeLime)
        scheduleFreeTrialNotification(noOfDays: 2)
        
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true, completion: {
            self.completionTimeline!("success")
        })
    }

    func restoreSucess()
    {
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true, completion: {
            self.completionTimeline!("success")
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
