//
//  RevenueCat_Manager.swift
//  Sample_Project
//
//  Created by IOS on 28/03/24.
//

import UIKit
import RevenueCat
import Alamofire

public class RevenueCat_Manager : NSObject {
    
    public static var shared = RevenueCat_Manager()
    
    private static var AvailableProducts = [Package]()
    private static var purchaseInfo : CustomerInfo?
    
    private var WeekSubscriptionID = String()
    private var OneMonthSubscriptionID = String()
    private var TwoMonthSubscriptionID = String()
    private var ThreeMonthSubscriptionID = String()
    private var SixMonthSubscriptionID = String()
    private var YearSubscriptionID = String()
    private var WeekDiscountSubscriptionID = String()
    private var OneMonthDiscountSubscriptionID = String()
    private var TwoMonthDiscountSubscriptionID = String()
    private var ThreeMonthDiscountSubscriptionID = String()
    private var SixMonthDiscountSubscriptionID = String()
    private var YearDiscountSubscriptionID = String()
    private var LifetimeSubscriptionID = String()
    
    public var isWeekIntroductoryAvailable = false
    public var isOneMonthIntroductoryAvailable = false
    public var isTwoMonthIntroductoryAvailable = false
    public var isThreeMonthIntroductoryAvailable = false
    public var isSixMonthIntroductoryAvailable = false
    public var isYearIntroductoryAvailable = false
    public var isWeekDiscountIntroductoryAvailable = false
    public var isOneMonthDiscountIntroductoryAvailable = false
    public var isTwoMonthDiscountIntroductoryAvailable = false
    public var isThreeMonthDiscountIntroductoryAvailable = false
    public var isSixMonthDiscountIntroductoryAvailable = false
    public var isYearDiscountIntroductoryAvailable = false

    private var subProductIds = SubscriptionProductIds()
    
