//
//  UserDefaults.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//
import UIKit

var AppLaungauge_Code : String {
    set{
        UserDefaults.standard.set(newValue, forKey: "AppLaungauge_Code")
    }
    get {
        if let value = UserDefaults.standard.value(forKey: "AppLaungauge_Code") as? String{
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
