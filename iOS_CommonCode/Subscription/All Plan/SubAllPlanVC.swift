//
//  SubAllPlanVC.swift
//  Voice GPS
//
//  Created by IOS on 21/08/24.
//

import UIKit
import Lottie
import StoreKit
import RevenueCat
import MarqueeLabel

public enum SubCloseCompletionBlock {
    case close
    case trialSuccess
    case purchaseSuccess
    case restoreSuccess
    case failed
    case unknown
}

public struct ReviewModel {
    public var title: String
    public var starCount: Int
    public var description: String
    public var name: String
    
    public init(title: String, starCount: Int, description: String, name: String) {
        self.title = title
        self.starCount = starCount
        self.description = description
        self.name = name
    }
}

public struct FeatureModel {
    public var feature: String
    public var imgage: UIImage
    
    public init(feature: String, imgage: UIImage) {
        self.feature = feature
        self.imgage = imgage
    }
}

public struct UICustomizationAllPlan {
    public var buttonBGType: ButtonBGType = .animateJson
    public var btnContinueSolidColor: UIColor?
    public var btnContinueFromColor: UIColor?
    public var btnContinueToColor: UIColor?
    public var btnContinueImageiPhone: UIImage?
    public var btnContinueImageiPad: UIImage?
    public var btnJsonFilenameiPhone: String?
    public var btnJsonFilenameiPad: String?
    
    public init(buttonBGType: ButtonBGType = .animateJson, btnContinueSolidColor: UIColor? = nil, btnContinueFromColor: UIColor? = nil, btnContinueToColor: UIColor? = nil, btnContinueImageiPhone: UIImage? = nil, btnContinueImageiPad: UIImage? = nil, btnJsonFilenameiPhone: String? = nil, btnJsonFilenameiPad: String? = nil) {
        self.buttonBGType = buttonBGType
        self.btnContinueSolidColor = btnContinueSolidColor ?? .black
        self.btnContinueFromColor = btnContinueFromColor ?? .black
        self.btnContinueToColor = btnContinueToColor ?? .black
        self.btnContinueImageiPhone = btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_iPhone-Capsule")
        self.btnContinueImageiPad = btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_iPad-Capsule")
        self.btnJsonFilenameiPhone = btnJsonFilenameiPhone ?? "lottie_subscription_continue_bg"
        self.btnJsonFilenameiPad = btnJsonFilenameiPad ?? "lottie_subscription_continue_bg"
    }
}

public class SubAllPlanVC: UIViewController {

    @IBOutlet weak var imgSubTop: UIImageView!
    @IBOutlet weak var btnCloseSquare: UIButton!
    //MARK: -
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var lblFreeTrial: MarqueeLabel!
    
    @IBOutlet weak var collViewFeature: UICollectionView!
    @IBOutlet weak var collViewReview: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //Plans
    @IBOutlet weak var stackViewPlans: UIStackView!
    @IBOutlet weak var viewBadgeLifetime: UIView!
    @IBOutlet weak var viewBadgeYear: UIView!
    @IBOutlet weak var viewBadgeMonth: UIView!
    @IBOutlet weak var viewBadgeWeek: UIView!
    @IBOutlet weak var lblBadgeLifetime: UILabel!
    @IBOutlet weak var lblBadgeYear: UILabel!
    @IBOutlet weak var lblBadgeMonth: UILabel!
    @IBOutlet weak var lblBadgeWeek: UILabel!

    @IBOutlet weak var viewLifeTime: UIView!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var viewWeek: UIView!

    @IBOutlet var arrBtnPlan: [UIButton]!
    @IBOutlet var arrLblPlanTitle : [MarqueeLabel]!
    @IBOutlet var arrLblPlanDetail : [MarqueeLabel]!
    @IBOutlet var arrLblPlanOff : [UILabel]!
    @IBOutlet var arrLblPlanPrice : [UILabel]!
    
    //Purchase
    @IBOutlet weak var lblPriceDetail: MarqueeLabel!
    @IBOutlet weak var viewStart: Gradient!
    @IBOutlet weak var viewJson: LottieAnimationView!
    @IBOutlet weak var lblStart: MarqueeLabel!
    
