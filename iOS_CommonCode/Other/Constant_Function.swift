//
//  Constant_Function.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import UIKit
import Foundation
import FirebaseAnalytics

let AppThemeColor = UIColor(red: 27/255, green: 121/255, blue: 255/255, alpha: 1.0)

public func funGetTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
    
    if let nav = base as? UINavigationController {
        return funGetTopViewController(base: nav.visibleViewController)
        
    } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
        return funGetTopViewController(base: selected)
        
    } else if let presented = base?.presentedViewController {
        return funGetTopViewController(base: presented)
    }
    return base
}

public func hexStringToUIColor (hex:String, alpha:CGFloat = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}


//MARK: - Fonts
public enum FontApp: String {
    case Avenir_Black = "Avenir Black"
    case Avenir_Heavy = "Avenir Heavy"
    case Avenir_Medium = "Avenir-Medium"
    case PlusJakartaSans_Regular = "PlusJakartaSans-Regular"
    case PlusJakartaSans_Medium = "PlusJakartaSans-Medium"
    case PlusJakartaSans_SemiBold = "PlusJakartaSans-SemiBold"
    case PlusJakartaSans_Bold = "PlusJakartaSans-Bold"
    case PlusJakartaSans_ExtraBold = "PlusJakartaSans-ExtraBold"
    case WorkSans_Regular = "WorkSans-Regular"
    case WorkSans_Medium = "WorkSans-Medium"
    case WorkSans_SemiBold = "WorkSans-SemiBold"
    case WorkSans_Bold = "WorkSans-Bold"
    case WorkSans_ExtraBold = "WorkSans-ExtraBold"
}

public var fontRatio: CGFloat {
    if UIDevice.current.isiPhone {
        UIScreen.main.bounds.width/320
    } else {
        UIScreen.main.bounds.width/768
    }
}

public func setCustomFont_WithoutRatio(name: FontApp, iPhoneSize: Double, iPadSize: Double) -> UIFont {
    /*
    for family in UIFont.familyNames {
        print("Family: \(family)")
        for name in UIFont.fontNames(forFamilyName: family) {
            print("    Name: \(name)")
        }
    }
      */
    let font = UIFont(name: name.rawValue, size: UIDevice.current.isiPhone ? iPhoneSize : iPadSize)
    return font!
}

public func setCustomFont(name: FontApp, iPhoneSize: Double, iPadSize: Double) -> UIFont {
    let font = UIFont(name: name.rawValue, size: UIDevice.current.isiPhone ? iPhoneSize*fontRatio : iPadSize*fontRatio)
    return font!
}

public func ResizeText(iphone: CGFloat, iPad: CGFloat) -> CGFloat {
    
    let ratio = UIDevice.current.isiPhone ? UIScreen.main.bounds.width/320 : UIScreen.main.bounds.width/768
    let size = UIDevice.current.isiPhone ? iphone*ratio : iPad*ratio
    
    let phone = Locale.current.languageCode == "ur" ? size - 3 : iphone
    return phone
}

public func ResizeText_Rating(iphone: CGFloat, iPad: CGFloat) -> CGFloat {
    
    let ratio = UIDevice.current.isiPhone ? UIScreen.main.bounds.width/320 : UIScreen.main.bounds.width/768
    let size = UIDevice.current.isiPhone ? iphone*ratio : iPad*ratio

    let phone = Locale.current.languageCode == "ur" ? size - 3 : size
    return phone
}

public func scheduleFreeTrialNotification(noOfDays: Int, isDebug: Bool = false) {
    
    let nodofdays = noOfDays-1
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        if granted {
            print("Notification permission granted")
        } else {
            print("Notification permission denied")
        }
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Free Trial Ending Soon"
    if nodofdays == 2 {
        content.body = "You will be charged from tomorrow, Cancel anytime before."
    } else {
        content.body = "You will be charged after 2 days, Cancel anytime before."
    }
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "important_notification"
    
    // Define trigger based on isDebug value
    let trigger: UNNotificationTrigger
    if isDebug {
        // Schedule notification for numbers of days in minutes
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(nodofdays*60), repeats: false)
    } else {
        // Schedule notification for the Nth day
        let triggerDate = Calendar.current.date(byAdding: .day, value: nodofdays, to: Date())!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    let request = UNNotificationRequest(identifier: "trialNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully")
        }
    }
}

