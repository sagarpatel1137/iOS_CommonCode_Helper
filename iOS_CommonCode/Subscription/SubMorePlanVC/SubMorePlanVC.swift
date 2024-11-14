//
//  SubMorePlanVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 21/10/24.
//

import UIKit
import AVFoundation
import MarqueeLabel
import Lottie
import MBProgressHUD
import RevenueCat
import StoreKit

//MARK: Cusmization
public struct UICustomizationSubMorePlan {
    public var arrImgListFeatures: [UIImage]
    public var arrImgListFeatures_BG: [UIImage]
    public var arrStrListFeatures: [String]
    public var sixBoxDynamicPlan: [Int]
    public var sixBoxDynamicPlanSelectedIndex: Int
    public var subsciptionContinueBtnText: Int
    
    public var buttonBGType: ButtonBGType = .animateJson
    public var btnContinueSolidColor: UIColor?
    public var btnContinueFromColor: UIColor?
    public var btnContinueToColor: UIColor?
    public var btnContinueImageiPhone: UIImage?
    public var btnContinueImageiPad: UIImage?
    public var btnJsonFilenameiPhone: String?
    public var btnJsonFilenameiPad: String?
    
    public init(arrImgListFeatures: [UIImage], arrImgListFeatures_BG: [UIImage], arrStrListFeatures: [String], sixBoxDynamicPlan: [Int], sixBoxDynamicPlanSelectedIndex: Int, subsciptionContinueBtnText: Int, buttonBGType: ButtonBGType = .animateJson, btnContinueSolidColor: UIColor? = nil, btnContinueFromColor: UIColor? = nil, btnContinueToColor: UIColor? = nil, btnContinueImageiPhone: UIImage? = nil, btnContinueImageiPad: UIImage? = nil, btnJsonFilenameiPhone: String? = nil, btnJsonFilenameiPad: String? = nil) {
        self.arrImgListFeatures = arrImgListFeatures
        self.arrImgListFeatures_BG = arrImgListFeatures_BG
        self.arrStrListFeatures = arrStrListFeatures
        self.sixBoxDynamicPlan = sixBoxDynamicPlan
        self.sixBoxDynamicPlanSelectedIndex = sixBoxDynamicPlanSelectedIndex
        self.subsciptionContinueBtnText = subsciptionContinueBtnText
        self.buttonBGType = buttonBGType
        self.btnContinueSolidColor = btnContinueSolidColor ?? .clear
        self.btnContinueFromColor = btnContinueFromColor ?? .clear
        self.btnContinueToColor = btnContinueToColor ?? .clear
        self.btnContinueImageiPhone = btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_all_iphone")
        self.btnContinueImageiPad = btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_all_ipad")
        self.btnJsonFilenameiPhone = btnJsonFilenameiPhone ?? "lottie_subscription_continue_bg"
        self.btnJsonFilenameiPad = btnJsonFilenameiPad ?? "lottie_subscription_continue_bg"
    }
}

enum PlansType: Int {
    case week = 3
    case month = 1
    case year = 2
    case lifetime = 0
}

struct PlanDetails {
    var planTemplate: String
    var planLblTitle: String
    var plan: SubscriptionConst.PlanInfo
    var type: PlansType
}

//MARK: -
public class SubMorePlanVC: UIViewController {
    
    static let identifier = "SubMorePlanVC"
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var lblFreeTrial: MarqueeLabel!
    @IBOutlet var imgListFeatures: [UIImageView]!
    @IBOutlet var lblListFeatures: [MarqueeLabel]!
    @IBOutlet var imgListFeatures_BG: [UIImageView]!
    @IBOutlet weak var collViewFeature: UICollectionView!
    @IBOutlet weak var viewAnimationContainer: UIView!
    @IBOutlet weak var viewSubscribe: UIView!
    @IBOutlet weak var viewJson: LottieAnimationView!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var lblSubscribe: MarqueeLabel!
    @IBOutlet weak var lblPayNothingNow: MarqueeLabel!
    @IBOutlet weak var lblSubRenew_Top: NSLayoutConstraint!
    @IBOutlet weak var lblSubRenew_Bottom: NSLayoutConstraint!
    @IBOutlet weak var heightLabel: NSLayoutConstraint!
    @IBOutlet weak var lblCancelAnytime: UILabel!
    
