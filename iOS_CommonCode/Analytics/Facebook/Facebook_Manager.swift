//
//  Facebook_Manager.swift
//  CommonCode_iOS
//
//  Created by IOS on 14/06/24.
//

import FBSDKCoreKit

public class Facebook_Manager: NSObject {
    
    public static func initialize(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}

public class Facebook_Events
{
    public static func addEventforSubscription(plan: SubscriptionConst.PlanInfo)
    {
        if plan.plan_Free_Trail.isFreeTrail {
            addEvents(eventName: "Trial")
        } else {
            addEvents(eventName: "Subscription")
        }
    }
    
    public static func addEvents(eventName :String)
    {
        let event = AppEvents.Name(eventName)
        AppEvents.shared.logEvent(event)
    }
}
