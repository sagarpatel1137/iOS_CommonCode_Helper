//
//  GoogleAd_Manager.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import GoogleMobileAds

class GoogleAd_Manager: NSObject {

    //MARK: - Public
    public static let shared = GoogleAd_Manager()
    
    public var isAdClickedAndRedirected = false
    
    //MARK: - Private
    private var Banner_ID = ""
    private var Int_ID = ""
    private var Native_ID = ""
    private var Rewarded_ID = ""
    private var RewardedInt_ID = ""
    private var AppOpen_ID = ""
    
    //InterstitialAd
    private var interstitialAd : GADInterstitialAd!
    private var isRequeSendForLoad_IntAd = false
    private var isInterstitialAdOpen = false
    private var interstitialAd_LoadDone : (() -> Void)?
    private var interstitialAd_DidDismiss : (() -> Void)?
    private var interstitialAd_DidFailToPresent : ((String) -> Void)?
    
    //RewardedAd
    private var rewardedAd : GADRewardedAd!
    private var isRequeSendForLoad_RewardedAd = false
    private var isRewardedAdOpen = false
    private var rewardedAd_LoadDone : (() -> Void)?
    private var rewardedAd_DidDismiss : (() -> Void)?
    private var rewardedAd_Rewarded : (() -> Void)?
    private var rewardedAd_DidFailToPresent : ((String) -> Void)?
    
    //RewardedInterstitialAd
    private var rewardedIntAd : GADRewardedInterstitialAd!
    private var isRequeSendForLoad_RewardedIntAd = false
    private var isRewardedIntAdOpen = false
    private var rewardedIntAd_LoadDone : (() -> Void)?
    private var rewardedIntAd_DidDismiss : (() -> Void)?
    private var rewardedIntAd_Rewarded : (() -> Void)?
    private var rewardedIntAd_DidFailToPresent : ((String) -> Void)?
    
    private var appOpenAd : GADAppOpenAd!
    private var isRequeSendForLoad_AppOpenAd = true
    private var isAppOpenAdOpen = false
    private var appOpenAd_LoadDone : (() -> Void)?
    private var appOpenAd_DidDismiss : (() -> Void)?
    private var appOpenAd_DidFailToPresent : ((String) -> Void)?
    
    //Adaptive BannerAd
    private var bannerViewAd : GADBannerView!
    private var bannerAd_present : (() -> Void)?
    private var isBannerAdLoaded = false
    
    private override init() {
    }
}

//MARK: - Initialise
extension GoogleAd_Manager
{
    public func initialiseGoogleAds(bannerAd: String?, intAd: String?, nativeAd: String?, rewardAd: String?, rewardIntAd: String?, appOpenAd: String?, testDevices: [String] = []) {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDevices
        
        if let id = bannerAd {
            Banner_ID = id
            load_BannerAd()
        }
        if let id = intAd {
            Int_ID = id
            load_InterstitialAd()
        }
        if let id = nativeAd {
            Native_ID = id
        }
        if let id = rewardAd {
            Rewarded_ID = id
            load_RewardedAd()
        }
        if let id = rewardIntAd {
            RewardedInt_ID = id
            load_RewardedIntAd()
        }
        if let id = appOpenAd {
            AppOpen_ID = id
            load_OpenAd()
        }
    }
    
    public func isAnyFullAdOpen() -> Bool {
        let isOpen = isInterstitialAdOpen || isRewardedAdOpen || isRewardedIntAdOpen || isAppOpenAdOpen
        return isOpen
    }
}

//MARK: - Ad Show
extension GoogleAd_Manager
{
    public func funShowInterstitialAd(rootVC: UIViewController, adLoadDone : (() -> Void)?, isPresentAd : ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),didFailToPresent : @escaping (() -> Void))
    {
        checkIntAdIsReadyForShow(rootVC) { (isADPresented) in
            isPresentAd(isADPresented)
        }
        interstitialAd_LoadDone = {
            adLoadDone?()
        }
        interstitialAd_DidDismiss = {
            adDidDismiss()
        }
        interstitialAd_DidFailToPresent = { (error) in
            didFailToPresent()
        }
    }
    
    public func funShowRewardedAd(rootVC: UIViewController, adLoadDone : (() -> Void)?, isPresentAd : ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),adRewarded : @escaping (() -> Void),didFailToPresent : @escaping (() -> Void))
    {
        checkRewardedAdIsReadyForShow(rootVC) { (isADPresented) in
            isPresentAd(isADPresented)
        }
        rewardedAd_LoadDone = {
            adLoadDone?()
        }
        rewardedAd_DidDismiss = {
            adDidDismiss()
        }
        rewardedAd_DidFailToPresent = { (error) in
            didFailToPresent()
        }
        rewardedAd_Rewarded = {
            adRewarded()
        }
    }
    
    public func funShowRewardedIntAd(rootVC: UIViewController, adLoadDone : (() -> Void)?, isPresentAd : ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),adRewarded : @escaping (() -> Void),didFailToPresent : @escaping (() -> Void))
    {
        checkRewardedIntAdIsReadyForShow(rootVC) { (isADPresented) in
            isPresentAd(isADPresented)
        }
        rewardedAd_LoadDone = {
            adLoadDone?()
        }
        rewardedIntAd_DidDismiss = {
            adDidDismiss()
        }
        rewardedIntAd_DidFailToPresent = { (error) in
            didFailToPresent()
        }
        rewardedIntAd_Rewarded = {
            adRewarded()
        }
    }
    
    public func funShowAppOpenAd(rootVC: UIViewController, adLoadDone : (() -> Void)?, isPresentAd : ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),didFailToPresent : @escaping (() -> Void))
    {
        checkAppOpenAdIsReadyForShow(rootVC) { (isADPresented) in
            isPresentAd(isADPresented)
        }
        appOpenAd_LoadDone = {
            adLoadDone?()
        }
        appOpenAd_DidDismiss = {
            adDidDismiss()
        }
        appOpenAd_DidFailToPresent = { (error) in
            didFailToPresent()
        }
    }
}