    @IBOutlet weak var lblPayNothing: MarqueeLabel!
    @IBOutlet weak var lblPayNothing_Bottom: NSLayoutConstraint!
    @IBOutlet weak var viewShield: UIView!
    @IBOutlet weak var lblCancelAnytime: MarqueeLabel!
    
    //Bottom
    @IBOutlet weak var lblTerms: MarqueeLabel!
    @IBOutlet weak var lblRestore: MarqueeLabel!
    @IBOutlet weak var lblPrivacy: MarqueeLabel!
    @IBOutlet weak var imgContinue: UIImageView!
    @IBOutlet weak var btnSubscribe: UIButton!
    
    //MARK: -
    
    var startPosition = 0.0
    var selectedIndex = 0
    var isFromTimer = false
    
    var scrollingTimer: Timer?
    var loopMultiplier = 50
    
    var isFromTimeline = false
    
    private var selected_Plan : SubscriptionConst.PlanInfo!
    private var arrFeatureLoop: [FeatureModel] = []
    var completionMorePlan: ((SubCloseCompletionBlock, [String: String]?)->())?

    // MARK: - customize
    public var subsciptionContinueBtnTextIndex = 0
    public var arrFeature: [FeatureModel] = []
    public var arrReview: [ReviewModel] = []
    public var customizationAllPlan: UICustomizationAllPlan?
    public var customizationSubRatingData: UICustomizationSubRatingData?
    public var customizationWebViewData: UICustomizationWebView?
    public var enableRatingAutoScroll = false
    public var isRatingScrollEnable = true
    public var lifetimeDiscountVal = 80
    public var isOpenFrom = ""
    public var isPresentSubAlertSheet = true
    public var modalTransitionStyleForWebVC: UIModalTransitionStyle = .crossDissolve
    
    //MARK: -
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: -
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        AddFirebaseEvent(eventName: EventsValues.SubAllPlanShow, parameters: ["from": self.isOpenFrom])
        AddNotification()
        
        setUpUI()
        setUpText()
        setUpFont()
        setUpGestures()
        setUpAnimation()
        
        funCheckAndGetSubscriptionPrice()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewStart.layer.cornerRadius = viewStart.bounds.height/2
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -
    func setUpUI()
    {
        imgSubTop.image = ImageHelper.image(named: "ic_sub_top_bg")!
        btnCloseSquare.setImage(ImageHelper.image(named: "ic_close_square")!, for: .normal)
        viewLifeTime.layer.borderWidth = 1
        viewYear.layer.borderWidth = 1
        viewMonth.layer.borderWidth = 1
        viewWeek.layer.borderWidth = 1
        
        viewBadgeLifetime.layer.cornerRadius = 6
        viewBadgeYear.layer.cornerRadius = 6
        viewBadgeMonth.layer.cornerRadius = 6
        viewBadgeWeek.layer.cornerRadius = 6
        
        viewLifeTime.layer.cornerRadius = UIDevice.current.isiPhone ? 11 : 15
        viewYear.layer.cornerRadius = UIDevice.current.isiPhone ? 11 : 15
        viewMonth.layer.cornerRadius = UIDevice.current.isiPhone ? 11 : 15
        viewWeek.layer.cornerRadius = UIDevice.current.isiPhone ? 11 : 15
        
        pageControl.numberOfPages = arrReview.count
        updatePageControl()
        
        arrFeatureLoop = Array(repeating: arrFeature, count: loopMultiplier).flatMap { $0 }
        
        collViewFeature.delegate = self
        collViewFeature.dataSource = self
        collViewFeature.register(UINib(nibName: SubFeatureCell.identifier, bundle: nil), forCellWithReuseIdentifier: SubFeatureCell.identifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIDevice.current.isiPhone ? 15 : 50, bottom: 0, right:UIDevice.current.isiPhone ? 15 : 50)
        layout.minimumInteritemSpacing = UIDevice.current.isiPhone ? 15 : 25
        layout.minimumLineSpacing = UIDevice.current.isiPhone ? 15 : 25
        layout.scrollDirection = .horizontal
        collViewFeature.collectionViewLayout = layout

        collViewReview.delegate = self
        collViewReview.dataSource = self
        collViewReview.register(UINib(nibName: SubRatingCell.identifier, bundle: nil), forCellWithReuseIdentifier: SubRatingCell.identifier)
        startTimer()
    }
    
