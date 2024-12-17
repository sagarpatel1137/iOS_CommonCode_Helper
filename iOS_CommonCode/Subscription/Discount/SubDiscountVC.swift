//
//  SubDiscountVC.swift
//  Voice GPS
//
//  Created by IOS on 04/06/24.
//

import UIKit
import StoreKit
import MarqueeLabel
import Lottie
import SwiftConfettiView
import RevenueCat

public struct UICustomizationSubDiscountTheme {
    public var mainViewColor: UIColor?
    public var popupImageBG: UIImage?
    public var popupImageTopBG: UIImage?
    public var subPopupImageBG: UIImage?
    public var imgButtonTryNow: UIImage?
    public var imgBtnClose: UIImage?
    public var lblPriceColor: UIColor?
    public var lblGetLifetimeColor: UIColor?
    public var lblDontMissColor: UIColor?
    
    public init(mainViewColor: UIColor? = nil, popupImageBG: UIImage? = nil, popupImageTopBG: UIImage? = nil, subPopupImageBG: UIImage? = nil, imgButtonTryNow: UIImage? = nil, imgBtnClose: UIImage? = nil, lblPriceColor: UIColor? = nil, lblGetLifetimeColor: UIColor? = nil, lblDontMissColor: UIColor? = nil) {
        self.mainViewColor = mainViewColor ?? .black.withAlphaComponent(0.5)
        self.popupImageBG = popupImageBG ?? ImageHelper.image(named: "ic_sub_popup_bg")
        self.popupImageTopBG = popupImageTopBG ?? ImageHelper.image(named: "ic_sub_popup_top")
        self.subPopupImageBG = subPopupImageBG ?? ImageHelper.image(named: "ic_sub_popup_offer_bg")
        self.imgButtonTryNow = imgButtonTryNow ?? ImageHelper.image(named: "Pod_sub_discount_btn")
        self.imgBtnClose = imgBtnClose ?? ImageHelper.image(named: "ic_sub_popup_close")
        self.lblPriceColor = lblPriceColor ?? hexStringToUIColor(hex: "D10366")
        self.lblGetLifetimeColor = lblGetLifetimeColor ?? hexStringToUIColor(hex: "210C1F")
        self.lblDontMissColor = lblDontMissColor ?? hexStringToUIColor(hex: "210C1F")
    }
}

public class SubDiscountVC: UIViewController {

    @IBOutlet weak var imgPopupImage: UIImageView!
    @IBOutlet weak var imgPopupImageTop: UIImageView!
    @IBOutlet weak var imgSubPopupImage: UIImageView!
    @IBOutlet weak var imgButtonTryNow: UIImageView!
    //MARK: -
    @IBOutlet weak var viewMain: SwiftConfettiView!
    @IBOutlet weak var lblLimitedTime: UILabel!
    @IBOutlet weak var lblGetLifetime: UILabel!
    @IBOutlet weak var lblPrice: MarqueeLabel!
    @IBOutlet weak var lblDontMiss: MarqueeLabel!
    @IBOutlet weak var viewTry: UIView!
    @IBOutlet weak var lblTry: MarqueeLabel!
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var viewJson: LottieAnimationView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewTop_Top: NSLayoutConstraint!
    
    //MARK: -
    public var customizationSubDiscountTheme = UICustomizationSubDiscountTheme()
    private var selected_Plan : SubscriptionConst.PlanInfo!
    var completionDiscount: ((SubCloseCompletionBlock, [String: String]?)->())?
    public var isOpenFrom = ""

    //MARK: -
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        AddFirebaseEvent(eventName: EventsValues.SubDiscountShow, parameters: ["from": self.isOpenFrom])
        
        AddNotification()
        
        setUpUI()
        setUpText()
        setUpFont()
        
        setPlanDetail()
        updateUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTry.layer.cornerRadius = viewTry.bounds.height/2
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Set Up
    
    private func updateUI() {
        self.view.backgroundColor = self.customizationSubDiscountTheme.mainViewColor ?? .black
        
        if let popupImageBG = customizationSubDiscountTheme.popupImageBG {
            self.imgPopupImage.image = popupImageBG
        }
        
        if let popupImageTopBG = customizationSubDiscountTheme.popupImageTopBG {
            self.imgPopupImageTop.image = popupImageTopBG
        }
        
        if let subPopupImageBG = customizationSubDiscountTheme.subPopupImageBG {
            self.imgSubPopupImage.image = subPopupImageBG
        }
        
        if let imgButtonTryNow = customizationSubDiscountTheme.imgButtonTryNow {
            self.imgButtonTryNow.image = imgButtonTryNow
        }
        
        if let imgBtnClose = customizationSubDiscountTheme.imgBtnClose {
            self.btnClose.setImage(imgBtnClose, for: .normal)
        }
        
        lblGetLifetime.textColor = customizationSubDiscountTheme.lblGetLifetimeColor ?? hexStringToUIColor(hex: "210C1F")
        lblDontMiss.textColor = customizationSubDiscountTheme.lblDontMissColor ?? hexStringToUIColor(hex: "210C1F")
    }
    
