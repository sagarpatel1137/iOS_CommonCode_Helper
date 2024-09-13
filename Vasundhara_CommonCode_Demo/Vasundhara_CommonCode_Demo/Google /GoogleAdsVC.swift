//
//  GoogleAdsVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit
import GoogleMobileAds

class GoogleAdsVC: UIViewController {

    @IBOutlet weak var viewNative: UIView!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var viewBanner_Height: NSLayoutConstraint!
    
    @IBAction func btn_BannerAd_Click(_ sender: Any) 
    {
        viewBanner_Height.constant = GoogleAd_Manager.shared.funGetAdaptiveBannerHeight()
        GoogleAd_Manager.shared.funShowBannerAd(parentView: viewBanner)
    }
    
    @IBAction func btn_IntAd_Click(_ sender: Any) 
    {
        GoogleAd_Manager.shared.funShowInterstitialAd(rootVC: self) { isAdPresent in
            print("Google InterstitialAd Present : \(isAdPresent)")
        } adDidDismiss: {
            print("Google InterstitialAd Dismiss")
        } didFailToPresent: { error in
            print("Google InterstitialAd Failed : \(error)")
        }
    }
    
    @IBAction func btn_NativeAd_Click(_ sender: Any) 
    {
        //Standard Format
        /*GoogleAd_Manager.shared.funShowNativeAd(adType: .full_Native1, parentView: viewNative) { isAdPresent in
            print("Google NativeAd Present : \(isAdPresent)")
        } isClick: {
            print("Google NativeAd Click")
        } isNewLoad: {
            print("Google NativeAd Reload")
            self.btn_NativeAd_Click(UIButton())
        }*/
        
        //Custom Format
        guard let nibObjects = Bundle.main.loadNibNamed("Shimmer_FullNative", owner: nil, options: nil),
              let adShimmerView = nibObjects.first as? Shimmer_View else { return }
        
        guard let nibObjects = Bundle.main.loadNibNamed("NativeAd", owner: nil, options: nil),
              let adView = nibObjects.first as? GADNativeAdView else { return }
        
        GoogleAd_Manager.shared.funShowNativeAd(adType: .custom_Native, parentView: viewNative, shimerView: adShimmerView, nativeAdView: adView) { isAdPresent in
            print("Google Custom NativeAd Present : \(isAdPresent)")
        } isClick: {
            print("Google Custom NativeAd Click")
        } isNewLoad: {
            print("Google Custom NativeAd Reload")
            self.btn_NativeAd_Click(UIButton())
        }
    }
    
    @IBAction func btn_RewardedAd_Click(_ sender: Any)
    {
        GoogleAd_Manager.shared.funShowRewardedAd(rootVC: self) { isAdPresent in
            print("Google RewardedAd Present : \(isAdPresent)")
        } adDidDismiss: {
            print("Google RewardedAd Dismiss")
        } adRewarded: {
            print("Google RewardedAd Reward Granted")
        } didFailToPresent: { error in
            print("Google RewardedAd Failed : \(error)")
        }
    }
    
    @IBAction func btn_RewardedIntAd_Click(_ sender: Any)
    {
        GoogleAd_Manager.shared.funShowRewardedIntAd(rootVC: self) { isAdPresent in
            print("Google RewardedIntAd Present : \(isAdPresent)")
        } adDidDismiss: {
            print("Google RewardedIntAd Dismiss")
        } adRewarded: {
            print("Google RewardedIntAd Reward Granted")
        } didFailToPresent: { error in
            print("Google RewardedIntAd Failed : \(error)")
        }
    }
    
    @IBAction func btn_AppOpenAd_Click(_ sender: Any)
    {
        GoogleAd_Manager.shared.funShowAppOpenAd(rootVC: self) { isAdPresent in
            print("Google AppOpenAd Present : \(isAdPresent)")
        } adDidDismiss: {
            print("Google AppOpenAd Dismiss")
        } didFailToPresent: { error in
            print("Google AppOpenAd Failed : \(error)")
        }
    }
}