    //New Lifetime Constraint
    @IBOutlet weak var stackViewPlans: UIStackView!
    @IBOutlet var arrPlanBgView : [UIView]!
    @IBOutlet var arrPlanTemplateView: [UIView]!
    @IBOutlet var arrDetailView: [UIView]!
    @IBOutlet var arrPriceView: [UIView]!
    @IBOutlet var arrPlanViewTop: [NSLayoutConstraint]!
    @IBOutlet var arrPlanBadgeTop: [NSLayoutConstraint]!
    @IBOutlet var arrLblPlanTemplate : [MarqueeLabel]!
    @IBOutlet var arrPlanBadge : [UIImageView]!
    @IBOutlet var arrPlanLblTitle : [MarqueeLabel]!
    @IBOutlet var arrPlanLblDetail : [UILabel]!
    @IBOutlet var arrPlanMonthInfo : [MarqueeLabel]!
    @IBOutlet var arrPlanPrice : [MarqueeLabel]!
    @IBOutlet var arrPlanBtn: [UIButton]!
    @IBOutlet var lblPromotionalPeriod : MarqueeLabel!
    @IBOutlet weak var lblTerms: MarqueeLabel!
    @IBOutlet weak var lblRestore: MarqueeLabel!
    @IBOutlet weak var lblPrivacy: MarqueeLabel!
    @IBOutlet var imgHeight : [NSLayoutConstraint]!
    @IBOutlet var imgWidth : [NSLayoutConstraint]!
    @IBOutlet var lblTitleTopConst : [NSLayoutConstraint]!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var imgShield: UIImageView!
    @IBOutlet weak var imgContinue: UIImageView!
    
    private var selected_Plan : SubscriptionConst.PlanInfo!
    private var arrPlansList = [PlanDetails]()
    
    var isFromTimeline = false
    var completionMorePlan: ((SubCloseCompletionBlock, [String: String]?)->())?
    
    public var customizationSubMorePlan: UICustomizationSubMorePlan?
    public var customizationSubRatingData: UICustomizationSubRatingData?
    public var customizationWebViewData: UICustomizationWebView?
    public var isPresentSubAlertSheet = true
    public var isOpenFrom = ""

    //MARK: -
    var arrReview: [ReviewModel] = []
    private var isFromIntial = false
    
    enum errorMsg : String
    {
        case ok = "Ok"
        case alert = "Alert"
        case error = "Error"
        
        case somethingWrong = "Something went wrong!"
        case itunesNotConnect = "Sorry can't connect iTunes Store."
        case purchaseFail = "Purchase Failed Or Something went wrong."
        case nothingToRestore = "Restore failed Or Nothing to Restore."
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: -
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        AddFirebaseEvent(eventName: EventsValues.SubSixBoxShow, parameters: ["from": isOpenFrom])
        funAddNotification()
        setUpUI()
        DispatchQueue.main.async {
            self.setupScreenPlans()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //viewSubscribe.roundCorners()
        viewSubscribe.layer.cornerRadius = viewSubscribe.bounds.height/2
        self.setImagesforPlans()
    }
    
    private func setupScreenPlans() {
        
        let totalYearPrice = 12 * (SubscriptionConst.ActivePlans.one_Month.plan_Price)
        let tempActPrice = SubscriptionConst.ActivePlans.one_Year.plan_Price
        
        let perc = (tempActPrice * 100) / totalYearPrice
        let disPer = 100 - perc
        let stringPert = String(format: "%.f", disPer)
        
        let defaultPlans = [
            PlanDetails(
                planTemplate: "Best Value",
                planLblTitle: "Lifetime",
                plan: SubscriptionConst.ActivePlans.life_Time,
                type: .lifetime
            ),
            PlanDetails(
                planTemplate: "\("Save".localized().uppercased()) \(stringPert)%" + " ",
                planLblTitle: "Yearly",
                plan: SubscriptionConst.ActivePlans.one_Year,
                type: .year
            ),
            PlanDetails(
                planTemplate: "Most Popular",
                planLblTitle: "Monthly",
                plan: SubscriptionConst.ActivePlans.one_Month,
                type: .month
            ),
            PlanDetails(
                planTemplate: "Trending",
                planLblTitle: "Weekly",
                plan: SubscriptionConst.ActivePlans.one_Week,
                type: .week
            )
        ]
        
        arrPlansList.removeAll()
        
        if (self.customizationSubMorePlan?.sixBoxDynamicPlan.count ?? 0) > 0 && self.customizationSubMorePlan?.sixBoxDynamicPlan.count == 3 {
            self.arrPlansList = [
                defaultPlans[(self.customizationSubMorePlan?.sixBoxDynamicPlan[0])!],
                defaultPlans[(self.customizationSubMorePlan?.sixBoxDynamicPlan[1])!],
                defaultPlans[(self.customizationSubMorePlan?.sixBoxDynamicPlan[2])!]
            ]
        } else {
            self.arrPlansList = [
                defaultPlans[0],
                defaultPlans[1],
                defaultPlans[2]
            ]
        }
        
        for (i, plan) in arrPlansList.enumerated() {
            arrLblPlanTemplate[i].text = arrPlansList[i].planTemplate.localized().uppercased() + " "
            arrPlanLblTitle[i].text = arrPlansList[i].planLblTitle.localized()
            
            
            switch plan.type {
            case .week:
                self.setupWeeklyPlan(i)
            case .month:
                self.setupMonthlyPlan(i)
            case .year:
                self.setupYearlyPlan(i)
            case .lifetime:
                self.setupLifetimePlan(i)
            }
        }
        
        let sixBoxDynamicPlanSelectedIndex = self.customizationSubMorePlan?.sixBoxDynamicPlanSelectedIndex ?? 0
        selected_Plan = arrPlansList[sixBoxDynamicPlanSelectedIndex].plan
        setPlanDetails(sixBoxDynamicPlanSelectedIndex)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
            guard let self = self else { return }
            self.isFromIntial = true
            self.btnProductClicked(self.arrPlanBtn[sixBoxDynamicPlanSelectedIndex])
        }
    }
    
