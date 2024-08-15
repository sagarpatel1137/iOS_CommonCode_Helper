//
//  OneSignal_Handler.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import OneSignalFramework
import RevenueCat

public class OneSignal_Handler {
    
    private func initialize(oneSignalId: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    {
        basicSetupForOneSignalPlayerId()
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize(oneSignalId, withLaunchOptions: launchOptions)
        
        if let extId = OneSignalId_ExternalId {
            OneSignal.login(extId)
        } else {
            OneSignalId_ExternalId = UUID().uuidString
            OneSignal.login(OneSignalId_ExternalId!)
        }
        
        if let onesignalId = OneSignal.User.onesignalId {
            if OneSignal.User.externalId == OneSignalId_ExternalId {
                Purchases.shared.attribution.setOnesignalUserID(onesignalId)
                Purchases.shared.syncAttributesAndOfferingsIfNeeded { offeting, error in
                }
            }
        }
    }
    
    private func basicSetupForOneSignalPlayerId() {
        OneSignal.User.addObserver(self)
        OneSignal.User.pushSubscription.addObserver(self)
    }
}

extension OneSignal_Handler: OSUserStateObserver {
    
    public func onUserStateDidChange(state: OSUserChangedState) {
        let onesignalId = state.current.onesignalId
        let externalId = state.current.externalId
        
        if let onesignalId, externalId == OneSignalId_ExternalId  {
            OneSignalId_UserState = onesignalId
            Purchases.shared.attribution.setOnesignalUserID(onesignalId)
            Purchases.shared.syncAttributesAndOfferingsIfNeeded { offeting, error in
            }
        }
    }
}

extension OneSignal_Handler : OSPushSubscriptionObserver {
    
    public func onPushSubscriptionDidChange(state: OSPushSubscriptionChangedState) {
        if let oneSignalId = state.current.id {
            print("Vasundhara 🏢 - OneSignal PlayerId : \(oneSignalId)")
            OneSignalId_PlayerId = oneSignalId
        }
    }
}


//User Defaults
public var OneSignalId_PlayerId : String? {
    set {
        UserDefaults.standard.setValue(newValue, forKey: "oneSignalPlayerId")
    }
    get{
        UserDefaults.standard.value(forKey: "oneSignalPlayerId") as? String
    }
}

public var OneSignalId_UserState : String? {
    set {
        UserDefaults.standard.setValue(newValue, forKey: "OneSignalId_UserState")
    }
    get{
        UserDefaults.standard.value(forKey: "OneSignalId_UserState") as? String
    }
}

public var OneSignalId_ExternalId : String? {
    set {
        UserDefaults.standard.setValue(newValue, forKey: "OneSignalId_ExternalId")
    }
    get{
        UserDefaults.standard.value(forKey: "OneSignalId_ExternalId") as? String
    }
}
