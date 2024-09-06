//
//  TikTok_Manager.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import TikTokBusinessSDK

public class TikTok_Manager
{
    public class func initialize(withAppId appId: String, TikTokId apiId: String, isDebug: Bool = false)
    {
        if !UIDevice.current.isSimulator {
            let config = TikTokConfig(appId: appId, tiktokAppId: apiId)
            if isDebug {
                config?.enableDebugMode()
            }
            config?.disableSKAdNetworkSupport()
            TikTokBusiness.initializeSdk(config)
        }
    }
}

public class TikTok_Events
{
    public class func tikTokFreeTrialEvent(plan: SubscriptionConst.PlanInfo)
    {
        let trailEvent = TikTokBaseEvent(name: TTEventName.startTrial.rawValue)
        TikTokBusiness.trackTTEvent(trailEvent)
    }

    public class func tikTokPurchaseSuccessEvent(plan: SubscriptionConst.PlanInfo)
    {
        let customEvent = TikTokPurchaseEvent(name: "Purchase")
        customEvent.addProperty(withKey: "currency", value: plan.plan_Currancy_Code)
        customEvent.addProperty(withKey: "value", value: plan.plan_Price_String)
        customEvent.addProperty(withKey: "price", value: plan.plan_Price)
        customEvent.addProperty(withKey: "content_id", value: plan.plan_Id)
        customEvent.addProperty(withKey: "content_type", value: plan.plan_Type)
        TikTokBusiness.trackTTEvent(customEvent)
    }
}