    func setUpText()
    {
        lblTitle.text = "Unlock All Features".localized() + " ✨ "
        
        lblBadgeLifetime.text = "Best Value".localized()
        lblBadgeYear.text = "Most Popular".localized()
        lblBadgeMonth.text = "Recommend".localized()
        
        arrLblPlanTitle[0].text = "Lifetime".localized() + " "
        arrLblPlanTitle[1].text = "Yearly".localized() + " "
        arrLblPlanTitle[2].text = "Monthly".localized() + " "
        arrLblPlanTitle[3].text = "Weekly".localized() + " "
        
        arrLblPlanDetail[0].text = "Pay once, enjoy forever".localized() + " "
        arrLblPlanDetail[3].text = "Enjoy forever".localized() + " "
        
        lblStart.text = "Continue".localized().uppercased()
        lblPayNothing.text = "Pay Nothing Now".localized() + " "
        lblCancelAnytime.text = "Cancel anytime. Secure with App Store".localized() + " "
        lblRestore.text = "Restore".localized() + " "
        lblTerms.text = "Terms of Use".localized() + " "
        lblPrivacy.text = "Privacy Policy".localized() + " "
    }
    
    func setUpFont()
    {
        lblTitle.font = setCustomFont(name: .Avenir_Black, iPhoneSize: 21, iPadSize: 37)
        lblFreeTrial.font = setCustomFont(name: .Avenir_Medium, iPhoneSize: 13, iPadSize: 20)
        
        lblBadgeLifetime.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 10, iPadSize: 15)
        lblBadgeYear.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 10, iPadSize: 15)
        lblBadgeMonth.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 10, iPadSize: 15)
        lblBadgeWeek.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 10, iPadSize: 15)
        
        for i in 0..<stackViewPlans.arrangedSubviews.count {
            arrLblPlanTitle [i].font = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 13, iPadSize: 20)
            arrLblPlanDetail [i].font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 10, iPadSize: 15)
            arrLblPlanOff[i].font = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 11, iPadSize: 18)
            arrLblPlanPrice[i].font = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 15, iPadSize: 21)
        }
        
        lblPriceDetail.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 11, iPadSize: 19)
        
        lblStart.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 18, iPadSize: 29)
        lblPayNothing.font = setCustomFont(name: .PlusJakartaSans_SemiBold, iPhoneSize: 13, iPadSize: 20)
        lblCancelAnytime.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 10, iPadSize: 21)
        lblRestore.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 11, iPadSize: 18)
        lblTerms.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 11, iPadSize: 18)
        lblPrivacy.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 11, iPadSize: 18)
    }
    
    func setUpAnimation()
    {
        
        imgContinue.isHidden = true
        viewJson.isHidden = true
        switch customizationAllPlan?.buttonBGType {
        case .solidColor:
            self.btnSubscribe.backgroundColor = customizationAllPlan?.btnContinueSolidColor ?? .black
        case .gradientColor:
            let from = self.customizationAllPlan?.btnContinueFromColor ?? .black
            let to = self.customizationAllPlan?.btnContinueToColor ?? .black
            self.btnSubscribe.addGradient(colors: [from, to], isRounded: true)
        case .image:
            imgContinue.isHidden = false
            if UIDevice.current.isiPhone {
                self.imgContinue.image = self.customizationAllPlan?.btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_iPhone-Capsule")
            } else {
                self.imgContinue.image = self.customizationAllPlan?.btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_iPad-Capsule")
            }
        case .animateJson, .none:
            imgContinue.isHidden = false
            viewJson.isHidden = false
            if UIDevice.current.isiPhone {
                self.imgContinue.image = self.customizationAllPlan?.btnContinueImageiPhone ?? ImageHelper.image(named: "Pod_sub_iPhone-Capsule")
            } else {
                self.imgContinue.image = self.customizationAllPlan?.btnContinueImageiPad ?? ImageHelper.image(named: "Pod_sub_iPad-Capsule")
            }
            if let btnJsonFilenameiPad = customizationAllPlan?.btnJsonFilenameiPad,
               let btnJsonFilenameiPhone = customizationAllPlan?.btnJsonFilenameiPhone {
                if UIDevice.current.isiPad {
                    if let loadJSONURL = PodBundleHelper.loadJSONFile(named: btnJsonFilenameiPad) {
                        viewJson.animation = LottieAnimation.filepath(loadJSONURL.path)
                        viewJson?.loopMode = .loop
                        viewJson.contentMode = .scaleAspectFill
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
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0){
            self.startScrolling()
        }
    }
    
    func setUpGestures()
    {
        lblPayNothing.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnCloseAction))
        lblPayNothing?.addGestureRecognizer(tapGesture)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.01
        collViewFeature.addGestureRecognizer(longPressRecognizer)
    }
    
    func funCheckAndGetSubscriptionPrice()
    {
        setPlanDetail()
        DispatchQueue.main.async { [self] in
            btnProductClicked(arrBtnPlan[1])
        }
    }
    
    //MARK: - UIActions
    @IBAction func btnCloseAction(_ sender: Any) {
        stopScrolling()
        
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
        
        viewLifeTime.layer.borderColor = hexStringToUIColor(hex: "DFE4EB").cgColor
        viewYear.layer.borderColor = hexStringToUIColor(hex: "DFE4EB").cgColor
        viewMonth.layer.borderColor = hexStringToUIColor(hex: "DFE4EB").cgColor
        viewWeek.layer.borderColor = hexStringToUIColor(hex: "DFE4EB").cgColor
        
        switch sender.tag {
        case 100:
            selected_Plan = SubscriptionConst.ActivePlans.life_Time
            viewLifeTime.layer.borderColor = hexStringToUIColor(hex: "00B364").cgColor
        case 101:
            selected_Plan = SubscriptionConst.ActivePlans.one_Year
            viewYear.layer.borderColor = hexStringToUIColor(hex: "FF4050").cgColor
        case 102:
            selected_Plan = SubscriptionConst.ActivePlans.one_Month
            viewMonth.layer.borderColor = hexStringToUIColor(hex: "1DB2F3").cgColor
        case 103:
            selected_Plan = SubscriptionConst.ActivePlans.one_Week
            viewWeek.layer.borderColor = hexStringToUIColor(hex: "174D95").cgColor
        default:
            break
        }
        
        funShowSelectedPlanDetails()
    }
    
    @IBAction func btnStartAction(_ sender: Any) {
        
        AddFirebaseEvent(eventName: EventsValues.SubAllPlanClick, parameters: [
            "from": self.isOpenFrom,
            "sku" : self.selected_Plan.plan_Id,
            "type" : self.selected_Plan.plan_Type.rawValue
        ])
        
        purchaseByRevenueKit()
    }
    
    @IBAction func btnRestoreAction(_ sender: Any) {
        restoreByRevenueKit()
    }
    
    @IBAction func btnPrivacyAction(_ sender: Any) {
        
        self.openWebVC(titleStr: "Privacy Policy".localized(), urlStr: Pod_AppPrivacyPolicyURL, customization: self.customizationWebViewData, modalTransitionStyle: self.modalTransitionStyleForWebVC)
    }
    
    @IBAction func btnTermsAction(_ sender: Any) {
        self.openWebVC(titleStr:"Terms of Use".localized(), urlStr: Pod_AppTermsAnsConditionURL, customization: self.customizationWebViewData, modalTransitionStyle: self.modalTransitionStyleForWebVC)
    }
}

