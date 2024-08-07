//
//  RevenueCat_Manager.swift
//  Sample_Project
//
//  Created by IOS on 28/03/24.
//

import UIKit
import RevenueCat

public class RevenueCat_Manager : NSObject {
    
    public static let shared = RevenueCat_Manager()
    static var AvailableProducts = [Package]()
    static var purchaseInfo : CustomerInfo?
    
    private var WeekSubscriptionID = String()
    private var OneMonthSubscriptionID = String()
    private var TwoMonthSubscriptionID = String()
    private var ThreeMonthSubscriptionID = String()
    private var SixMonthSubscriptionID = String()
    private var YearSubscriptionID = String()
    private var LifetimeSubscriptionID = String()
    
    private var isWeekIntroductoryAvailable = false
    private var isOneMonthIntroductoryAvailable = false
    private var isTwoMonthIntroductoryAvailable = false
    private var isThreeMonthIntroductoryAvailable = false
    private var isSixMonthIntroductoryAvailable = false
    private var isYearIntroductoryAvailable = false

    private var subProductIds = SubscriptionProductIds()
    
    public var isExperimentPrice = false
    
    
    /// Initialise RevenueCat
    /// - Parameters:
    ///   - APIKey: RevenueCat APIKey
    ///   - AppId: RevenueCat AppId
    ///   - sharedSecret: sharedSecret of the application
    public func initialiseRevenueCat(APIKey: String, AppId: String = "", sharedSecret: String = "", productIds: SubscriptionProductIds) {
    
        //Purchases.logLevel = .debug
        //Purchases.configure(withAPIKey: APIKey)
        Purchases.configure(with: Configuration.Builder(withAPIKey: APIKey)
            .with(usesStoreKit2IfAvailable: true)
            .build()
        )
        
        SubscriptionConst.GeneralConst.revanueKitApiKey = APIKey
        SubscriptionConst.GeneralConst.revanueKitAppId = AppId
        SubscriptionConst.GeneralConst.sharedSecret = sharedSecret
        
        subProductIds = productIds
    }
    
    // MARK: - Check Purchase
    public func funCheckForPurchase(completion:@escaping(()->Void)) {
        
        if Reachability.isConnectedToNetwork() {
            
            DispatchQueue.global(qos: .background).async {
                self.getPurchaseProductInfo { (state,err) in
                    if state {
                        if RevenueCat_Manager.purchaseInfo?.entitlements.active.count == 0 {
                            Purchase_flag = false
                        } else {
                            Purchase_flag = true
                        }
                        self.GetAllAvailablePackages { (state,err) in
                            completion()
                        }
                    } else {
                        completion()
                    }
                }
            }
        }
        else {
            completion()
        }
    }
    