//MARK: - Interstitial Ad
extension GoogleAd_Manager
{
    private func load_InterstitialAd()
    {
        interstitialAd = nil
        if !Purchase_flag && Reachability.isConnectedToNetwork() && !isRequeSendForLoad_IntAd
        {
            isRequeSendForLoad_IntAd = true
            let request = GADRequest()
            
            GADInterstitialAd.load(withAdUnitID: self.Int_ID, request: request) { [self] (ad, error) in

                isRequeSendForLoad_IntAd = false
                if let _ = error {
                    load_InterstitialAd()
                    return
                }
                interstitialAd = ad!
                interstitialAd?.fullScreenContentDelegate = self
                
                interstitialAd_LoadDone?()
            }
        }
    }
    
    private func checkIntAdIsReadyForShow(_ rootVC : UIViewController,_ isPresentAd : ((Bool) -> Void))
    {
        if !Purchase_flag && interstitialAd != nil {
            interstitialAd.present(fromRootViewController: rootVC)
            isPresentAd(true)
        }
        else {
            load_InterstitialAd()
            isPresentAd(false)
        }
    }
}

//MARK: - Rewarded Ad
extension GoogleAd_Manager
{
    private func load_RewardedAd()
    {
        rewardedAd = nil
        if !Purchase_flag && Reachability.isConnectedToNetwork() && !isRequeSendForLoad_RewardedAd
        {
            isRequeSendForLoad_RewardedAd = true
            let request = GADRequest()
            
            GADRewardedAd.load(withAdUnitID: Rewarded_ID, request: request) { [self] (ad, error) in
                
                if let _ = error {
                    load_RewardedAd()
                    return
                }
                isRequeSendForLoad_RewardedAd = false
                rewardedAd = ad!
                rewardedAd?.fullScreenContentDelegate = self
                
                rewardedAd_LoadDone?()
            }
        }
    }
    
    private func checkRewardedAdIsReadyForShow(_ rootVC : UIViewController,_ isPresentAd : ((Bool) -> Void))
    {
        if !Purchase_flag && rewardedAd != nil {
            rewardedAd.present(fromRootViewController: rootVC) {
                self.rewardedAd_Rewarded?()
            }
            isPresentAd(true)
        }
        else {
            load_RewardedAd()
            isPresentAd(false)
        }
    }
}

//MARK: - Rewarded Interstitial Ad
extension GoogleAd_Manager
{
    private func load_RewardedIntAd()
    {
        rewardedIntAd = nil
        if !Purchase_flag && Reachability.isConnectedToNetwork() && !isRequeSendForLoad_RewardedAd
        {
            isRequeSendForLoad_RewardedAd = true
            let request = GADRequest()
            
            GADRewardedInterstitialAd.load(withAdUnitID: RewardedInt_ID, request: request) { [self] (ad, error) in
                
                if let _ = error {
                    load_RewardedIntAd()
                    return
                }
                isRequeSendForLoad_RewardedAd = false
                rewardedIntAd = ad!
                rewardedIntAd?.fullScreenContentDelegate = self
                
                rewardedIntAd_LoadDone?()
            }
        }
    }
    
    private func checkRewardedIntAdIsReadyForShow(_ rootVC : UIViewController,_ isPresentAd : ((Bool) -> Void))
    {
        if !Purchase_flag && rewardedIntAd != nil {
            rewardedIntAd.present(fromRootViewController: rootVC) {
                self.rewardedIntAd_Rewarded?()
            }
            isPresentAd(true)
        }
        else {
            load_RewardedIntAd()
            isPresentAd(false)
        }
    }
}