//MARK: - Plan Detail
extension SubAllPlanVC
{
    private func setPlanDetail()
    {
        selected_Plan = SubscriptionConst.ActivePlans.one_Year
        
        countDisCount()
        
        if SubscriptionConst.ActivePlans.life_Time.plan_Id != "" {
            let lifeTimePlan = SubscriptionConst.ActivePlans.life_Time
            arrLblPlanPrice[0].text = lifeTimePlan.plan_Price_String
        }
        if SubscriptionConst.ActivePlans.one_Year.plan_Id != ""
        {
            let yearPlan = SubscriptionConst.ActivePlans.one_Year
            if !yearPlan.plan_Free_Trail.isFreeTrail && yearPlan.plan_Promotional_Offer.isPromotionalOffer {
                arrLblPlanPrice[1].text = yearPlan.plan_Promotional_Offer.price_String
            }
            else {
                arrLblPlanPrice[1].text = yearPlan.plan_Price_String
            }
            
            let price = yearPlan.plan_Price/12
            var priceStr = ""
            if RevenueCat_Manager.shared.GetDecimalPart(of: price) > 0 {
                priceStr = "\(yearPlan.plan_Currancy_Code)" + String(format:"%.2f", price)
            } else {
                priceStr = "\(yearPlan.plan_Currancy_Code)" + String(format:"%.f", price)
            }
            arrLblPlanDetail[1].text = "\(priceStr) \("per".localized()) \("month".localized())"
        }
        if SubscriptionConst.ActivePlans.one_Month.plan_Id != ""
        {
            let monthPlan = SubscriptionConst.ActivePlans.one_Month
            if !monthPlan.plan_Free_Trail.isFreeTrail && monthPlan.plan_Promotional_Offer.isPromotionalOffer {
                arrLblPlanPrice[2].text = monthPlan.plan_Promotional_Offer.price_String
            }
            else {
                arrLblPlanPrice[2].text = monthPlan.plan_Price_String
            }
            
            let price = monthPlan.plan_Price/4
            var priceStr = ""
            if RevenueCat_Manager.shared.GetDecimalPart(of: price) > 0 {
                priceStr = "\(monthPlan.plan_Currancy_Code)" + String(format:"%.2f", price)
            } else {
                priceStr = "\(monthPlan.plan_Currancy_Code)" + String(format:"%.f", price)
            }
            arrLblPlanDetail[2].text = "\(priceStr) \("per".localized()) \("week".localized())"
        }
        if SubscriptionConst.ActivePlans.one_Week.plan_Id != ""
        {
            let weekPlan = SubscriptionConst.ActivePlans.one_Week
            if !weekPlan.plan_Free_Trail.isFreeTrail && weekPlan.plan_Promotional_Offer.isPromotionalOffer {
                arrLblPlanPrice[3].text = weekPlan.plan_Promotional_Offer.price_String
            }
            else {
                arrLblPlanPrice[3].text = weekPlan.plan_Price_String
            }
        }
    }
    