    // MARK: - Get Packages
    public func GetAllAvailablePackages(complition : @escaping(Bool,Error?)-> Void)
    {
        if RevenueCat_Manager.AvailableProducts.count == 0
        {
            Purchases.shared.getOfferings { [self] (offerings, error) in
                
                if let err = error {
                    complition(false,err)
                    return
                }
                
                if let packages = offerings?.current?.availablePackages {
                    RevenueCat_Manager.AvailableProducts = packages
                    
                    var productIDs: [String] = []
                    
                    for package in RevenueCat_Manager.AvailableProducts {
                        
                        switch package.packageType {
                        case .weekly:
                            self.WeekSubscriptionID = package.storeProduct.productIdentifier
                        case .monthly:
                            self.OneMonthSubscriptionID = package.storeProduct.productIdentifier
                        case .twoMonth:
                            self.TwoMonthSubscriptionID = package.storeProduct.productIdentifier
                        case .threeMonth:
                            self.ThreeMonthSubscriptionID = package.storeProduct.productIdentifier
                        case .sixMonth:
                            self.SixMonthSubscriptionID = package.storeProduct.productIdentifier
                        case .annual:
                            self.LifetimeSubscriptionID = package.storeProduct.productIdentifier
                        case .lifetime:
                            self.LifetimeSubscriptionID = package.storeProduct.productIdentifier
                        case .custom:
                            print("Custom Package : \(package.storeProduct.productIdentifier)")
                        case .unknown:
                            print("Unknown Package : \(package.storeProduct.productIdentifier)")
                            
                        }
                        
                        productIDs.append(package.storeProduct.productIdentifier)
                    }
                    
                    if self.WeekSubscriptionID == subProductIds.oneWeekExp || self.OneMonthSubscriptionID == subProductIds.oneMonthExp || self.TwoMonthSubscriptionID == subProductIds.twoMonthExp || self.ThreeMonthSubscriptionID == subProductIds.threeMonthExp || self.SixMonthSubscriptionID == subProductIds.sixMonthExp || self.YearSubscriptionID == subProductIds.oneYearExp || self.LifetimeSubscriptionID == subProductIds.lifeTimeExp {
                        self.isExperimentPrice = true
                    }
                    
                    Purchases.shared.checkTrialOrIntroDiscountEligibility(productIdentifiers: productIDs) { eligibility in
                        
                        if eligibility[self.WeekSubscriptionID]?.status == .eligible {
                            self.isWeekIntroductoryAvailable = true
                        }
                        if eligibility[self.OneMonthSubscriptionID]?.status == .eligible {
                            self.isOneMonthIntroductoryAvailable = true
                        }
                        if eligibility[self.TwoMonthSubscriptionID]?.status == .eligible {
                            self.isTwoMonthIntroductoryAvailable = true
                        }
                        if eligibility[self.ThreeMonthSubscriptionID]?.status == .eligible {
                            self.isThreeMonthIntroductoryAvailable = true
                        }
                        if eligibility[self.SixMonthSubscriptionID]?.status == .eligible {
                            self.isSixMonthIntroductoryAvailable = true
                        }
                        if eligibility[self.YearSubscriptionID]?.status == .eligible {
                            self.isYearIntroductoryAvailable = true
                        }
                        self.GetPackageDetail {
                            complition(true,nil)
                        }
                    }
                }
                else{
                    complition(false,nil)
                }
            }
        }
        else{
            complition(true,nil)
        }
    }
    
    
    private func GetPackageDetail(complition : @escaping()-> Void) {
        
        //One Week
        SubscriptionConst.ActivePlans.one_Week = SubscriptionConst.PlanInfo(plan_Id: WeekSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.week,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: WeekSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: WeekSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: WeekSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: WeekSubscriptionID))