    public var isOfferType: SubscriptionOfferType = .noOffer
    
    
    //MARK: -  Initialise RevenueCat
    /// - Parameters:
    ///   - APIKey: RevenueCat APIKey
    ///   - AppId: RevenueCat AppId
    ///   - sharedSecret: sharedSecret of the application
    ///   - productIds: Product ids for offer code to find out for which offers fetched from revenuecat
    public func initialiseRevenueCat(APIKey: String, AppId: String = "", sharedSecret: String = "", productIds: SubscriptionProductIds?) {
    
        Purchases.configure(with: Configuration.Builder(withAPIKey: APIKey)
            .with(storeKitVersion: .storeKit2)
            .build()
        )
        
        SubscriptionConst.GeneralConst.revanueKitApiKey = APIKey
        SubscriptionConst.GeneralConst.revanueKitAppId = AppId
        SubscriptionConst.GeneralConst.sharedSecret = sharedSecret
        
        subProductIds = productIds ?? SubscriptionProductIds()
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
                            
                            if SubscriptionConst.isGet {
                                print("Vasundhara 🏢 - Revenue Package Fetched Successfully 🟢🟢🟢")
                            } else {
                                print("Vasundhara 🏢 - Revenue Package Fetched Failed 🔴🔴🔴")
                                self.checkForNetworkReachability()
                            }
                        }
                    } else {
                        completion()
                        self.checkForNetworkReachability()
                    }
                }
            }
        }
        else {
            completion()
            self.checkForNetworkReachability()
        }
    }
    
    //MARK: - Get Offerings
    public func GetAllAvailablePackages(complition : @escaping(Bool,Error?)-> Void)
    {
        if RevenueCat_Manager.AvailableProducts.count == 0
        {
            Purchases.shared.getOfferings { [self] (offerings, error) in
                
                if let err = error {
                    print("Vasundhara 🏢 - Revenue Get Package Error ⚠️⚠️⚠️: \(err)")
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
                            self.YearSubscriptionID = package.storeProduct.productIdentifier
                        case .lifetime:
                            self.LifetimeSubscriptionID = package.storeProduct.productIdentifier
                        case .custom:
                            if (package.storeProduct.productIdentifier == subProductIds.offer1_oneWeek_Discount || package.storeProduct.productIdentifier == subProductIds.offer2_oneWeek_Discount || package.storeProduct.productIdentifier == subProductIds.offer3_oneWeek_Discount) {
                                
                                self.WeekDiscountSubscriptionID = package.storeProduct.productIdentifier
                            }
                            else if (package.storeProduct.productIdentifier == subProductIds.offer1_oneMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer2_oneMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer3_oneMonth_Discount) {
                                
                                self.OneMonthDiscountSubscriptionID = package.storeProduct.productIdentifier
                            }
                            else if (package.storeProduct.productIdentifier == subProductIds.offer1_twoMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer2_twoMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer3_twoMonth_Discount) {
                                
                                self.TwoMonthDiscountSubscriptionID = package.storeProduct.productIdentifier
                            }
                            else if (package.storeProduct.productIdentifier == subProductIds.offer1_threeMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer2_threeMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer3_threeMonth_Discount) {
                                
                                self.ThreeMonthDiscountSubscriptionID = package.storeProduct.productIdentifier
                            }
                            else if (package.storeProduct.productIdentifier == subProductIds.offer1_sixMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer2_sixMonth_Discount || package.storeProduct.productIdentifier == subProductIds.offer3_sixMonth_Discount) {
                                
                                self.SixMonthDiscountSubscriptionID = package.storeProduct.productIdentifier
                            }
                            else if (package.storeProduct.productIdentifier == subProductIds.offer1_oneYear_Discount || package.storeProduct.productIdentifier == subProductIds.offer2_oneYear_Discount || package.storeProduct.productIdentifier == subProductIds.offer3_oneYear_Discount) {
                                
                                self.YearDiscountSubscriptionID = package.storeProduct.productIdentifier
                            }
                        case .unknown:
                            print("Unknown Package : \(package.storeProduct.productIdentifier)")
                        }
                        productIDs.append(package.storeProduct.productIdentifier)
                    }
                    
                    self.checkOfferType()
                    
                    Purchases.shared.checkTrialOrIntroDiscountEligibility(productIdentifiers: productIDs) { eligibility in
                        
                        if eligibility[self.WeekSubscriptionID]?.status == .eligible {
                            self.isWeekIntroductoryAvailable = true
                        }
                        else if eligibility[self.OneMonthSubscriptionID]?.status == .eligible {
                            self.isOneMonthIntroductoryAvailable = true
                        }
                        else if eligibility[self.TwoMonthSubscriptionID]?.status == .eligible {
                            self.isTwoMonthIntroductoryAvailable = true
                        }
                        else if eligibility[self.ThreeMonthSubscriptionID]?.status == .eligible {
                            self.isThreeMonthIntroductoryAvailable = true
                        }
                        else if eligibility[self.SixMonthSubscriptionID]?.status == .eligible {
                            self.isSixMonthIntroductoryAvailable = true
                        }
                        else if eligibility[self.YearSubscriptionID]?.status == .eligible {
                            self.isYearIntroductoryAvailable = true
                        }
                        else if eligibility[self.WeekDiscountSubscriptionID]?.status == .eligible {
                            self.isWeekDiscountIntroductoryAvailable = true
                        }
                        else if eligibility[self.OneMonthDiscountSubscriptionID]?.status == .eligible {
                            self.isOneMonthDiscountIntroductoryAvailable = true
                        }
                        else if eligibility[self.TwoMonthDiscountSubscriptionID]?.status == .eligible {
                            self.isTwoMonthDiscountIntroductoryAvailable = true
                        }
                        else if eligibility[self.ThreeMonthDiscountSubscriptionID]?.status == .eligible {
                            self.isThreeMonthDiscountIntroductoryAvailable = true
                        }
                        else if eligibility[self.SixMonthDiscountSubscriptionID]?.status == .eligible {
                            self.isSixMonthDiscountIntroductoryAvailable = true
                        }
                        else if eligibility[self.YearDiscountSubscriptionID]?.status == .eligible {
                            self.isYearDiscountIntroductoryAvailable = true
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
    
    // MARK: - Purchase with Promo
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
    
    // MARK: - Purchase
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

// MARK: - Package Details
extension RevenueCat_Manager
{
    private func GetPackageDetail(complition : @escaping()-> Void) {
        
        //One Week
        SubscriptionConst.ActivePlans.one_Week = SubscriptionConst.PlanInfo(plan_Id: WeekSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.week,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: WeekSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: WeekSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: WeekSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: WeekSubscriptionID))
        
        GetPromotionalOfferOfProduct(WeekSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Week.plan_Promotional_Offer = promOffer
        })
        
        //One Month
        SubscriptionConst.ActivePlans.one_Month = SubscriptionConst.PlanInfo(plan_Id: OneMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.onemonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: OneMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: OneMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: OneMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: OneMonthSubscriptionID))

        GetPromotionalOfferOfProduct(OneMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Month.plan_Promotional_Offer = promOffer
        })
        
        //Two Month
        SubscriptionConst.ActivePlans.two_Month = SubscriptionConst.PlanInfo(plan_Id: TwoMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.twomonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: TwoMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: TwoMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: TwoMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: TwoMonthSubscriptionID))

        GetPromotionalOfferOfProduct(TwoMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.two_Month.plan_Promotional_Offer = promOffer
        })
        
        //Three Month
        SubscriptionConst.ActivePlans.three_Month = SubscriptionConst.PlanInfo(plan_Id: ThreeMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.threemonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: ThreeMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: ThreeMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: ThreeMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: ThreeMonthSubscriptionID))

        GetPromotionalOfferOfProduct(ThreeMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.three_Month.plan_Promotional_Offer = promOffer
        })
        
        //Six Month
        SubscriptionConst.ActivePlans.six_Month = SubscriptionConst.PlanInfo(plan_Id: SixMonthSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.sixmonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: SixMonthSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: SixMonthSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: SixMonthSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: SixMonthSubscriptionID))

        GetPromotionalOfferOfProduct(SixMonthSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.six_Month.plan_Promotional_Offer = promOffer
        })
        
        //One Year
        SubscriptionConst.ActivePlans.one_Year = SubscriptionConst.PlanInfo(plan_Id: YearSubscriptionID,
                                                                           plan_Type: SubscriptionConst.SubscriptionType.year,
                                                                           plan_Price_String: GetPriceOfProduct_String(productId: YearSubscriptionID),
                                                                           plan_Price: GetPriceOfProduct_Int(productId: YearSubscriptionID),
                                                                           plan_Currancy_Code: GetCurrncyCode(productId: YearSubscriptionID),
                                                                           plan_Free_Trail: GetIntroductioyOfProduct(productId: YearSubscriptionID))
        
        GetPromotionalOfferOfProduct(YearSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Year.plan_Promotional_Offer = promOffer
        })
        
        
        //One Week Discount
        SubscriptionConst.ActivePlans.one_Week_Discount = SubscriptionConst.PlanInfo(plan_Id: WeekDiscountSubscriptionID,
                                                                                     plan_Type: SubscriptionConst.SubscriptionType.week,
                                                                                     plan_Price_String: GetPriceOfProduct_String(productId: WeekDiscountSubscriptionID),
                                                                                     plan_Price: GetPriceOfProduct_Int(productId: WeekDiscountSubscriptionID),
                                                                                     plan_Currancy_Code: GetCurrncyCode(productId: WeekDiscountSubscriptionID),
                                                                                     plan_Free_Trail: GetIntroductioyOfProduct(productId: WeekDiscountSubscriptionID))

        GetPromotionalOfferOfProduct(WeekDiscountSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Week_Discount.plan_Promotional_Offer = promOffer
        })
        
        //One Month Discount
        SubscriptionConst.ActivePlans.one_Month_Discount = SubscriptionConst.PlanInfo(plan_Id: OneMonthDiscountSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.onemonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: OneMonthDiscountSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: OneMonthDiscountSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: OneMonthDiscountSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: OneMonthDiscountSubscriptionID))

        GetPromotionalOfferOfProduct(OneMonthDiscountSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Month_Discount.plan_Promotional_Offer = promOffer
        })
        
        //Two Month Discount
        SubscriptionConst.ActivePlans.two_Month_Discount = SubscriptionConst.PlanInfo(plan_Id: TwoMonthDiscountSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.twomonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: TwoMonthDiscountSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: TwoMonthDiscountSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: TwoMonthDiscountSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: TwoMonthDiscountSubscriptionID))

        GetPromotionalOfferOfProduct(TwoMonthDiscountSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.two_Month_Discount.plan_Promotional_Offer = promOffer
        })
        
        //Three Month Discount
        SubscriptionConst.ActivePlans.three_Month_Discount = SubscriptionConst.PlanInfo(plan_Id: ThreeMonthDiscountSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.threemonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: ThreeMonthDiscountSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: ThreeMonthDiscountSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: ThreeMonthDiscountSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: ThreeMonthDiscountSubscriptionID))

        GetPromotionalOfferOfProduct(ThreeMonthDiscountSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.three_Month_Discount.plan_Promotional_Offer = promOffer
        })
        
        //Six Month Discount
        SubscriptionConst.ActivePlans.six_Month_Discount = SubscriptionConst.PlanInfo(plan_Id: SixMonthDiscountSubscriptionID,
                                                                            plan_Type: SubscriptionConst.SubscriptionType.sixmonth,
                                                                            plan_Price_String: GetPriceOfProduct_String(productId: SixMonthDiscountSubscriptionID),
                                                                            plan_Price: GetPriceOfProduct_Int(productId: SixMonthDiscountSubscriptionID),
                                                                            plan_Currancy_Code: GetCurrncyCode(productId: SixMonthDiscountSubscriptionID),
                                                                            plan_Free_Trail: GetIntroductioyOfProduct(productId: SixMonthDiscountSubscriptionID))

        GetPromotionalOfferOfProduct(SixMonthDiscountSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.six_Month_Discount.plan_Promotional_Offer = promOffer
        })
        
        //One Year Discount
        SubscriptionConst.ActivePlans.one_Year_Discount = SubscriptionConst.PlanInfo(plan_Id: YearDiscountSubscriptionID,
                                                                           plan_Type: SubscriptionConst.SubscriptionType.year,
                                                                           plan_Price_String: GetPriceOfProduct_String(productId: YearDiscountSubscriptionID),
                                                                           plan_Price: GetPriceOfProduct_Int(productId: YearDiscountSubscriptionID),
                                                                           plan_Currancy_Code: GetCurrncyCode(productId: YearDiscountSubscriptionID),
                                                                           plan_Free_Trail: GetIntroductioyOfProduct(productId: YearDiscountSubscriptionID))
        
        GetPromotionalOfferOfProduct(YearDiscountSubscriptionID, completion: { promOffer in
            SubscriptionConst.ActivePlans.one_Year_Discount.plan_Promotional_Offer = promOffer
            SubscriptionConst.isGet = true
            complition()
        })
        
        
        //LifeTime
        SubscriptionConst.ActivePlans.life_Time = SubscriptionConst.PlanInfo(plan_Id: LifetimeSubscriptionID,
                                                                             plan_Type: SubscriptionConst.SubscriptionType.lifetime,
                                                                             plan_Price_String: GetPriceOfProduct_String(productId: LifetimeSubscriptionID),
                                                                             plan_Price: GetPriceOfProduct_Int(productId: LifetimeSubscriptionID),
                                                                             plan_Currancy_Code: GetCurrncyCode(productId: LifetimeSubscriptionID),
                                                                             plan_Free_Trail: GetIntroductioyOfProduct(productId: LifetimeSubscriptionID))
    }
    
}

