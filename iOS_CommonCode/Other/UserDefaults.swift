//
//  UserDefaults.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//
import UIKit

//public var Pod_AppSuiteName : String {
//    set{
//        UserDefaults.standard.set(newValue, forKey: Pod_AppPackageName)
//    }
//    get {
//        if let value = UserDefaults.standard.value(forKey: Pod_AppPackageName) as? String{
//            return value
//        }
//        return ""
//    }
//}

public var Pod_AppSuiteName : String = ""

public var Pod_AppVersionCode : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppVersionCode")
        SetValueToSuitNameUserDefualt(value: Pod_AppVersionCode, key: "Pod_AppVersionCode")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppVersionCode") as? String{
            return value
        }
        return ""
    }
}

public var Pod_AppPackageName : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppPackageName")
        SetValueToSuitNameUserDefualt(value: Pod_AppPackageName, key: "Pod_AppPackageName")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppPackageName") as? String{
            return value
        }
        return ""
    }
}

public var Pod_AppPrivacyPolicyURL : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppPrivacyPolicyURL")
        SetValueToSuitNameUserDefualt(value: Pod_AppPrivacyPolicyURL, key: "Pod_AppPrivacyPolicyURL")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppPrivacyPolicyURL") as? String{
            return value
        }
        return ""
    }
}

public var Pod_AppTermsAnsConditionURL : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppTermsAnsConditionURL")
        SetValueToSuitNameUserDefualt(value: Pod_AppTermsAnsConditionURL, key: "Pod_AppTermsAnsConditionURL")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppTermsAnsConditionURL") as? String{
            return value
        }
        return ""
    }
}

public var Pod_FirebaseAppName : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_FirebaseAppName")
        SetValueToSuitNameUserDefualt(value: Pod_FirebaseAppName, key: "Pod_FirebaseAppName")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_FirebaseAppName") as? String{
            return value
        }
        return ""
    }
}

public var Pod_AppLaungauge_Code : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppLaungauge_Code")
        SetValueToSuitNameUserDefualt(value: Pod_AppLaungauge_Code, key: "Pod_AppLaungauge_Code")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppLaungauge_Code") as? String{
            return value
        }
        return ""
    }
}

public var isUserGivenRating : Bool {
    set {
        UserDefaults.standard.setValue(newValue, forKey: "isUserGivenRating")
        SetValueToSuitNameUserDefualt(value: isUserGivenRating, key: "isUserGivenRating")
    }
    get{
        if let value = UserDefaults.standard.value(forKey: "isUserGivenRating") as? Bool {
            return value
        }
        return false
    }
}

public var isFeedbackSheetShown: Bool {
    set{
        UserDefaults.standard.set(newValue, forKey: "isFeedbackSheetShown")
        SetValueToSuitNameUserDefualt(value: isFeedbackSheetShown, key: "isFeedbackSheetShown")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "isFeedbackSheetShown") as? Bool {
            return value
        }
        return false
    }
}

public func SetValueToSuitNameUserDefualt(value:Any?,key:String){
    if !Pod_AppSuiteName.isEmpty{
        if let userDef = UserDefaults(suiteName: Pod_AppSuiteName) {
            userDef.setValue(value, forKey: key)
        }
    }
}
