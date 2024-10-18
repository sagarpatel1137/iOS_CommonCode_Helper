//
//  UserDefaults.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//
import UIKit

var Pod_AppVersionCode : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppVersionCode")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppVersionCode") as? String{
            return value
        }
        return ""
    }
}

var Pod_AppPackageName : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppPackageName")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppPackageName") as? String{
            return value
        }
        return ""
    }
}

var Pod_AppPrivacyPolicyURL : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppPrivacyPolicyURL")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppPrivacyPolicyURL") as? String{
            return value
        }
        return ""
    }
}

var Pod_AppTermsAnsConditionURL : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppTermsAnsConditionURL")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppTermsAnsConditionURL") as? String{
            return value
        }
        return ""
    }
}

var Pod_FirebaseAppName : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_FirebaseAppName")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_FirebaseAppName") as? String{
            return value
        }
        return ""
    }
}

var Pod_AppLaungauge_Code : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "Pod_AppLaungauge_Code")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "Pod_AppLaungauge_Code") as? String{
            return value
        }
        return ""
    }
}

var isUserGivenRating : Bool {
    set {
        UserDefaults.standard.setValue(newValue, forKey: "isUserGivenRating")
    }
    get{
        if let value = UserDefaults.standard.value(forKey: "isUserGivenRating") as? Bool {
            return value
        }
        return false
    }
}

var isFeedbackSheetShown: Bool {
    set{
        UserDefaults.standard.set(newValue, forKey: "isFeedbackSheetShown")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "isFeedbackSheetShown") as? Bool {
            return value
        }
        return false
    }
}