        RevenueCat_Manager.shared.GetPromotionalOfferOfProduct(WeekSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Week.plan_Promotional_Offer = promOffer
        })
        
        //One Month
        SubscriptionConst.ActivePlans.one_Month = SubscriptionConst.PlanInfo(plan_Id: OneMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.onemonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: OneMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: OneMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: OneMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: OneMonthSubscriptionID))

        RevenueCat_Manager.shared.GetPromotionalOfferOfProduct(OneMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Month.plan_Promotional_Offer = promOffer
        })
        
        //Two Month
        SubscriptionConst.ActivePlans.two_Month = SubscriptionConst.PlanInfo(plan_Id: TwoMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.twomonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: TwoMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: TwoMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: TwoMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: TwoMonthSubscriptionID))

        RevenueCat_Manager.shared.GetPromotionalOfferOfProduct(TwoMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.two_Month.plan_Promotional_Offer = promOffer
        })
        
        //Three Month
        SubscriptionConst.ActivePlans.three_Month = SubscriptionConst.PlanInfo(plan_Id: ThreeMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.threemonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: ThreeMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: ThreeMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: ThreeMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: ThreeMonthSubscriptionID))

        RevenueCat_Manager.shared.GetPromotionalOfferOfProduct(ThreeMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.three_Month.plan_Promotional_Offer = promOffer
        })
        
        //Six Month
        SubscriptionConst.ActivePlans.six_Month = SubscriptionConst.PlanInfo(plan_Id: SixMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.sixmonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: SixMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: SixMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: SixMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: SixMonthSubscriptionID))

        RevenueCat_Manager.shared.GetPromotionalOfferOfProduct(SixMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.six_Month.plan_Promotional_Offer = promOffer
        })
        
        //One Year
        SubscriptionConst.ActivePlans.one_Year = SubscriptionConst.PlanInfo(plan_Id: YearSubscriptionID,
                                                                           plan_Type: SubscriptionConst.SubscriptionType.year,
                                                                           plan_Price_String: GetPriceOfProduct_String(productId: YearSubscriptionID),
                                                                           plan_Price: GetPriceOfProduct_Int(productId: YearSubscriptionID),
                                                                           plan_Currancy_Code: GetCurrncyCode(productId: YearSubscriptionID),
                                                                           plan_Free_Trail: GetIntroductioyOfProduct(productId: YearSubscriptionID))
        
        RevenueCat_Manager.shared.GetPromotionalOfferOfProduct(YearSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Year.plan_Promotional_Offer = promOffer
            SubscriptionConst.isGet = true
            complition()
        })
        
        //Life Time
        SubscriptionConst.ActivePlans.life_Time = SubscriptionConst.PlanInfo(plan_Id: LifetimeSubscriptionID,
                                                                             plan_Type: SubscriptionConst.SubscriptionType.lifetime,
                                                                             plan_Price_String: GetPriceOfProduct_String(productId: LifetimeSubscriptionID),
                                                                             plan_Price: GetPriceOfProduct_Int(productId: LifetimeSubscriptionID),
                                                                             plan_Currancy_Code: GetCurrncyCode(productId: LifetimeSubscriptionID),
                                                                             plan_Free_Trail: GetIntroductioyOfProduct(productId: LifetimeSubscriptionID))
    }
    
    // MARK: - Purchase
    public func purchaseProductWithPromo(ProductID : String, promoOffers: PromotionalOffer,completion : @escaping(Bool,CustomerInfo?,Error?,Bool)->Void)
    {
        let p1 = RevenueCat_Manager.AvailableProducts.first { (p) -> Bool in
            return p.storeProduct.productIdentifier ==  ProductID
        }
        if let p1 = p1 {
            Purchases.shared.purchase(package: p1, promotionalOffer: promoOffers) { (trans, info, error, cancelled) in
                if let error = error {
                    if !cancelled {
                        RevenueCat_Manager.purchaseInfo = info
                        Purchase_flag = info?.entitlements.active.count ?? 0 > 0 ? true :  false
                        completion(true,info,error,false)
                    }
                    else{
                        completion(true,info,error,true)
                    }
                } else {
                    completion(true,info,nil,false)
                }
            }
        }
        else{
            completion(false,nil,nil,true)
        }
    }
    
    public func purchaseProduct(ProductID : String,completion : @escaping(Bool,CustomerInfo?,Error?,Bool)->Void)
    {
        let p1 = RevenueCat_Manager.AvailableProducts.first { (p) -> Bool in
            return p.storeProduct.productIdentifier ==  ProductID
        }
        if let p1 = p1 {
            Purchases.shared.purchase(package: p1) { (trans, info, error, cancelled) in
                if let error = error {
                    if !cancelled {
                        RevenueCat_Manager.purchaseInfo = info
                        Purchase_flag = info?.entitlements.active.count ?? 0 > 0 ? true :  false
                        completion(true,info,error,false)
                    } else{
                        completion(true,info,error,true)
                    }
                } else {
                    completion(true,info,nil,false)
                }
            }
        } else {
            completion(false,nil,nil,false)
        }
    }
    
    // MARK: - Restore
    public func restoreProduct(completion : @escaping(Bool,CustomerInfo?,Error?)->Void)
    {
        Purchases.shared.restorePurchases { (purchaseInfo, error) in
            if let error = error {
                completion(false,purchaseInfo,error)
            } else {
                RevenueCat_Manager.purchaseInfo = purchaseInfo
                Purchase_flag = purchaseInfo?.entitlements.active.count ?? 0 > 0 ? true :  false
                completion(true,purchaseInfo,nil)
            }
        }
    }
}