    func funAddNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func setUpUI() {
        imgShield.image = ImageHelper.image(named: "ic_shield")!
        imgClose.image = ImageHelper.image(named: "ic_sub_close")!
        lblPromotionalPeriod.text = ""
        lblPromotionalPeriod.isHidden = true
        lblFreeTrial.text = ""
        lblFreeTrial.isHidden = true
        
        lblPayNothingNow.isUserInteractionEnabled = true  // Enable user interaction
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblPayNothingNow.addGestureRecognizer(tapGesture)
        
        lblTitle.text = "Unlock All Features".localized()
        
        for (i, lbl) in lblListFeatures.enumerated() {
            lbl.text = self.customizationSubMorePlan?.arrStrListFeatures[i]
        }
        
        for (i, lbl) in lblListFeatures.enumerated() {
            lbl.text = self.customizationSubMorePlan?.arrStrListFeatures[i]
        }
        
        for (i, img) in imgListFeatures.enumerated() {
            img.image = self.customizationSubMorePlan?.arrImgListFeatures[i]
        }
        
        for (i, img) in imgListFeatures_BG.enumerated() {
            img.image = self.customizationSubMorePlan?.arrImgListFeatures_BG[i]
        }
        
        lblSubscribe.text = RevenueCat_Manager.shared.updateContinueButtonTitle(self.customizationSubMorePlan?.subsciptionContinueBtnText ?? 0)
        lblRestore.text = "Restore".localized() + " "
        lblTerms.text = "Terms of Use".localized() + " "
        lblPrivacy.text = "Privacy Policy".localized() + " "
        lblCancelAnytime.text = "Cancel anytime. Secure with App Store".localized()
        
        let fontRatio = UIDevice.current.isiPad ? UIScreen.main.bounds.width/768 : UIScreen.main.bounds.width/320

        
        lblTitle.font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 25, iPadSize: 45)
        lblFreeTrial.font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 18)
        lblListFeatures[0].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 11.5, iPadSize: 18)
        lblListFeatures[1].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 11.5, iPadSize: 18)
        lblListFeatures[2].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 11.5, iPadSize: 18)
        lblListFeatures[3].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 11.5, iPadSize: 18)
        lblListFeatures[4].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 11.5, iPadSize: 18)
        lblListFeatures[5].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 11.5, iPadSize: 18)
        lblPayNothingNow.font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 15*fontRatio, iPadSize: 22*fontRatio)
        lblSubscribe.font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 20, iPadSize: 32)
        lblPromotionalPeriod.font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 13, iPadSize: 19)
        lblRestore.font = setCustomFont_WithoutRatio(name: .WorkSans_Regular, iPhoneSize: 13, iPadSize: 17)
        lblTerms.font = setCustomFont_WithoutRatio(name: .WorkSans_Regular, iPhoneSize: 13, iPadSize: 17)
        lblPrivacy.font = setCustomFont_WithoutRatio(name: .WorkSans_Regular, iPhoneSize: 13, iPadSize: 17)
        lblCancelAnytime.font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Regular, iPhoneSize: 12, iPadSize: 21)
        
        imgContinue.isHidden = true
        viewJson.isHidden = true
        switch customizationSubMorePlan?.buttonBGType {
        case .solidColor:
            self.btnSubscribe.backgroundColor = customizationSubMorePlan?.btnContinueSolidColor ?? .clear
        case .gradientColor:
            let from = self.customizationSubMorePlan?.btnContinueFromColor ?? .clear
            let to = self.customizationSubMorePlan?.btnContinueToColor ?? .clear
            self.btnSubscribe.addGradient(colors: [from, to], isRounded: true)
        case .image:
            imgContinue.isHidden = false
            if UIDevice.current.isiPhone {
                self.imgContinue.image = self.customizationSubMorePlan?.btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_all_iphone")
            } else {
                self.imgContinue.image = self.customizationSubMorePlan?.btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_all_ipad")
            }
        case .animateJson, .none:
            imgContinue.isHidden = false
            viewJson.isHidden = false
            if UIDevice.current.isiPhone {
                self.imgContinue.image = self.customizationSubMorePlan?.btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_all_iphone")
            } else {
                self.imgContinue.image = self.customizationSubMorePlan?.btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_all_ipad")
            }
            if let btnJsonFilenameiPad = customizationSubMorePlan?.btnJsonFilenameiPad,
               let btnJsonFilenameiPhone = customizationSubMorePlan?.btnJsonFilenameiPhone {
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
        
        collViewFeature.delegate = self
        collViewFeature.dataSource = self
        collViewFeature.register(UINib(nibName: SubRatingCell.identifier, bundle: nil), forCellWithReuseIdentifier: SubRatingCell.identifier)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setImagesforPlans() {
        for (i, plan) in arrPlansList.enumerated() {
            
            if plan.type == .week {
                self.imgHeight[i].constant = arrDetailView[i].bounds.width * 0.22
                self.imgWidth[i].constant = ((self.imgHeight[i].constant) * (1))
                self.lblTitleTopConst[i].constant = arrDetailView[i].bounds.height * 0.067
            }
            else if plan.type == .month {
                self.imgHeight[i].constant = arrDetailView[i].bounds.width * 0.22
                self.imgWidth[i].constant = ((self.imgHeight[i].constant) * (1))
                self.lblTitleTopConst[i].constant = arrDetailView[i].bounds.height * 0.067
            }
            else if plan.type == .year {
                self.imgHeight[i].constant = arrDetailView[i].bounds.width * 0.22
                self.imgWidth[i].constant = ((self.imgHeight[i].constant) * (0.90))
                self.lblTitleTopConst[i].constant = arrDetailView[i].bounds.height * 0.032
            }
            else if plan.type == .lifetime {
                self.imgHeight[i].constant = arrDetailView[i].bounds.width * 0.14
                self.imgWidth[i].constant = (self.imgHeight[i].constant) * (2.39)
                self.lblTitleTopConst[i].constant = arrDetailView[i].bounds.height * 0.1125
            }
        }
    }
}

//MARK: -
extension SubMorePlanVC
{
    @objc func applicationWillResignActive(_ notification: NSNotification) {
        self.viewJson.pause()
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.viewJson.play()
    }
    
    @objc func labelTapped() {
        self.btnCloseAction(UIButton())
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        if isFromTimeline {
            self.dismiss(animated: true, completion: {
                self.completionMorePlan!(.close, [:])
            })
        } else {
            if isPresentSubAlertSheet {
                presentSubAlertSheet(on: self) { [self] _ in
                    self.dismiss(animated: true, completion: {
                        self.completionMorePlan!(.close, [:])
                    })
                }
            } else {
                self.dismiss(animated: true, completion: {
                    self.completionMorePlan!(.close, [:])
                })
            }
        }
    }
    
    @IBAction func btnProductClicked(_ sender: UIButton) {
        if selected_Plan.plan_Id == arrPlansList[sender.tag].plan.plan_Id && !isFromIntial {
            return
        }
        
        isFromIntial = false
        selected_Plan = arrPlansList[sender.tag].plan
        setPlanDetails(sender.tag)
        
        for i in 0..<stackViewPlans.arrangedSubviews.count {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0) {
                if i == sender.tag{
                    self.arrPlanViewTop[i].constant = 0
                }else{
                    self.arrPlanViewTop[i].constant = 20
                }
                self.view.layoutIfNeeded()
            }
        }
        
        for i in 0..<stackViewPlans.arrangedSubviews.count {
            
            if i == sender.tag {
                arrPlanBgView[i].isHidden = false
                arrPlanBadge[i].image = ImageHelper.image(named: "ic_sub_plan_\(arrPlansList[i].type.rawValue)_sel")
                arrPlanTemplateView[i].backgroundColor = .clear
                arrDetailView[i].backgroundColor = hexStringToUIColor(hex: "F6F6FF")
                arrPriceView[i].backgroundColor = hexStringToUIColor(hex: "F6F6FF")
                arrLblPlanTemplate[i].textColor = hexStringToUIColor(hex: "FFFFFF")
                arrPlanLblTitle[i].textColor = hexStringToUIColor(hex: "28353F")
                arrPlanLblDetail[i].textColor = hexStringToUIColor(hex: "28353F")
                
                arrLblPlanTemplate[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 12, iPadSize: 17)
                arrPlanLblTitle[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 17, iPadSize: 21)
                arrPlanPrice[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 18, iPadSize: 22)
            }
            else {
                arrPlanBgView[i].isHidden = true
                arrPlanBadge[i].image = ImageHelper.image(named: "ic_sub_plan_\(arrPlansList[i].type.rawValue)")
                arrPlanTemplateView[i].backgroundColor = hexStringToUIColor(hex: "F8F8F8")
                arrDetailView[i].backgroundColor = hexStringToUIColor(hex: "F8F8F8")
                arrPriceView[i].backgroundColor = hexStringToUIColor(hex: "F8F8F8")
                arrLblPlanTemplate[i].textColor = hexStringToUIColor(hex: "838485")
                arrPlanLblTitle[i].textColor = hexStringToUIColor(hex: "838485")
                arrPlanLblDetail[i].textColor = hexStringToUIColor(hex: "838485")
                
                arrLblPlanTemplate[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 11, iPadSize: 16)
                arrPlanLblTitle[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 16, iPadSize: 20)
                arrPlanPrice[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 18, iPadSize: 21)
            }
        }
        
        self.setImagesforPlans()
        
        for (i, plan) in arrPlansList.enumerated() {
            
            if plan.type == .week {
                let weekPlan = SubscriptionConst.ActivePlans.one_Week
                if weekPlan.plan_Free_Trail.isFreeTrail || weekPlan.plan_Promotional_Offer.isPromotionalOffer {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 6
                } else {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 8
                    if sender.tag == i {
                        arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 11 : 15
                    }
                }
            } else if plan.type == .month {
                let monthPlan = SubscriptionConst.ActivePlans.one_Month
                if monthPlan.plan_Free_Trail.isFreeTrail || monthPlan.plan_Promotional_Offer.isPromotionalOffer {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 6
                } else {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 8
                    if sender.tag == i {
                        arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 11 : 15
                    }
                }
            } else if plan.type == .year {
                let yearPlan = SubscriptionConst.ActivePlans.one_Year
                if yearPlan.plan_Free_Trail.isFreeTrail || yearPlan.plan_Promotional_Offer.isPromotionalOffer {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 6
                } else {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 8
                    if sender.tag == i {
                        arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 11 : 15
                    }
                }
            } else if plan.type == .lifetime {
                arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 3 : 8
                if sender.tag == i {
                    arrPlanBadgeTop[i].constant = UIDevice.current.isiPhone ? 11 : 15
                }
            }
            
            if plan.type == .year && sender.tag == i {
                arrPlanMonthInfo[i].textColor = hexStringToUIColor(hex: "343537")
                arrPlanMonthInfo[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 10, iPadSize: 12)
            } else {
                arrPlanMonthInfo[i].textColor = hexStringToUIColor(hex: "838485")
                arrPlanMonthInfo[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 9, iPadSize: 12)
            }
            
            if sender.tag == i && plan.type != .lifetime {
                arrPlanLblDetail[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
                
            } else if plan.type != .lifetime {
                arrPlanLblDetail[i].font = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
            }
        }
        
    }
    
    @IBAction func btnSubscribeClicked(_ sender: UIButton) {
        
        purchaseByRevenueKit()
        AddFirebaseEvent(eventName: EventsValues.SubSixBoxClick, parameters: [
            "from": self.isOpenFrom,
            "sku" : self.selected_Plan.plan_Id,
            "type" : self.selected_Plan.plan_Type.rawValue
        ])
    }
    
    @IBAction func btnRestoreAction(_ sender: Any) {
        restoreByRevenueKit()
    }
    
    @IBAction func btnPrivacyAction(_ sender: Any) {
        self.openWebVC(titleStr: "Privacy Policy".localized(), urlStr: Pod_AppPrivacyPolicyURL, customization: self.customizationWebViewData)
    }
    
    @IBAction func btnTermsAction(_ sender: Any) {
        self.openWebVC(titleStr:"Terms of Use".localized(), urlStr: Pod_AppTermsAnsConditionURL, customization: self.customizationWebViewData)
    }
}

//MARK: - Setup Plans
extension SubMorePlanVC {
    
    private func setupLifetimePlan(_ index: Int) {
        let lifeTimePlan = SubscriptionConst.ActivePlans.life_Time
        //Plan Price
        arrPlanMonthInfo[index].isHidden = true
        arrPlanPrice[index].text = lifeTimePlan.plan_Price_String + " "
        
        //Free Trial
        let font1: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 17)
        let font2: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
        
        let color1: UIColor = hexStringToUIColor(hex: "28353F")
        
        let strLifetime = "1 \("Purchase".localized())"
        arrPlanLblDetail[index].attributedText = strLifetime.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "1")
    }
    
    private func setupYearlyPlan(_ index: Int) {
        let yearPlan = SubscriptionConst.ActivePlans.one_Year
        let perMonth = String(format: "%.2f", SubscriptionConst.ActivePlans.one_Year.plan_Price/12)
        if SubscriptionConst.ActivePlans.one_Year.plan_Free_Trail.isFreeTrail {
            arrPlanMonthInfo[index].text = "\(SubscriptionConst.ActivePlans.one_Year.plan_Currancy_Code)\(perMonth)/\("Month".localized())" + " "
        }
        else if SubscriptionConst.ActivePlans.one_Year.plan_Promotional_Offer.isPromotionalOffer {
            arrPlanMonthInfo[index].isHidden = true
        }
        else {
            arrPlanMonthInfo[index].isHidden = true
            
            let font1: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 17)
            let font2: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
            let color1: UIColor = hexStringToUIColor(hex: "28353F")
            
            let str = "\(SubscriptionConst.ActivePlans.one_Year.plan_Currancy_Code)\(perMonth)/\("Month".localized())" + " "
            let str1 = "\(SubscriptionConst.ActivePlans.one_Year.plan_Currancy_Code)\(perMonth)"
            arrPlanLblDetail[index].attributedText = str.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: str1)
            arrPlanLblDetail[index].isHidden = false
        }
        
        //Plan Price
        arrPlanPrice[index].text = yearPlan.plan_Price_String + " "
        
        //Free Trial
        let font1: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 17)
        let font2: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
        let color1: UIColor = hexStringToUIColor(hex: "28353F")
        
        if yearPlan.plan_Free_Trail.isFreeTrail {
            let strYear = "\(yearPlan.plan_Free_Trail.duration) \(yearPlan.plan_Free_Trail.unittype.localized().capitalized) \("free".localized())" + " "
            arrPlanLblDetail[index].attributedText = strYear.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "\(yearPlan.plan_Free_Trail.duration)")
        } else if yearPlan.plan_Promotional_Offer.isPromotionalOffer {
            
            let yearPromoPrice = yearPlan.plan_Promotional_Offer.price_String
            
            if yearPlan.plan_Promotional_Offer.paymentMode == .payAsYouGo
            {
                let strYear = "\("upto".localized()) \(yearPlan.plan_Promotional_Offer.numberOfPeriods) \(yearPlan.plan_Promotional_Offer.subscriptionUnittype.localized())"
                arrPlanLblDetail[index].text = strYear
                arrPlanPrice[index].text = yearPromoPrice
            }
            else if yearPlan.plan_Promotional_Offer.paymentMode == .payUpFront
            {
                let strYear = "\("for".localized()) \(yearPlan.plan_Promotional_Offer.subscriptionDuration) \(yearPlan.plan_Promotional_Offer.subscriptionUnittype.localized())"
                arrPlanLblDetail[index].text = strYear
                arrPlanPrice[index].text = yearPromoPrice
            }
            else if yearPlan.plan_Promotional_Offer.paymentMode == .freeTrial
            {
                let strYear = "\(yearPlan.plan_Promotional_Offer.subscriptionDuration) \(yearPlan.plan_Promotional_Offer.subscriptionUnittype.localized().capitalized) \("free".localized())" + " "
                arrPlanLblDetail[index].attributedText = strYear.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "\(yearPlan.plan_Promotional_Offer.subscriptionDuration)")
            }
        }
    }
    
    private func setupMonthlyPlan(_ index: Int) {
        let monthPlan = SubscriptionConst.ActivePlans.one_Month
        //Plan Price
        arrPlanMonthInfo[index].isHidden = true
        arrPlanPrice[index].text = monthPlan.plan_Price_String + " "
        
        //Free Trial
        let font1: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 17)
        let font2: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
        
        let color1: UIColor = hexStringToUIColor(hex: "28353F")
        
        if monthPlan.plan_Free_Trail.isFreeTrail {
            let strMonth = "\(monthPlan.plan_Free_Trail.duration) \(monthPlan.plan_Free_Trail.unittype.localized().capitalized) \("free".localized())" + " "
            arrPlanLblDetail[index].attributedText = strMonth.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "\(monthPlan.plan_Free_Trail.duration)")
        } else if monthPlan.plan_Promotional_Offer.isPromotionalOffer {
            
            let monthPromoPrice = monthPlan.plan_Promotional_Offer.price_String
            if monthPlan.plan_Promotional_Offer.paymentMode == .payAsYouGo
            {
                let strMonth = "\("upto".localized()) \(monthPlan.plan_Promotional_Offer.numberOfPeriods) \(monthPlan.plan_Promotional_Offer.subscriptionUnittype.localized())"
                arrPlanLblDetail[index].text = strMonth
                arrPlanPrice[index].text = monthPromoPrice
            }
            else if monthPlan.plan_Promotional_Offer.paymentMode == .payUpFront
            {
                let strMonth = "\("for".localized()) \(monthPlan.plan_Promotional_Offer.subscriptionDuration) \(monthPlan.plan_Promotional_Offer.subscriptionUnittype.localized())"
                arrPlanLblDetail[index].text = strMonth
                arrPlanPrice[index].text = monthPromoPrice
            }
            else if monthPlan.plan_Promotional_Offer.paymentMode == .freeTrial
            {
                let strMonth = "\(monthPlan.plan_Promotional_Offer.subscriptionDuration) \(monthPlan.plan_Promotional_Offer.subscriptionUnittype.localized().capitalized) \("free".localized())" + " "
                arrPlanLblDetail[index].attributedText = strMonth.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "\(monthPlan.plan_Promotional_Offer.subscriptionDuration)")
            }
        } else {
            arrPlanLblDetail[index].isHidden = true
        }
    }
    
    private func setupWeeklyPlan(_ index: Int) {
        let weekPlan = SubscriptionConst.ActivePlans.one_Week
        
        //Plan Price
        arrPlanMonthInfo[index].isHidden = true
        arrPlanPrice[index].text = weekPlan.plan_Price_String + " "
        
        //Free Trial
        let font1: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 17)
        let font2: UIFont = setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 17)
        let color1: UIColor = hexStringToUIColor(hex: "28353F")
        
        if weekPlan.plan_Free_Trail.isFreeTrail {
            let strWeek = "\(weekPlan.plan_Free_Trail.duration) \(weekPlan.plan_Free_Trail.unittype.localized().capitalized) \("free".localized())" + " "
            arrPlanLblDetail[index].attributedText = strWeek.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "\(weekPlan.plan_Free_Trail.duration)")
        } else if weekPlan.plan_Promotional_Offer.isPromotionalOffer {
            
            let weekPromoPrice = weekPlan.plan_Promotional_Offer.price_String
            
            if weekPlan.plan_Promotional_Offer.paymentMode == .payAsYouGo
            {
                let strWeek = "\("upto".localized()) \(weekPlan.plan_Promotional_Offer.numberOfPeriods) \(weekPlan.plan_Promotional_Offer.subscriptionUnittype.localized())"
                arrPlanLblDetail[index].text = strWeek
                arrPlanPrice[index].text = weekPromoPrice
            }
            else if weekPlan.plan_Promotional_Offer.paymentMode == .payUpFront
            {
                let strWeek = "\("for".localized()) \(weekPlan.plan_Promotional_Offer.subscriptionDuration) \(weekPlan.plan_Promotional_Offer.subscriptionUnittype.localized())"
                arrPlanLblDetail[index].text = strWeek
                arrPlanPrice[index].text = weekPromoPrice
            }
            else if weekPlan.plan_Promotional_Offer.paymentMode == .freeTrial
            {
                let strWeek = "\(weekPlan.plan_Promotional_Offer.subscriptionDuration) \(weekPlan.plan_Promotional_Offer.subscriptionUnittype.localized().capitalized) \("free".localized())" + " "
                arrPlanLblDetail[index].attributedText = strWeek.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: "\(weekPlan.plan_Promotional_Offer.subscriptionDuration)")
            }
        } else {
            arrPlanLblDetail[index].isHidden = true
        }
    }
    
    private func setPlanDetails(_ selectedIndex: Int) {
        DispatchQueue.main.async { [self] in
            
            lblSubscribe.text = RevenueCat_Manager.shared.updateContinueButtonTitle(self.customizationSubMorePlan?.subsciptionContinueBtnText ?? 0)
            lblFreeTrial.text = "Subscription will auto-renew, Cancel anytime.".localized() + " "
            lblPayNothingNow.isHidden = true
            lblPayNothingNow.isHidden = true
            lblSubRenew_Top.constant = UIDevice.current.isiPad ? 18.0 : 14.0
            heightLabel.constant = 0.0
            lblSubRenew_Bottom.constant = 0.0
            
            let monthPlan = SubscriptionConst.ActivePlans.one_Month
            let yearPlan = SubscriptionConst.ActivePlans.one_Year
            let weekPlan = SubscriptionConst.ActivePlans.one_Week
            
            if ((monthPlan.plan_Promotional_Offer.isPromotionalOffer && !monthPlan.plan_Free_Trail.isFreeTrail) || (yearPlan.plan_Promotional_Offer.isPromotionalOffer && !yearPlan.plan_Free_Trail.isFreeTrail) || (weekPlan.plan_Promotional_Offer.isPromotionalOffer && !weekPlan.plan_Free_Trail.isFreeTrail))
            {
                lblFreeTrial.isHidden = false
            } else {
                lblFreeTrial.text = ""
                lblFreeTrial.isHidden = true
            }
            
            let selectPlanPrice = selected_Plan.plan_Price_String
            
            if selected_Plan.plan_Free_Trail.isFreeTrail {
                lblPayNothingNow.text = "Pay Nothing Now".localized()
                lblPayNothingNow.isHidden = false
                lblSubRenew_Top.constant = UIDevice.current.isiPad ? 18.0 : 14.0
                lblSubRenew_Bottom.constant = UIDevice.current.isiPad ? 18.0 : 14.0
                heightLabel.constant = UIDevice.current.isiPad ? 30.0 : 25.0
                lblFreeTrial.text = "\("Payment is charged after".localized()) \(selected_Plan.plan_Free_Trail.duration) \(selected_Plan.plan_Free_Trail.unittype.localized()). \("cancel anytime.".localized()) "
            }
            else if selected_Plan.plan_Promotional_Offer.isPromotionalOffer {
                
                var txtMonthly = "Monthly".localized().lowercased()
                var txtMonth = "month".localized()
                if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.one_Month.plan_Id {
                    arrPlanLblDetail[selectedIndex].font = setCustomFont_WithoutRatio(name: .WorkSans_ExtraBold, iPhoneSize: 14, iPadSize: 17)
                    txtMonthly = "Monthly".localized().lowercased()
                    txtMonth = "month".localized()
                }
                else if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.one_Year.plan_Id {
                    arrPlanLblDetail[selectedIndex].font = setCustomFont_WithoutRatio(name: .WorkSans_ExtraBold, iPhoneSize: 14, iPadSize: 17)
                    txtMonthly = "Yearly".localized().lowercased()
                    txtMonth = "year".localized()
                }
                else if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.one_Week.plan_Id {
                    arrPlanLblDetail[selectedIndex].font = setCustomFont_WithoutRatio(name: .WorkSans_ExtraBold, iPhoneSize: 14, iPadSize: 17)
                    txtMonthly = "Weekly".localized().lowercased()
                    txtMonth = "week".localized()
                }
                
                let promoPrice = selected_Plan.plan_Promotional_Offer.price_String
                
                var str = "\(selectPlanPrice) \("for".localized()) \(txtMonthly) \("use".localized())"
                if selected_Plan.plan_Promotional_Offer.paymentMode == .payAsYouGo {
                    str = "\(promoPrice) \("upto".localized()) \(selected_Plan.plan_Promotional_Offer.numberOfPeriods) \(selected_Plan.plan_Promotional_Offer.subscriptionUnittype.localized()), \("then".localized()) \(selectPlanPrice)/\(txtMonth) "
                }
                else if selected_Plan.plan_Promotional_Offer.paymentMode == .payUpFront {
                    str = "\(promoPrice) \("for".localized()) \(selected_Plan.plan_Promotional_Offer.subscriptionDuration) \(selected_Plan.plan_Promotional_Offer.subscriptionUnittype.localized()), \("then".localized()) \(selectPlanPrice)/\(txtMonth) "
                }
                else if selected_Plan.plan_Promotional_Offer.paymentMode == .freeTrial {
                    str = "\(selected_Plan.plan_Promotional_Offer.subscriptionDuration) \(selected_Plan.plan_Promotional_Offer.subscriptionDuration) \("free".localized()), \("then".localized()) \(selectPlanPrice)/\(txtMonth) "
                }
                
                lblFreeTrial.text = str
            }
            else if selected_Plan.plan_Type == .lifetime {
                lblSubscribe.text = "Continue".localized().uppercased()
                lblFreeTrial.text = "Lifetime Purchase".localized() + " "
                if !lblFreeTrial.isHidden {
                    let str = "\(selectPlanPrice) \("for".localized()) \("Lifetime".localized().lowercased()) \("use".localized())"
                    lblFreeTrial.text = str
                }
            }
        }
    }
}

