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

public class GoogleMobileAdsConsentManager {
    
    public static func funGDPRConsent(from vc: UIViewController, complition: @escaping (Error?) -> Void)
    {
        let parameters = UMPRequestParameters()
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { requestConsentError in
            guard requestConsentError == nil else {
                return complition(requestConsentError)
            }
            UMPConsentForm.loadAndPresentIfRequired(from: vc) { loadAndPresentError in
                complition(loadAndPresentError)
            }
        }
    }
}