    private func setUpUI() {
        
        viewTop_Top.constant = UIDevice.current.isiPhone ? 5*fontRatio : 7*fontRatio
        
        let padding : CGFloat = UIDevice.current.isiPhone ? 10 : 15
        btnClose.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        if let loadJSONURL = PodBundleHelper.loadJSONFile(named: "lottie_subscription_continue_bg") {
            viewJson.animation = LottieAnimation.filepath(loadJSONURL.path)
            viewJson.contentMode = .scaleAspectFill
            viewJson?.loopMode = .loop
            viewJson.play()
        }
        
        setupConfettiAnimation()
        funManageCloseBtn()
    }
    
    private func setUpText() {
        lblLimitedTime.text = "Exclusive Deal".localized()
        lblGetLifetime.text = "Limited Time Offer Specially For You!".localized()
        lblDontMiss.text = "Don't Miss Out!".localized() + " "
        lblTry.text = "TRY NOW".localized()
    }
    
    private func setUpFont() {
        lblLimitedTime.font = setCustomFont(name: .WorkSans_Bold, iPhoneSize: 19, iPadSize: 26)
        lblGetLifetime.font = setCustomFont(name: .WorkSans_SemiBold, iPhoneSize: 19, iPadSize: 28)
        lblDontMiss.font = setCustomFont(name: .WorkSans_SemiBold, iPhoneSize: 18, iPadSize: 26)
        lblTry.font = setCustomFont(name: .WorkSans_Bold, iPhoneSize: 16, iPadSize: 24)
    }
    
    private func setupConfettiAnimation() {
        viewMain.type = .confetti
        viewMain.intensity = 0.75
        viewMain.startConfetti()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            if self.viewMain.isActive() {
                self.viewMain.stopConfetti()
            }
        }
    }
    
    private func funManageCloseBtn() {
        btnClose.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5) {
                self.btnClose.alpha = 1
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.completionDiscount!(.close, [:])
        }
    }
    
    @IBAction func btnTryClick(_ sender: Any) {
        if SubscriptionConst.ActivePlans.one_Month_Discount.plan_Id != ""  {
            AddFirebaseEvent(eventName: EventsValues.SubDiscountClick, parameters: [
                "from": self.isOpenFrom,
                "sku" : self.selected_Plan.plan_Id,
                "type" : self.selected_Plan.plan_Type.rawValue
            ])
            purchaseByRevenueKit()
        }
    }
}

//MARK: - Plan Detail
extension SubDiscountVC {
    
    private func setPlanDetail()
    {
        DispatchQueue.main.async { [self] in
            self.startPriceLoader()
            
            selected_Plan = SubscriptionConst.ActivePlans.one_Month_Discount
            
            let font1: UIFont = setCustomFont(name: .WorkSans_Medium, iPhoneSize: 18, iPadSize: 26)
            let font2: UIFont = setCustomFont(name: .WorkSans_SemiBold, iPhoneSize: 35, iPadSize: 48)
            let color1: UIColor = customizationSubDiscountTheme.lblPriceColor ?? hexStringToUIColor(hex: "D10366")
            
            let monthPrice = selected_Plan.plan_Price_String
            
            let str = "\(monthPrice)/\("month".localized())"
            self.lblPrice.attributedText = str.setAttributeToString(font1: font1, font2: font2, color1: color1, color2: color1, text: monthPrice)
            
            self.stopPriceLoader()
        }
    }
}

//MARK: - Purchase & Restore
extension SubDiscountVC
{
    //MARK: - Revenue Cat Purchase
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
    
    private func purchaseSuccess()
    {
        let param = [
            "from": self.isOpenFrom,
            "sku" : selected_Plan.plan_Id,
            "type" : selected_Plan.plan_Type.rawValue
        ]
        
        TikTok_Events.tikTokPurchaseSuccessEvent(plan: selected_Plan)
        Facebook_Events.addEventforSubscription(plan: selected_Plan)
        AddFirebaseEvent(eventName: EventsValues.SubMonthDiscountPurchaseSuccess, parameters: param)
        NotificationCenter.default.post(name: notificationPurchaseSuccessfully, object: nil)
        self.dismiss(animated: true) {
            self.completionDiscount!(.purchaseSuccess, param)
        }
    }
}

//MARK: - Notification
extension SubDiscountVC
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

//MARK: - Loader
extension SubDiscountVC
{
    private func startPriceLoader() {
        DispatchQueue.main.async {
            self.viewLoader.isHidden = false
            self.viewLoader.startAnimating()
        }
    }

    private func stopPriceLoader()
    {
        DispatchQueue.main.async {
            self.viewLoader.isHidden = true
            self.viewLoader.stopAnimating()
        }
    }
}