// MARK: - Get Product
extension RevenueCat_Manager {
    private func GetProduct(productId : String)->StoreProduct? {
        let p1 =  RevenueCat_Manager.AvailableProducts.first { (p) -> Bool in
            return p.storeProduct.productIdentifier ==  productId
        }
        return (p1?.storeProduct)
    }
}

// MARK: - Get Price
extension RevenueCat_Manager
{
    private func GetPriceOfProduct_String(productId : String) -> String {
        let product =  RevenueCat_Manager.AvailableProducts.first { (p) -> Bool in
            return p.storeProduct.productIdentifier ==  productId
        }
        let priceString = "\(product?.localizedPriceString ?? "$0.0")".trimmingCharacters(in: .whitespaces)
        return priceString
    }
    
    private func GetPriceOfProduct_Int(productId : String) -> Double {
        let product = self.GetProduct(productId: productId)
        return NSDecimalNumber(decimal: product?.price ?? 0).doubleValue
    }
    
    private func GetCurrncyCode(productId : String) -> String {
        let product = self.GetProduct(productId: productId)
        return product?.priceFormatter?.currencySymbol ?? "$"
    }
}

// MARK: - Get Introductory Price
extension RevenueCat_Manager
{
    private func GetIntroductioyOfProduct(productId : String)-> SubscriptionConst.PlanIntroductoryInfo
    {
        let product = RevenueCat_Manager.shared.GetProduct(productId: productId)
        if let intOffer = product?.introductoryDiscount, (productId == self.WeekSubscriptionID && self.isWeekIntroductoryAvailable) || (productId == self.OneMonthSubscriptionID && self.isOneMonthIntroductoryAvailable) || (productId == self.TwoMonthSubscriptionID && self.isTwoMonthIntroductoryAvailable) || (productId == self.ThreeMonthSubscriptionID && self.isThreeMonthIntroductoryAvailable) || (productId == self.SixMonthSubscriptionID && self.isSixMonthIntroductoryAvailable) || (productId == self.YearSubscriptionID && self.isYearIntroductoryAvailable) {
            
            if intOffer.paymentMode == .payAsYouGo {
                return SubscriptionConst.PlanIntroductoryInfo(isFreeTrail: true,
                                                              paymentMode: .payAsYouGo,
                                                              duration: intOffer.subscriptionPeriod.value,
                                                              unittype: GetUnit(unit: UInt(intOffer.subscriptionPeriod.unit.rawValue)),
                                                              price_String: intOffer.localizedPriceString.trimmingCharacters(in: .whitespaces),
                                                              price: Double(truncating: intOffer.priceDecimalNumber))
            }
            else if intOffer.paymentMode == .payUpFront {
                return SubscriptionConst.PlanIntroductoryInfo(isFreeTrail: true,
                                                              paymentMode: .payUpFront,
                                                              duration: intOffer.subscriptionPeriod.value,
                                                              unittype: GetUnit(unit: UInt(intOffer.subscriptionPeriod.unit.rawValue)),
                                                              price_String: intOffer.localizedPriceString.trimmingCharacters(in: .whitespaces),
                                                              price: Double(truncating: intOffer.priceDecimalNumber))
            }
            else if intOffer.paymentMode == .freeTrial {
                return SubscriptionConst.PlanIntroductoryInfo(isFreeTrail: true,
                                                              paymentMode: .freeTrial,
                                                              duration: intOffer.subscriptionPeriod.value,
                                                              unittype: GetUnit(unit: UInt(intOffer.subscriptionPeriod.unit.rawValue)))
            }
        }
        return SubscriptionConst.PlanIntroductoryInfo(isFreeTrail: false, duration: 0, unittype: "day")
    }
    
