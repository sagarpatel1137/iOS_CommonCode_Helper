//
//  GoogleMobileAdsConsentManager.swift
//  iOS_CommonCode
//
//  Created by IOS on 16/08/24.
//

import UIKit
import Foundation
import GoogleMobileAds
import UserMessagingPlatform

public class GoogleMobileAdsConsent_Manager: NSObject {
    
    public class func funGDPRConsent(complition: @escaping (Error?) -> Void)
    {
        let parameters = UMPRequestParameters()
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { requestConsentError in
            guard requestConsentError == nil else {
                return complition(requestConsentError)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if let topVC = funGetTopViewController() {
                    UMPConsentForm.loadAndPresentIfRequired(from: topVC) { loadAndPresentError in
                        complition(loadAndPresentError)
                    }
                }
            }
        }
    }
}
