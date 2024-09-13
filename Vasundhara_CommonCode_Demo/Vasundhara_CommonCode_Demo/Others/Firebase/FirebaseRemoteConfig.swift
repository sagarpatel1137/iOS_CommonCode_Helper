//
//  RemoteConfig.swift
//  Voice GPS
//
//  Created by iOS on 04/10/22.
//

import Foundation
import Firebase
import FirebaseRemoteConfig
import SwiftyJSON
import Alamofire

// -------------------------------------------------
//MARK: Firebase RemoteConfig
// -------------------------------------------------

class FirebaseRemote : NSObject {
    
    static let shared : FirebaseRemote = FirebaseRemote()
    static let remoteConfigKey = "VOICE_CHANGER"
    var remoteConfig: RemoteConfig!
    var isFetched = false
    
    var subShowConfig : SubShowConfig {
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "SubShowConfig")
            }        }
        get {
            if let data = UserDefaults.standard.object(forKey: "SubShowConfig") as? Data {
                let decoder = JSONDecoder()
                if let array = try? decoder.decode(SubShowConfig.self, from: data) {
                    return array
                }
            }
            return SubShowConfig()
        }
    }
    
    var initialOpenConfig : InitialOpenConfig {
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "initialOpenConfig")
            }
        }
        get {
            if let data = UserDefaults.standard.object(forKey: "initialOpenConfig") as? Data {
                let decoder = JSONDecoder()
                if let array = try? decoder.decode(InitialOpenConfig.self, from: data) {
                    return array
                }
            }
            return InitialOpenConfig()
        }
    }
    
    var adShowConfig : AdShowConfig {
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "adShowConfig")
            }
        }
        get {
            if let data = UserDefaults.standard.object(forKey: "adShowConfig") as? Data {
                let decoder = JSONDecoder()
                if let array = try? decoder.decode(AdShowConfig.self, from: data) {
                    return array
                }
            }
            return AdShowConfig()
        }
    }
    
    var ratingConfig : RatingConfig {
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "RatingConfig")
            }        }
        get {
            if let data = UserDefaults.standard.object(forKey: "RatingConfig") as? Data {
                let decoder = JSONDecoder()
                if let array = try? decoder.decode(RatingConfig.self, from: data) {
                    return array
                }
            }
            return RatingConfig()
        }
    }
    
    //MARK: -
    func startRemoteConfig(){
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        fetchConfig()
    }
    
    private func fetchConfig() {
        remoteConfig.fetch { (status, error) -> Void in
            self.setValues()
        }
    }
    
    private func setValues(){
        self.remoteConfig.activate { changed, error in
            self.setRemoteConfigValues()
        }
    }
    
    private func setRemoteConfigValues(){
        if let jsonData = self.remoteConfig[FirebaseRemote.remoteConfigKey].jsonValue {
            
            isFetched = true
            
            let dataJSON = JSON(jsonData)
            
            let adShowData = dataJSON["AdShowConfig"]
            self.adShowConfig = AdShowConfig(subscriptionClose: adShowData["subscription_Close"].boolValue,
                                             intialSubscriptionClose: adShowData["intial_Subscription_Close"].boolValue)
            
            let ratingData = dataJSON["RatingConfig"]
            self.ratingConfig = RatingConfig(homeOpen: ratingData["home_Open"].intValue)
            
            let subConfigData = dataJSON["SubShowConfig"]
            self.subShowConfig = SubShowConfig(subsciptionContinueBtnText: subConfigData["subsciption_Continue_Btn_Text"].intValue,
                                               initialSubscriptionDiscountOpen:  subConfigData["initial_Sub_Discount_Popup_Open"].arrayObject as? [Int] ?? SubShowConfig().initialSubscriptionDiscountOpen)
            
            let initialOpenData = dataJSON["InitialOpenConfig"]
            self.initialOpenConfig = InitialOpenConfig(intialAppOpen: initialOpenData["intial_Open_Flow"].arrayObject as? [Int] ?? InitialOpenConfig().intialAppOpen)
        }
        else {
            self.adShowConfig = AdShowConfig()
            self.ratingConfig = RatingConfig()
            self.subShowConfig = SubShowConfig()
            self.initialOpenConfig = InitialOpenConfig()
        }
    }
}

struct SubShowConfig : Codable {
    var subsciptionContinueBtnText = 0
    // 0 - Continue
    // 1 - Start My Free Trial
    // 2 - Try 3 days for $0
    
    var initialSubscriptionDiscountOpen = [1]
    // 1 - Subscription
    // Other - Null
}

struct AdShowConfig : Codable {
    var subscriptionClose : Bool = true 
    var intialSubscriptionClose : Bool = false
}

struct RatingConfig : Codable {
    var homeOpen : Int = 3
}

struct InitialOpenConfig : Codable {
    var intialAppOpen = [1]
    // 0 - Null
    // 1 - Subscription
    // 2 - AppOpen Ad
    // 3 - Interstitial Ad
}