// MARK: - Network Reachability
extension RevenueCat_Manager
{
    private func checkForNetworkReachability()
    {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening( onUpdatePerforming: { [self] _ in
            if let isNetworkReachable = reachabilityManager?.isReachable,
               isNetworkReachable == true
            {
                if !SubscriptionConst.isGet {
                    
                    self.GetAllAvailablePackages { (state,err) in
                        
                        if SubscriptionConst.isGet {
                            print("Vasundhara 🏢 - Revenue Package Fetched Successfully 🟢🟢🟢")
                            reachabilityManager?.stopListening()
                        } else {
                            print("Vasundhara 🏢 - Revenue Package Fetched Failed 🔴🔴🔴")
                        }
                    }
                }
            }
        })
    }
}

//MARK: - Offer Type
extension RevenueCat_Manager
{
    private func checkOfferType() {
        
        if self.WeekSubscriptionID == subProductIds.offer1_oneWeek || self.OneMonthSubscriptionID == subProductIds.offer1_oneMonth || self.TwoMonthSubscriptionID == subProductIds.offer1_twoMonth || self.ThreeMonthSubscriptionID == subProductIds.offer1_threeMonth || self.SixMonthSubscriptionID == subProductIds.offer1_sixMonth || self.YearSubscriptionID == subProductIds.offer1_oneYear || self.LifetimeSubscriptionID == subProductIds.offer1_lifeTime
        {
            self.isOfferType = .offer1
        }
        else if self.WeekSubscriptionID == subProductIds.offer2_oneWeek || self.OneMonthSubscriptionID == subProductIds.offer2_oneMonth || self.TwoMonthSubscriptionID == subProductIds.offer2_twoMonth || self.ThreeMonthSubscriptionID == subProductIds.offer2_threeMonth || self.SixMonthSubscriptionID == subProductIds.offer2_sixMonth || self.YearSubscriptionID == subProductIds.offer2_oneYear || self.LifetimeSubscriptionID == subProductIds.offer2_lifeTime
        {
            self.isOfferType = .offer2
        }
        else if self.WeekSubscriptionID == subProductIds.offer3_oneWeek || self.OneMonthSubscriptionID == subProductIds.offer3_oneMonth || self.TwoMonthSubscriptionID == subProductIds.offer3_twoMonth || self.ThreeMonthSubscriptionID == subProductIds.offer3_threeMonth || self.SixMonthSubscriptionID == subProductIds.offer3_sixMonth || self.YearSubscriptionID == subProductIds.offer3_oneYear || self.LifetimeSubscriptionID == subProductIds.offer3_lifeTime
        {
            self.isOfferType = .offer3
        }
    }
}

