//
//  Constant Functions.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit


func hexStringToUIColor (hex:String) -> UIColor {
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
        alpha: CGFloat(1.0)
    )
}

func setCustomFont(name: String, iPhoneSize: Int, iPadSize: Int) -> UIFont
{
    let font = UIFont(name: name, size: UIDevice.current.isiPhone ? Double(iPhoneSize)*fontRatio : Double(iPadSize)*fontRatio)
    return font!
}

//MARK: -
func scheduleFreeTrialNotification(noOfDays: Int , isDebug: Bool = false) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        if granted {
            print("Notification permission granted")
        } else {
            print("Notification permission denied")
        }
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Free Trial Ending Soon"
    if noOfDays == 5 {
        content.body = "You will be charged after 2 days, Cancel anytime before."
    } else {
        content.body = "You will be charged from tomorrow, Cancel anytime before."
    }
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "important_notification"
    
    // Define trigger based on isDebug value
    let trigger: UNNotificationTrigger
    if isDebug {
        // Schedule notification for numbers of days in minutes
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(noOfDays*60), repeats: false)
    } else {
        // Schedule notification for the 5th day
        let triggerDate = Calendar.current.date(byAdding: .day, value: noOfDays, to: Date())!
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