    func countDisCount()
    {
        arrLblPlanOff[0].text =  "\(self.lifetimeDiscountVal)% \("OFF".localized())"
        
        let totalYearPrice = 12 * (SubscriptionConst.ActivePlans.one_Month.plan_Price)
        let yearActualPrice = SubscriptionConst.ActivePlans.one_Year.plan_Price
        let perc2 = (yearActualPrice * 100) / totalYearPrice
        let disPer2 = 100 - perc2
        let stringPert2 = String(format: "%.f", disPer2)
        arrLblPlanOff[1].text =  "\(stringPert2)% \("OFF".localized())"
        
        let totalMonthPrice = 4 * (SubscriptionConst.ActivePlans.one_Week.plan_Price)
        let monthActualPrice = SubscriptionConst.ActivePlans.one_Month.plan_Price
        let perc3 = (monthActualPrice * 100) / totalMonthPrice
        let disPer3 = 100 - perc3
        let stringPert3 = String(format: "%.f", disPer3)
        arrLblPlanOff[2].text =  "\(stringPert3)% \("OFF".localized())"
    }
    
    func funShowSelectedPlanDetails()
    {
        DispatchQueue.main.async { [self] in
         
            lblFreeTrial.text = "Subscription will auto-renew, Cancel anytime.".localized() + " "
            lblStart.text = "Continue".localized().uppercased()
            lblPayNothing.text = ""
            lblPayNothing.isHidden = true
            lblPayNothing_Bottom.constant = 0
            
            var strPlanDuration = ""
            var strPlanAlias = ""
            if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.one_Week.plan_Id {
                strPlanDuration = "week".localized()
                strPlanAlias = "Weekly".localized()
            }
            else if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.one_Month.plan_Id {
                strPlanDuration = "month".localized()
                strPlanAlias = "Monthly".localized()
            }
            else if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.one_Year.plan_Id {
                strPlanDuration = "year".localized()
                strPlanAlias = "Yearly".localized()
            }
            
            if selected_Plan.plan_Free_Trail.isFreeTrail
            {
                if subsciptionContinueBtnTextIndex == 1 {
                    lblStart.text = "Start My Free Trial".localized().uppercased() + " "
                }
                else if subsciptionContinueBtnTextIndex == 2 {
                    lblStart.text = "\("Try".localized()) \(selected_Plan.plan_Free_Trail.duration) \(selected_Plan.plan_Free_Trail.unittype.localized()) \("for".localized()) \(selected_Plan.plan_Currancy_Code)0"
                }
                
                lblPayNothing.text = "Pay Nothing Now".localized() + " "
                lblPayNothing.isHidden = false
                lblPayNothing_Bottom.constant = UIDevice.current.isiPhone ? 12 : 18
                
                lblFreeTrial.text = "\("Payment is charged after".localized()) \(selected_Plan.plan_Free_Trail.duration) \(selected_Plan.plan_Free_Trail.unittype.localized()). \("cancel anytime.".localized()) "
            
                lblPriceDetail.text = "\(selected_Plan.plan_Free_Trail.duration ) \(selected_Plan.plan_Free_Trail.unittype.localized()) \("free".localized()), \("then".localized()) \(selected_Plan.plan_Price_String)/\(strPlanDuration) "
            }
            else if selected_Plan.plan_Promotional_Offer.isPromotionalOffer
            {
                var str = "\(selected_Plan.plan_Price_String) \("for".localized()) \(strPlanAlias.lowercased()) \("use".localized())"
                if selected_Plan.plan_Promotional_Offer.paymentMode == .payAsYouGo {
                    str = "\(selected_Plan.plan_Promotional_Offer.price_String) \("upto".localized()) \(selected_Plan.plan_Promotional_Offer.numberOfPeriods) \(selected_Plan.plan_Promotional_Offer.subscriptionUnittype.localized()), \("then".localized()) \(selected_Plan.plan_Price_String)/\(strPlanDuration) "
                }
                else if selected_Plan.plan_Promotional_Offer.paymentMode == .payUpFront {
                    str = "\(selected_Plan.plan_Promotional_Offer.price_String) \("for".localized()) \(selected_Plan.plan_Promotional_Offer.subscriptionDuration) \(selected_Plan.plan_Promotional_Offer.subscriptionUnittype.localized()), \("then".localized()) \(selected_Plan.plan_Price_String)/\(strPlanDuration) "
                }
                else if selected_Plan.plan_Promotional_Offer.paymentMode == .freeTrial {
                    str = "\(selected_Plan.plan_Promotional_Offer.subscriptionDuration) \(selected_Plan.plan_Promotional_Offer.subscriptionDuration) \("free".localized()), \("then".localized()) \(selected_Plan.plan_Price_String)/\(strPlanDuration) "
                }
                
                lblPriceDetail.text = str
            }
            else
            {
                if selected_Plan.plan_Id == SubscriptionConst.ActivePlans.life_Time.plan_Id {
                    lblFreeTrial.text = "Lifetime Purchase".localized() + " "
                    let str = "\(selected_Plan.plan_Price_String) \("for".localized()) \("Lifetime".localized().lowercased()) \("use".localized())"
                    lblPriceDetail.text = str
                } else {
                    let str = "\(selected_Plan.plan_Price_String) \("for".localized()) \(strPlanAlias.lowercased()) \("use".localized())"
                    lblPriceDetail.text = str
                }
            }
            
        }
    }
}


