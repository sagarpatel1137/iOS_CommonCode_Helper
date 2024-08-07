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
public struct SubscriptionProductIds {
    var oneWeek = ""
    var oneMonth = ""
    var twoMonth = ""
    var threeMonth = ""
    var sixMonth = ""
    var oneYear = ""
    var lifeTime = ""
    
    var oneWeekExp = ""
    var oneMonthExp = ""
    var twoMonthExp = ""
    var threeMonthExp = ""
    var sixMonthExp = ""
    var oneYearExp = ""
    var lifeTimeExp = ""
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
        public static var one_Week : PlanInfo!
        public static var one_Month : PlanInfo!
        public static var two_Month : PlanInfo!
        public static var three_Month : PlanInfo!
        public static var six_Month : PlanInfo!
        public static var one_Year : PlanInfo!
        public static var life_Time : PlanInfo!
    }
    
    //MARK: - Plans
    public struct PlanInfo {
        public var plan_Id : String
        public var plan_Type : SubscriptionType
        public var plan_Price_String : String
        public var plan_Price : Double
        public var plan_Currancy_Code : String
        public var plan_Free_Trail : PlanIntroductoryInfo
        public var plan_Promotional_Offer : PlanPromotionalOffer = PlanPromotionalOffer(isPromotionalOffer: false)
    }
    public enum SubscriptionType {
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
        public var isFreeTrail : Bool
        public var paymentMode : PaymentType = .none
        public var duration : Int
        public var unittype : String
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
        public var isPromotionalOffer : Bool
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
