//
//  Const For Subscription.swift
//  Vehicle_Information
//
//  Created by iOS on 20/01/22.
//  Copyright © 2022 Vasundhara Vision. All rights reserved.
//

import Foundation
import RevenueCat

//MARK: - Purchase flag
public var Purchase_flag: Bool {
    set{
        UserDefaults.standard.set(newValue, forKey: "Purchase_flag")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Purchase_flag") as? Bool {
            return value
        }
        return false
    }
}

//MARK: - Prodcut Ids
public struct SubscriptionProductIds 
{
    public var offer1_oneWeek = ""
    public var offer1_oneMonth = ""
    public var offer1_twoMonth = ""
    public var offer1_threeMonth = ""
    public var offer1_sixMonth = ""
    public var offer1_oneYear = ""
    public var offer1_oneWeek_Discount = ""
    public var offer1_oneMonth_Discount = ""
    public var offer1_twoMonth_Discount = ""
    public var offer1_threeMonth_Discount = ""
    public var offer1_sixMonth_Discount = ""
    public var offer1_oneYear_Discount = ""
    public var offer1_lifeTime = ""
    
    public var offer2_oneWeek = ""
    public var offer2_oneMonth = ""
    public var offer2_twoMonth = ""
    public var offer2_threeMonth = ""
    public var offer2_sixMonth = ""
    public var offer2_oneYear = ""
    public var offer2_oneWeek_Discount = ""
    public var offer2_oneMonth_Discount = ""
    public var offer2_twoMonth_Discount = ""
    public var offer2_threeMonth_Discount = ""
    public var offer2_sixMonth_Discount = ""
    public var offer2_oneYear_Discount = ""
    public var offer2_lifeTime = ""
    
    public var offer3_oneWeek = ""
    public var offer3_oneMonth = ""
    public var offer3_twoMonth = ""
    public var offer3_threeMonth = ""
    public var offer3_sixMonth = ""
    public var offer3_oneYear = ""
    public var offer3_oneWeek_Discount = ""
    public var offer3_oneMonth_Discount = ""
    public var offer3_twoMonth_Discount = ""
    public var offer3_threeMonth_Discount = ""
    public var offer3_sixMonth_Discount = ""
    public var offer3_oneYear_Discount = ""
    public var offer3_lifeTime = ""
}

public enum SubscriptionOfferType
{
    case noOffer
    case offer1
    case offer2
    case offer3
}

//MARK: -
public struct SubscriptionConst
{
    //MARK: - Constant
    struct GeneralConst {
        static var sharedSecret = ""
        static var revanueKitAppId = ""
        static var revanueKitApiKey = ""
    }
    
    //MARK: - Available Plans
    public struct ActivePlans {
        public static var one_Week = PlanInfo()
        public static var one_Month = PlanInfo()
        public static var two_Month = PlanInfo()
        public static var three_Month = PlanInfo()
        public static var six_Month = PlanInfo()
        public static var one_Year = PlanInfo()
        public static var one_Week_Discount = PlanInfo()
        public static var one_Month_Discount = PlanInfo()
        public static var two_Month_Discount = PlanInfo()
        public static var three_Month_Discount = PlanInfo()
        public static var six_Month_Discount = PlanInfo()
        public static var one_Year_Discount = PlanInfo()
        public static var life_Time = PlanInfo()
    }
    
    //MARK: - Plans
    public struct PlanInfo {
        public var plan_Id : String = ""
        public var plan_Type : SubscriptionType = .unknown
        public var plan_Price_String : String = "$0"
        public var plan_Price : Double = 0
        public var plan_Currancy_Code : String = "$"
        public var plan_Free_Trail : PlanIntroductoryInfo = PlanIntroductoryInfo()
        public var plan_Promotional_Offer : PlanPromotionalOffer = PlanPromotionalOffer()
    }
    public enum SubscriptionType {
        case unknown
        case week
        case onemonth
        case twomonth
        case threemonth
        case sixmonth
        case year
        case lifetime
    }
    
    //MARK: - Introductory
    public struct PlanIntroductoryInfo
    {
        public var isFreeTrail : Bool = false
        public var paymentMode : PaymentType = .none
        public var duration : Int = 0
        public var unittype : String = ""
        public var price_String : String = ""
        public var price : Double = 0.0
    }
    
    public enum PaymentType {
        case payAsYouGo
        case payUpFront
        case freeTrial
        case none
    }
    
    public enum DiscountType {
        case introductory
        case promotional
        case none
    }
    
    //MARK: - Promotional
    public struct PlanPromotionalOffer
    {
        public var isPromotionalOffer : Bool = false
        public var promoOffer : PromotionalOffer?
        public var identifier: String = ""
        public var price : Double = 0.0
        public var price_String : String = ""
        public var paymentMode : PaymentType = .none
        public var subscriptionDuration : Int = 0
        public var subscriptionUnittype : String = ""
        public var numberOfPeriods : Int = 0                       // Total period for promotional offer
        public var discountType : DiscountType = .none
    }
    
    public static var isGet = false
}
