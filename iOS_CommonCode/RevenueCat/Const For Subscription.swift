//
//  Const For Subscription.swift
//  Vehicle_Information
//
//  Created by iOS on 20/01/22.
//  Copyright © 2022 Vasundhara Vision. All rights reserved.
//

import Foundation
import RevenueCat

public let notificationPurchaseSuccessfully = Notification.Name("InAppPurchaseSuccessfully")

//MARK: - Purchase flag
public var Purchase_flag: Bool {
    set{
        UserDefaults.standard.set(newValue, forKey: "Purchase_flag")
        SetValueToSuitNameUserDefualt(value: newValue, key: "Purchase_flag")
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
    public let offer1_oneWeek: String
    public let offer1_oneMonth: String
    public let offer1_twoMonth: String
    public let offer1_threeMonth: String
    public let offer1_sixMonth: String
    public let offer1_oneYear: String
    public let offer1_oneWeek_Discount: String
    public let offer1_oneMonth_Discount: String
    public let offer1_twoMonth_Discount: String
    public let offer1_threeMonth_Discount: String
    public let offer1_sixMonth_Discount: String
    public let offer1_oneYear_Discount: String
    public let offer1_lifeTime: String
    
    public let offer2_oneWeek: String
    public let offer2_oneMonth: String
    public let offer2_twoMonth: String
    public let offer2_threeMonth: String
    public let offer2_sixMonth: String
    public let offer2_oneYear: String
    public let offer2_oneWeek_Discount: String
    public let offer2_oneMonth_Discount: String
    public let offer2_twoMonth_Discount: String
    public let offer2_threeMonth_Discount: String
    public let offer2_sixMonth_Discount: String
    public let offer2_oneYear_Discount: String
    public let offer2_lifeTime: String
    
    public let offer3_oneWeek: String
    public let offer3_oneMonth: String
    public let offer3_twoMonth: String
    public let offer3_threeMonth: String
    public let offer3_sixMonth: String
    public let offer3_oneYear: String
    public let offer3_oneWeek_Discount: String
    public let offer3_oneMonth_Discount: String
    public let offer3_twoMonth_Discount: String
    public let offer3_threeMonth_Discount: String
    public let offer3_sixMonth_Discount: String
    public let offer3_oneYear_Discount: String
    public let offer3_lifeTime: String
    
    public init(offer1_oneWeek: String = "", offer1_oneMonth: String = "", offer1_twoMonth: String = "", offer1_threeMonth: String = "", offer1_sixMonth: String = "", offer1_oneYear: String = "", offer1_oneWeek_Discount: String = "", offer1_oneMonth_Discount: String = "", offer1_twoMonth_Discount: String = "", offer1_threeMonth_Discount: String = "", offer1_sixMonth_Discount: String = "", offer1_oneYear_Discount: String = "", offer1_lifeTime: String = "", offer2_oneWeek: String = "", offer2_oneMonth: String = "", offer2_twoMonth: String = "", offer2_threeMonth: String = "", offer2_sixMonth: String = "", offer2_oneYear: String = "", offer2_oneWeek_Discount: String = "", offer2_oneMonth_Discount: String = "", offer2_twoMonth_Discount: String = "", offer2_threeMonth_Discount: String = "", offer2_sixMonth_Discount: String = "", offer2_oneYear_Discount: String = "", offer2_lifeTime: String = "", offer3_oneWeek: String = "", offer3_oneMonth: String = "", offer3_twoMonth: String = "", offer3_threeMonth: String = "", offer3_sixMonth: String = "", offer3_oneYear: String = "", offer3_oneWeek_Discount: String = "", offer3_oneMonth_Discount: String = "", offer3_twoMonth_Discount: String = "", offer3_threeMonth_Discount: String = "", offer3_sixMonth_Discount: String = "", offer3_oneYear_Discount: String = "", offer3_lifeTime: String = "")
    {
        self.offer1_oneWeek = offer1_oneWeek
        self.offer1_oneMonth = offer1_oneMonth
        self.offer1_twoMonth = offer1_twoMonth
        self.offer1_threeMonth = offer1_threeMonth
        self.offer1_sixMonth = offer1_sixMonth
        self.offer1_oneYear = offer1_oneYear
        self.offer1_oneWeek_Discount = offer1_oneWeek_Discount
        self.offer1_oneMonth_Discount = offer1_oneMonth_Discount
        self.offer1_twoMonth_Discount = offer1_twoMonth_Discount
        self.offer1_threeMonth_Discount = offer1_threeMonth_Discount
        self.offer1_sixMonth_Discount = offer1_sixMonth_Discount
        self.offer1_oneYear_Discount = offer1_oneYear_Discount
        self.offer1_lifeTime = offer1_lifeTime
        self.offer2_oneWeek = offer2_oneWeek
        self.offer2_oneMonth = offer2_oneMonth
        self.offer2_twoMonth = offer2_twoMonth
        self.offer2_threeMonth = offer2_threeMonth
        self.offer2_sixMonth = offer2_sixMonth
        self.offer2_oneYear = offer2_oneYear
        self.offer2_oneWeek_Discount = offer2_oneWeek_Discount
        self.offer2_oneMonth_Discount = offer2_oneMonth_Discount
        self.offer2_twoMonth_Discount = offer2_twoMonth_Discount
        self.offer2_threeMonth_Discount = offer2_threeMonth_Discount
        self.offer2_sixMonth_Discount = offer2_sixMonth_Discount
        self.offer2_oneYear_Discount = offer2_oneYear_Discount
        self.offer2_lifeTime = offer2_lifeTime
        self.offer3_oneWeek = offer3_oneWeek
        self.offer3_oneMonth = offer3_oneMonth
        self.offer3_twoMonth = offer3_twoMonth
        self.offer3_threeMonth = offer3_threeMonth
        self.offer3_sixMonth = offer3_sixMonth
        self.offer3_oneYear = offer3_oneYear
        self.offer3_oneWeek_Discount = offer3_oneWeek_Discount
        self.offer3_oneMonth_Discount = offer3_oneMonth_Discount
        self.offer3_twoMonth_Discount = offer3_twoMonth_Discount
        self.offer3_threeMonth_Discount = offer3_threeMonth_Discount
        self.offer3_sixMonth_Discount = offer3_sixMonth_Discount
        self.offer3_oneYear_Discount = offer3_oneYear_Discount
        self.offer3_lifeTime = offer3_lifeTime
    }
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
    public enum SubscriptionType : String {
        case unknown = "Unknown"
        case week = "Week"
        case onemonth = "One Month"
        case twomonth = "Two Month"
        case threemonth = "Three Month"
        case sixmonth = "Six Month"
        case year = "Year"
        case lifetime = "Lifetime"
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