//MARK: - Purchase
extension SubMorePlanVC {
    private func purchaseByRevenueKit() {
        self.startLoader()
        if let tempPlan = selected_Plan
        {
            if let promoOffer = tempPlan.plan_Promotional_Offer.promoOffer, tempPlan.plan_Promotional_Offer.isPromotionalOffer && !tempPlan.plan_Free_Trail.isFreeTrail {
                
                RevenueCat_Manager.shared.purchaseProductWithPromo(ProductID: tempPlan.plan_Id, promoOffers: promoOffer) { [self] (state, info, error,isCancel) in
                    self.funManagePurchaseResponse(state: state, info: info, error: error, isCancel: isCancel)
                }
            }
            else {
                RevenueCat_Manager.shared.purchaseProduct(ProductID: tempPlan.plan_Id) { [self] (state, info, error,isCancel) in
                    self.funManagePurchaseResponse(state: state, info: info, error: error, isCancel: isCancel)
                }
            }
        }
    }
    
    private func funManagePurchaseResponse(state: Bool, info: CustomerInfo?, error: Error?, isCancel: Bool) {
        
        self.stopLoader()
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
    
    private func restoreByRevenueKit() {
        
        self.startLoader()
        
        RevenueCat_Manager.shared.restoreProduct { (state, info, error) in
            self.stopLoader()
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
    
    private func purchaseSuccess() {
        TikTok_Events.tikTokPurchaseSuccessEvent(plan: selected_Plan)
        Facebook_Events.addEventforSubscription(plan: selected_Plan)
        
        if selected_Plan.plan_Free_Trail.isFreeTrail {
            let param = [
                "from": self.isOpenFrom,
                "sku" : self.selected_Plan.plan_Id,
                "type" : self.selected_Plan.plan_Type.rawValue
            ]
            AddFirebaseEvent(eventName: EventsValues.SubSixBoxTrial, parameters: param)
            scheduleFreeTrialNotification(noOfDays: selected_Plan.plan_Free_Trail.duration)
            NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
            self.dismiss(animated: true, completion: {
                self.completionMorePlan!(.trialSuccess, param)
            })
        } else {
            let param = [
                "from": self.isOpenFrom,
                "sku" : self.selected_Plan.plan_Id,
                "type" : self.selected_Plan.plan_Type.rawValue
            ]
            AddFirebaseEvent(eventName: EventsValues.SubSixBoxSuccess, parameters: param)
            NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
            self.dismiss(animated: true, completion: {
                self.completionMorePlan!(.purchaseSuccess, param)
            })
        }
    }
    
    private func restoreSucess() {
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true, completion: {
            self.completionMorePlan!(.restoreSuccess, [:])
        })
    }
}

//MARK: - UICollectionView
extension SubMorePlanVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrReview.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubRatingCell.identifier, for: indexPath) as? SubRatingCell else { return UICollectionViewCell() }
        
        cell.semanticContentAttribute = .forceLeftToRight
        cell.mainContentView.backgroundColor = .systemBackground
        switch indexPath.row {
        case 0:
            cell.viewRating1.isHidden = false
            cell.viewRating2.isHidden = true
            cell.viewRating3.isHidden = true
        case 1:
            cell.viewRating1.isHidden = true
            cell.viewRating2.isHidden = false
            cell.viewRating3.isHidden = true
        default:
            cell.viewRating1.isHidden = true
            cell.viewRating2.isHidden = true
            cell.viewRating3.isHidden = false
        }
        let data = arrReview[indexPath.row]
        cell.customizationSubRatingData = self.customizationSubRatingData
        cell.lblTitle.text = data.title.localized() + "  "
        cell.lblDetail.text = data.description.localized()
        cell.lblName.text = "\("by".localized()) \(data.name.localized())"
        cell.lblDetail.numberOfLines = 3
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - ((UIDevice.current.isiPad ? 90 : 15) * 2)
        let height = width * (UIDevice.current.isiPad ? (140/648) : (100/296))
        return CGSize(width: width, height: height)
    }
}