//MARK: -
extension SubAllPlanVC
{
    func purchaseByRevenueKit() {
        self.Pod_startLoader()
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
    
    func restoreByRevenueKit(){
        
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
        
        if selected_Plan.plan_Free_Trail.isFreeTrail {
            let param = [
                "from": self.isOpenFrom,
                "sku" : self.selected_Plan.plan_Id,
                "type" : self.selected_Plan.plan_Type.rawValue
            ]
            AddFirebaseEvent(eventName: EventsValues.SubAllPlanTrial, parameters: param)
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
            AddFirebaseEvent(eventName: EventsValues.SubAllPlanSuccess, parameters: param)
            
            NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
            self.dismiss(animated: true, completion: {
                self.completionMorePlan!(.purchaseSuccess, param)
            })
        }
    }
    
    func restoreSucess()
    {
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true, completion: {
            self.completionMorePlan!(.restoreSuccess, [:])
        })
    }
}

//MARK: -
extension SubAllPlanVC
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
extension SubAllPlanVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 100 {
            arrFeatureLoop.count
        } else {
            arrReview.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 100
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubFeatureCell.identifier, for: indexPath) as? SubFeatureCell else { return UICollectionViewCell() }
            
            cell.imgThumb.image = arrFeatureLoop[indexPath.item].imgage
            cell.lblName.text = arrFeatureLoop[indexPath.item].feature.localized()
            cell.lblName.font = setCustomFont(name: .PlusJakartaSans_Medium, iPhoneSize: 10, iPadSize: 12)
            cell.imgBg.image = ImageHelper.image(named: "ic_sub_feature_bg")!
            return cell
        }
        else
        {
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
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 100 {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
        else {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isFromTimer {
            if let collectionView = scrollView as? UICollectionView {
                switch collectionView.tag {
                case 101:
                    let pageSide = collViewReview.bounds.width
                    let offset = scrollView.contentOffset.x
                    let index = Int(floor((offset - pageSide / 2) / pageSide) + 1)
                    
                    if index >= 0 && index < arrReview.count && index != selectedIndex {
                        selectedIndex = index
                        updatePageControl()
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc func scrollToNextCell() {
        
        let cellSize = CGSize(width: collViewReview.bounds.width, height: collViewReview.bounds.height)
        let contentOffset = collViewReview.contentOffset;
        
        isFromTimer = true
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5){
            self.isFromTimer = false
        }
        if selectedIndex == arrReview.count-1 {
            selectedIndex = 0
            collViewReview.scrollRectToVisible(CGRectMake(0, contentOffset.y, cellSize.width, cellSize.height), animated: false)
        } else {
            selectedIndex = selectedIndex + 1
            collViewReview.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true)
        }
        updatePageControl()
    }
    
    func startTimer() {
        if enableRatingAutoScroll && isRatingScrollEnable {
            _ =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        } else {
            self.collViewReview.isUserInteractionEnabled = isRatingScrollEnable
            self.pageControl.isHidden = !isRatingScrollEnable
        }
    }
    
    func updatePageControl() {
        DispatchQueue.main.async {
            self.pageControl.currentPage = self.selectedIndex
        }
    }
}

//MARK: -
extension SubAllPlanVC
{
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            stopScrolling()
        case .ended, .cancelled:
            startScrolling()
        default:
            break
        }
    }
    
    func startScrolling() {
        
        let totalContentWidth = collViewFeature.contentSize.width
        let scrollSpeed = totalContentWidth / CGFloat(loopMultiplier*15)
        
        scrollingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let offset = self.collViewFeature.contentOffset.x + (scrollSpeed * 0.01)
            
            if offset >= self.collViewFeature.contentSize.width {
                self.collViewFeature.contentOffset = .zero
            } else {
                self.collViewFeature.contentOffset = CGPoint(x: offset, y: 0)
            }
        }
        
        RunLoop.main.add(scrollingTimer!, forMode: .common)
    }

    func stopScrolling() {
        scrollingTimer?.invalidate()
        scrollingTimer = nil
    }
}
