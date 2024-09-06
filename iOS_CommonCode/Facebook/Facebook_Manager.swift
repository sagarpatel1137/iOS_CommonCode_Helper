//
//  Facebook_Manager.swift
//  CommonCode_iOS
//
//  Created by IOS on 14/06/24.
//

import FBSDKCoreKit

public class Facebook_Manager: NSObject {

    public class func initialize(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