    private func GetUnit(unit: UInt) -> String {
        switch unit
        {
        case 0:
            return "days"
        case 1:
            return "week"
        case 2:
            return "month"
        case 3:
            return "year"
        default:
            return "days"
        }
    }
}

//MARK: - Promotional Offer
extension RevenueCat_Manager
{
    private func GetPromotionalOfferOfProduct(_ productId : String, completion : @escaping(SubscriptionConst.PlanPromotionalOffer)->Void)
    {
        if let product = RevenueCat_Manager.shared.GetProduct(productId: productId)
        {
            if let discount = product.discounts.first {
                Purchases.shared.getPromotionalOffer(forProductDiscount: discount,
                                                     product: product) { (promOffer, error) in
                    
                    if let promoOffer = promOffer?.discount {
                        
                        var paymentMode : SubscriptionConst.PaymentType = .none
                        switch promoOffer.paymentMode.rawValue {
                            case 0: paymentMode = .payAsYouGo
                            case 1: paymentMode = .payAsYouGo
                            case 2: paymentMode = .freeTrial
                            default: break
                        }
                        
                        var discountType : SubscriptionConst.DiscountType = .none
                        switch promoOffer.type.rawValue {
                            case 0: discountType = .introductory
                            case 1: discountType = .promotional
                            default: break
                        }
                        
                        let planPromotionalOffer = SubscriptionConst.PlanPromotionalOffer(isPromotionalOffer: true,
                                                                                          promoOffer: promOffer,
                                                                                          identifier: promoOffer.offerIdentifier ?? "",
                                                                                          price: NSDecimalNumber(decimal: promoOffer.price).doubleValue,
                                                                                          price_String: promoOffer.localizedPriceString,
                                                                                          paymentMode: paymentMode,
                                                                                          subscriptionDuration: promoOffer.subscriptionPeriod.value,
                                                                                          subscriptionUnittype: self.GetUnit(unit: UInt(promoOffer.subscriptionPeriod.unit.rawValue)),
                                                                                          numberOfPeriods: promoOffer.numberOfPeriods,
                                                                                          discountType: discountType)
                        completion(planPromotionalOffer)
                    } else {
                        completion(SubscriptionConst.PlanPromotionalOffer(isPromotionalOffer: false))
                    }
                }
            } else {
                completion(SubscriptionConst.PlanPromotionalOffer(isPromotionalOffer: false))
            }
        }
        else {
            completion(SubscriptionConst.PlanPromotionalOffer(isPromotionalOffer: false))
        }
    }
}


// MARK: - Purchase Info
extension RevenueCat_Manager
{
    private func getPurchaseProductInfo(completion:@escaping((Bool,Error?)->Void))
    {
        Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
            if error != nil {
                print("purchaserInfo Errr : \(error?.localizedDescription ?? "")")
                completion(false,error)
                return
            }
        
            if (UserDefaults.standard.value(forKey:"purchase_flag") != nil) && purchaserInfo!.entitlements.active.isEmpty && (UserDefaults.standard.value(forKey: "appOpenFirstTime") == nil)
            {
                Purchases.shared.syncPurchases { (purchaserInfo, error) in
                    if error != nil {
                        print("purchaserInfo Errr : \(error?.localizedDescription ?? "")")
                        completion(false,error)
                        UserDefaults.standard.setValue(true, forKey: "appOpenFirstTime")
                        return
                    }
                    RevenueCat_Manager.purchaseInfo = purchaserInfo!
                    UserDefaults.standard.setValue(true, forKey: "appOpenFirstTime")
                    completion(true,nil)
                }
            }
            else {
                RevenueCat_Manager.purchaseInfo = purchaserInfo!
                completion(true,nil)
            }
        }
        
    }
}
