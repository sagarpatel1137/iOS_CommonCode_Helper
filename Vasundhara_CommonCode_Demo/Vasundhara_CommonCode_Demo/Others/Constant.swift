//
//  Constant.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit

var isAppRedirected = false

var fontRatio: CGFloat {
    if UIDevice.current.isiPhone {
        UIScreen.main.bounds.width/320
    } else {
        UIScreen.main.bounds.width/768
    }
}

let Avenir_Black = "Avenir Black"
let Avenir_Heavy = "Avenir Heavy"
let Avenir_Medium = "Avenir-Medium"

let PlusJakartaSans_Regular = "PlusJakartaSans-Regular"
let PlusJakartaSans_Medium = "PlusJakartaSans-Medium"
let PlusJakartaSans_SemiBold = "PlusJakartaSans-SemiBold"
let PlusJakartaSans_Bold = "PlusJakartaSans-Bold"
let PlusJakartaSans_ExtraBold = "PlusJakartaSans-ExtraBold"

let WorkSans_Regular = "WorkSans-Regular"
let WorkSans_Medium = "WorkSans-Medium"
let WorkSans_SemiBold = "WorkSans-SemiBold"
let WorkSans_Bold = "WorkSans-Bold"
let WorkSans_ExtraBold = "WorkSans-ExtraBold"




let notificationPurchaseSuccessfully = Notification.Name("InAppPurchaseSuccessfully")