//MARK: - AppOpen Ad
extension GoogleAd_Manager
{
    private func load_OpenAd()
    {
        appOpenAd = nil
        if !Purchase_flag && Reachability.isConnectedToNetwork() && !isRequeSendForLoad_AppOpenAd
        {
            isRequeSendForLoad_AppOpenAd = true
            let request = GADRequest()
            
            GADAppOpenAd.load(withAdUnitID: self.AppOpen_ID, request: request) { [self] (ad, error) in
                
                isRequeSendForLoad_AppOpenAd = false
                if let _ = error {
                    print(error!.localizedDescription)
                    return
                }
                appOpenAd = ad!
                appOpenAd.fullScreenContentDelegate = self
                
                appOpenAd_LoadDone?()
            }
        }
    }
    
    private func checkAppOpenAdIsReadyForShow(_ rootVC : UIViewController,_ isPresentAd : ((Bool) -> Void))
    {
        if !Purchase_flag && appOpenAd != nil {
            appOpenAd.present(fromRootViewController: rootVC)
            isPresentAd(true)
        }
        else {
            isPresentAd(false)
        }
    }
}

//MARK: - GADFullScreenContent Delegate
extension GoogleAd_Manager : GADFullScreenContentDelegate
{
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        isAdClickedAndRedirected = true
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        if ad.isKind(of: GADInterstitialAd.self) {
            isInterstitialAdOpen = true
        }
        else if ad.isKind(of: GADRewardedAd.self) {
            isRewardedAdOpen = true
        }
        else if ad.isKind(of: GADRewardedInterstitialAd.self) {
            isRewardedIntAdOpen = true
        }
        else if ad.isKind(of: GADAppOpenAd.self) {
            isAppOpenAdOpen = true
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        if ad.isKind(of: GADInterstitialAd.self) {
            isInterstitialAdOpen = false
            load_InterstitialAd()
            interstitialAd_DidDismiss?()
        }
        else if ad.isKind(of: GADRewardedAd.self) {
            isRewardedAdOpen = false
            load_RewardedAd()
            rewardedAd_DidDismiss?()
        }
        else if ad.isKind(of: GADRewardedInterstitialAd.self) {
            isRewardedIntAdOpen = false
            load_RewardedIntAd()
            rewardedIntAd_DidDismiss?()
        }
        else if ad.isKind(of: GADAppOpenAd.self) {
            isAppOpenAdOpen = false
            load_OpenAd()
            appOpenAd_DidDismiss?()
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
        if ad.isKind(of: GADInterstitialAd.self) {
            load_InterstitialAd()
            interstitialAd_DidFailToPresent?(error.localizedDescription)
        }
        else if ad.isKind(of: GADRewardedAd.self) {
            load_RewardedAd()
            rewardedAd_DidFailToPresent?(error.localizedDescription)
        }
        else if ad.isKind(of: GADRewardedInterstitialAd.self) {
            load_RewardedIntAd()
            rewardedIntAd_DidFailToPresent?(error.localizedDescription)
        }
        else if ad.isKind(of: GADAppOpenAd.self) {
            load_OpenAd()
            appOpenAd_DidFailToPresent?(error.localizedDescription)
        }
    }
}


// -------------------------------------------------
// MARK:- GADBannerAd
// -------------------------------------------------
extension GoogleAd_Manager
{
    func load_BannerAd()
    {
        if !Purchase_flag && !isBannerAdLoaded {
            bannerViewAd = GADBannerView()
            bannerViewAd.delegate = self
            bannerViewAd.adUnitID = Banner_ID
            bannerViewAd.rootViewController = UIApplication.shared.windows.first!.rootViewController
            bannerViewAd.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
            bannerViewAd.load(GADRequest())
        }
    }
    
    func funGetAdaptiveBannerHeight() -> CGFloat {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width).size.height
    }
    
    func funShowBannerAd(parentView: UIView)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
            
            if !Purchase_flag
            {
                parentView.addShimmerViewForADType(adType: .adptive_Banner)
                
                if isBannerAdLoaded {
                    if bannerAd_present != nil {
                        parentView.removeShimmerViewForADType()
                        bannerAd_present!()
                    }
                    parentView.addSubview(bannerViewAd)
                }
                else {
                    load_BannerAd()
                    bannerAd_present = {
                        parentView.removeShimmerViewForADType()
                    }
                    parentView.addSubview(bannerViewAd)
                }
            }
        }
    }
}

extension GoogleAd_Manager : GADBannerViewDelegate
{
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        isAdClickedAndRedirected = true
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        if !Purchase_flag {
            bannerViewAd = bannerView
            isBannerAdLoaded = true
            if bannerAd_present != nil {
                bannerAd_present!()
            }
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        load_BannerAd()
    }
}