// MARK: - Get Product
extension RevenueCat_Manager 
{
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
        /*let product =  RevenueCat_Manager.AvailableProducts.first { (p) -> Bool in
            return p.storeProduct.productIdentifier ==  productId
        }
        let priceString = "\(product?.localizedPriceString ?? "$0.0")".trimmingCharacters(in: .whitespaces)
        return priceString
        */
        
        let currCode = GetCurrncyCode(productId: productId)
        let price = GetPriceOfProduct_Int(productId: productId)
        if GetDecimalPart(of: price) > 0 {
            return "\(currCode)" + String(format:"%.2f", price)
        } else {
            return "\(currCode)" + String(format:"%.f", price)
        }
    }
    
    private func GetPriceOfProduct_Int(productId : String) -> Double {
        let product = self.GetProduct(productId: productId)
        return NSDecimalNumber(decimal: product?.price ?? 0).doubleValue
    }
    
    private func GetCurrncyCode(productId : String) -> String {
        let product = self.GetProduct(productId: productId)
        return product?.priceFormatter?.currencySymbol ?? "$"
    }
    
    public func GetDecimalPart(of value: Double) -> Double {
        let integerPart = floor(value)
        let decimalPart = value - integerPart
        return decimalPart
    }
}

// MARK: - Get Introductory Price
extension RevenueCat_Manager
{
    private func GetIntroductioyOfProduct(productId : String)-> SubscriptionConst.PlanIntroductoryInfo
    {
        let product = GetProduct(productId: productId)
        if let intOffer = product?.introductoryDiscount, checkIsIntroOfferAvailable(product: productId) {
            
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
        return SubscriptionConst.PlanIntroductoryInfo(isFreeTrail: false, duration: 0, unittype: "days")
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
    
    private func checkIsIntroOfferAvailable(product: String) -> Bool {
        
        let isAvailable = (product == self.WeekSubscriptionID && self.isWeekIntroductoryAvailable) ||
                          (product == self.OneMonthSubscriptionID && self.isOneMonthIntroductoryAvailable) ||
                          (product == self.TwoMonthSubscriptionID && self.isTwoMonthIntroductoryAvailable) ||
                          (product == self.ThreeMonthSubscriptionID && self.isThreeMonthIntroductoryAvailable) ||
                          (product == self.SixMonthSubscriptionID && self.isSixMonthIntroductoryAvailable) ||
                          (product == self.YearSubscriptionID && self.isYearIntroductoryAvailable) ||
                          (product == self.WeekDiscountSubscriptionID && self.isWeekDiscountIntroductoryAvailable) ||
                          (product == self.OneMonthDiscountSubscriptionID && self.isOneMonthDiscountIntroductoryAvailable) ||
                          (product == self.TwoMonthDiscountSubscriptionID && self.isTwoMonthDiscountIntroductoryAvailable) ||
                          (product == self.ThreeMonthDiscountSubscriptionID && self.isThreeMonthDiscountIntroductoryAvailable) ||
                          (product == self.SixMonthDiscountSubscriptionID && self.isSixMonthDiscountIntroductoryAvailable) ||
                          (product == self.YearDiscountSubscriptionID && self.isYearDiscountIntroductoryAvailable)
        
        return isAvailable
    }
}

//MARK: - Promotional Offer
extension RevenueCat_Manager
{
    private func GetPromotionalOfferOfProduct(_ productId : String, completion : @escaping(SubscriptionConst.PlanPromotionalOffer)->Void)
    {
        if let product = GetProduct(productId: productId)
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
                        
                        let currCode = self.GetCurrncyCode(productId: productId)
                        let price = NSDecimalNumber(decimal: promoOffer.price).doubleValue
                        var priceStr = ""
                        if self.GetDecimalPart(of: price) > 0 { 
                            priceStr = "\(currCode)" + String(format:"%.2f", price)
                        } else {
                            priceStr = "\(currCode)" + String(format:"%.f", price)
                        }
                        
                        let planPromotionalOffer = SubscriptionConst.PlanPromotionalOffer(isPromotionalOffer: true,
                                                                                          promoOffer: promOffer,
                                                                                          identifier: promoOffer.offerIdentifier ?? "",
                                                                                          price: NSDecimalNumber(decimal: promoOffer.price).doubleValue,
                                                                                          price_String: priceStr /*promoOffer.localizedPriceString*/,
                                                                                          paymentMode: paymentMode,
                                                                                          subscriptionDuration: promoOffer.subscriptionPeriod.value,
                                                                                          subscriptionUnittype: self.GetUnit(unit: UInt(promoOffer.subscriptionPeriod.unit.rawValue)),
                                                                                          numberOfPeriods: promoOffer.numberOfPeriods,
                                                                                          discountType: discountType)
                        completion(planPromotionalOffer)
                    } else {
                        completion(SubscriptionConst.PlanPromotionalOffer())
                    }
                }
            } else {
                completion(SubscriptionConst.PlanPromotionalOffer())
            }
        }
        else {
            completion(SubscriptionConst.PlanPromotionalOffer())
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
                print("Vasundhara 🏢 - Revenue PurchaserInfo Error ⚠️⚠️⚠️: \(error!)")
                completion(false,error)
                return
            }
        
            if (UserDefaults.standard.value(forKey:"Purchase_flag") != nil) && purchaserInfo!.entitlements.active.isEmpty && (UserDefaults.standard.value(forKey: "appOpenFirstTime") == nil)
            {
                Purchases.shared.syncPurchases { (purchaserInfo, error) in
                    if error != nil {
                        print("Vasundhara 🏢 - Revenue PurchaserInfo Sync Error ⚠️⚠️⚠️: \(error!)")
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
