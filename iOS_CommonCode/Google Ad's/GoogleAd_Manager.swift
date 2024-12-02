//
//  GoogleAd_Manager.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import GoogleMobileAds
import Alamofire

public class GoogleAd_Manager : NSObject {

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
    
    //Interstitial Ad
    private var interstitialAd : GADInterstitialAd!
    private var isRequeSendForLoad_IntAd = false
    private var isInterstitialAdOpen = false
    private var interstitialAd_LoadDone : (() -> Void)?
    private var interstitialAd_DidDismiss : (() -> Void)?
    private var interstitialAd_DidFailToPresent : ((String) -> Void)?
    
    //Rewarded Ad
    private var rewardedAd : GADRewardedAd!
    private var isRequeSendForLoad_RewardedAd = false
    private var isRewardedAdOpen = false
    private var rewardedAd_LoadDone : (() -> Void)?
    private var rewardedAd_DidDismiss : (() -> Void)?
    private var rewardedAd_Rewarded : (() -> Void)?
    private var rewardedAd_DidFailToPresent : ((String) -> Void)?
    
    //RewardedInterstitial Ad
    private var rewardedIntAd : GADRewardedInterstitialAd!
    private var isRequeSendForLoad_RewardedIntAd = false
    private var isRewardedIntAdOpen = false
    private var rewardedIntAd_LoadDone : (() -> Void)?
    private var rewardedIntAd_DidDismiss : (() -> Void)?
    private var rewardedIntAd_Rewarded : (() -> Void)?
    private var rewardedIntAd_DidFailToPresent : ((String) -> Void)?
    
    //AppOpen Ad
    private var appOpenAd : GADAppOpenAd!
    private var isRequeSendForLoad_AppOpenAd = false
    private var isAppOpenAdOpen = false
    private var appOpenAd_LoadDone : (() -> Void)?
    private var appOpenAd_DidDismiss : (() -> Void)?
    private var appOpenAd_DidFailToPresent : ((String) -> Void)?
    
    //Adaptive BannerAd
    private var bannerViewAd : GADBannerView!
    private var bannerAd_present : (() -> Void)?
    private var isBannerAdLoaded = false
    
    //Native Ad
    public var native_Ad : GADNativeAd!
    public var nativeAdColors : NativeAdColors = NativeAdColors(bgColor: "FFFFFF", themeColor: "CDCDCD", headlineColor: "000000", bodyColor: "787878", btnTitleColor: "000000")
    private var nativeAd_Loader: GADAdLoader!
    private var isLoadedNativeAd = false
    private var isRequeSendForLoad_NativeAd = false
    private var nativeAd_LoadDone : (() -> Void)?
    private var nativeAd_Reload : (() -> Void)!
    
    private override init() {
    }
}

//MARK: - Initialise
extension GoogleAd_Manager
{
    public func initialiseGoogleAds(bannerAd: String = "",
                                    intAd: String = "",
                                    nativeAd: String = "",
                                    rewardAd: String = "",
                                    rewardIntAd: String = "",
                                    appOpenAd: String = "",
                                    testDevices: [String] = [])
    {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDevices
        
        if bannerAd != "" {
            Banner_ID = bannerAd
            load_BannerAd()
        }
        if intAd != "" {
            Int_ID = intAd
            load_InterstitialAd()
        }
        if nativeAd != "" {
            Native_ID = nativeAd
            load_NativeAd()
        }
        if rewardAd != "" {
            Rewarded_ID = rewardAd
            load_RewardedAd()
        }
        if rewardIntAd != "" {
            RewardedInt_ID = rewardIntAd
            load_RewardedIntAd()
        }
        if appOpenAd != "" {
            AppOpen_ID = appOpenAd
            load_OpenAd()
        }
        
        checkForNetworkReachability()
    }
}

//MARK: - Other
extension GoogleAd_Manager
{
    public func isAnyFullAdOpen() -> Bool {
        let isOpen = isInterstitialAdOpen || isRewardedAdOpen || isRewardedIntAdOpen || isAppOpenAdOpen
        return isOpen
    }
    
    public func funGetAdaptiveBannerHeight() -> CGFloat {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width).size.height
    }
    
    public func funIsRewardedAdAvailable(completion: @escaping (()->())) {
        if rewardedAd != nil {
            completion()
        } else {
            load_RewardedAd()
            rewardedAd_LoadDone = {
                completion()
            }
        }
    }
}

//MARK: - Ad Show
extension GoogleAd_Manager
{
    public func funShowBannerAd(parentView: UIView, loaderType: LoaderType = .AdsByDeveloper, adByDeveloperTextColor: UIColor? = nil, customLoader: UIView? = nil)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
            
            
            if !Purchase_flag {
                
                switch loaderType {
                case .Shimmer:
                    parentView.addShimmerViewForAdType(adType: .banner_Adaptive)
                case .AdsByDeveloper:
                    parentView.addAdByDeveloperViewForAd(isForBannerAd: true, textColor: adByDeveloperTextColor ?? hexStringToUIColor(hex: "DDDDDD"))
                case .Custom:
                    if let loader = customLoader {
                        parentView.addSubview(loader)
                    } else {
                        fatalError("Vasundhara 🏢 - Google Banner Ad : customLoader View Missing.")
                    }
                }
                
                if isBannerAdLoaded {
                    if bannerAd_present != nil {
                        DispatchQueue.main.async {
                            switch loaderType {
                            case .Shimmer:
                                parentView.removeShimmerViewForAdType()
                            case .AdsByDeveloper:
                                parentView.removeAdByDeveloperViewForAd()
                            case .Custom:
                                if let loader = customLoader {
                                    loader.removeFromSuperview()
                                }
                            }
                        }
                        bannerAd_present!()
                    }
                    parentView.addSubview(self.bannerViewAd)
                }
                else {
                    load_BannerAd()
                    bannerAd_present = {
                        DispatchQueue.main.async {
                            switch loaderType {
                            case .Shimmer:
                                parentView.removeShimmerViewForAdType()
                            case .AdsByDeveloper:
                                parentView.removeAdByDeveloperViewForAd()
                            case .Custom:
                                if let loader = customLoader {
                                    loader.removeFromSuperview()
                                }
                            }
                            parentView.addSubview(self.bannerViewAd)
                        }
                    }
                }
            }
        }
    }
    
    public func funShowInterstitialAd(rootVC: UIViewController, isWaitUntillShow: Bool = false, isPresentAd : @escaping ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),didFailToPresent : @escaping ((String) -> Void))
    {
        checkIntAdIsReadyForShow(rootVC) { (isADPresented) in
            if isWaitUntillShow && !isADPresented {
                interstitialAd_LoadDone = {
                    self.interstitialAd.present(fromRootViewController: rootVC)
                    self.interstitialAd_LoadDone = nil
                    isPresentAd(true)
                }
            }
            else {
                isPresentAd(isADPresented)
            }
        }
        interstitialAd_DidDismiss = {
            adDidDismiss()
        }
        interstitialAd_DidFailToPresent = { (error) in
            didFailToPresent(error)
        }
    }
    
    public func funShowRewardedAd(rootVC: UIViewController, isWaitUntillShow: Bool = false, isPresentAd : @escaping ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),adRewarded : @escaping (() -> Void),didFailToPresent : @escaping ((String) -> Void))
    {
        checkRewardedAdIsReadyForShow(rootVC) { (isADPresented) in
            if isWaitUntillShow && !isADPresented {
                rewardedAd_LoadDone = {
                    self.rewardedAd.present(fromRootViewController: rootVC) {
                        self.rewardedAd_Rewarded?()
                    }
                    self.rewardedAd_LoadDone = nil
                    isPresentAd(true)
                }
            }
            else {
                isPresentAd(isADPresented)
            }
        }
        rewardedAd_DidDismiss = {
            adDidDismiss()
        }
        rewardedAd_DidFailToPresent = { (error) in
            didFailToPresent(error)
        }
        rewardedAd_Rewarded = {
            adRewarded()
        }
    }
    
    public func funShowRewardedIntAd(rootVC: UIViewController, isWaitUntillShow: Bool = false, isPresentAd : @escaping ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),adRewarded : @escaping (() -> Void),didFailToPresent : @escaping ((String) -> Void))
    {
        checkRewardedIntAdIsReadyForShow(rootVC) { (isADPresented) in
            if isWaitUntillShow && !isADPresented {
                rewardedIntAd_LoadDone = {
                    self.rewardedIntAd.present(fromRootViewController: rootVC) {
                        self.rewardedIntAd_Rewarded?()
                    }
                    self.rewardedIntAd_LoadDone = nil
                    isPresentAd(true)
                }
            }
            else {
                isPresentAd(isADPresented)
            }
        }
        rewardedIntAd_DidDismiss = {
            adDidDismiss()
        }
        rewardedIntAd_DidFailToPresent = { (error) in
            didFailToPresent(error)
        }
        rewardedIntAd_Rewarded = {
            adRewarded()
        }
    }
    
    public func funShowAppOpenAd(rootVC: UIViewController, isWaitUntillShow: Bool = false, isPresentAd : @escaping ((Bool) -> Void),adDidDismiss : @escaping (() -> Void),didFailToPresent : @escaping ((String) -> Void))
    {
        checkAppOpenAdIsReadyForShow(rootVC) { (isADPresented) in
            if isWaitUntillShow && !isADPresented {
                appOpenAd_LoadDone = {
                    self.appOpenAd.present(fromRootViewController: rootVC)
                    self.appOpenAd_LoadDone = nil
                    isPresentAd(true)
                }
            }
            else {
                isPresentAd(isADPresented)
            }
        }
        appOpenAd_DidDismiss = {
            adDidDismiss()
        }
        appOpenAd_DidFailToPresent = { (error) in
            didFailToPresent(error)
        }
    }
    
    public func funShowNativeAd(adType : GADAdTYPE, parentView: UIView, isLoadNewAd : Bool = false, nativeAdColors: NativeAdColors = NativeAdColors(), nativeAdView: GADNativeAdView? = nil, loaderType: LoaderType = .AdsByDeveloper, shimerView : Shimmer_View? = nil, adByDeveloperTextColor: UIColor? = nil, customLoader: UIView? = nil, starRatingHeight: CGFloat = 0.0, starRatingColor: UIColor = .gray, isAdShown : @escaping ((Bool) -> Void), isClick : @escaping (() -> Void), isNewLoad : @escaping (() -> Void))
    {
        if isLoadNewAd || !isLoadedNativeAd {
            isLoadedNativeAd = false
            load_NativeAd()
        }
        
        if adType == .custom_Native {
            if nativeAdView == nil {
                fatalError("Vasundhara 🏢 - Google Native Ad : Custom nativeAdView Missing.")
            }
            if shimerView == nil && loaderType == .Shimmer {
                fatalError("Vasundhara 🏢 - Google Native Ad : Custom shimerView Missing.")
            }
        }
        
        if adType != .custom_Native {
            parentView.backgroundColor = .clear
            parentView.layer.shadowColor = UIColor.darkGray.cgColor
            parentView.layer.shadowRadius = 3
            parentView.layer.shadowOpacity = 0.3
            parentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            parentView.layer.masksToBounds = false
            parentView.layer.cornerRadius = UIDevice.current.isiPhone ? 10:15
        }
        
        DispatchQueue.main.async {
            switch loaderType {
            case .Shimmer:
                if adType == .custom_Native {
                    parentView.addCustomShimmerViewForAd(adShimmerView: shimerView!)
                } else {
                    parentView.addShimmerViewForAdType(adType: adType)
                }
            case .AdsByDeveloper:
                parentView.addAdByDeveloperViewForAd(isForBannerAd: false, textColor: adByDeveloperTextColor ?? hexStringToUIColor(hex: "DDDDDD"))
            case .Custom:
                if let loader = customLoader {
                    parentView.addSubview(loader)
                } else {
                    fatalError("Vasundhara 🏢 - Google Native Ad : customLoader View Missing.")
                }
            }
        }
        
        if Reachability_Manager.isConnectedToNetwork()
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){[self] in
                
                if self.isLoadedNativeAd {
                    
                    //Remove Loader View
                    switch loaderType {
                    case .Shimmer:
                        parentView.removeShimmerViewForAdType()
                    case .AdsByDeveloper:
                        parentView.removeAdByDeveloperViewForAd()
                    case .Custom:
                        if let loader = customLoader {
                            loader.removeFromSuperview()
                        }
                    }
                    
                    if adType == .custom_Native {
                        parentView.setup_NativeCustomAdView(adView: nativeAdView!, starRatingHeight: starRatingHeight,starRatingTintColor: starRatingColor) {
                            isAdShown(true)
                        }
                    }
                    else {
                        parentView.setup_NativeAdView(adType: adType, adColor: nativeAdColors) {
                            isAdShown(true)
                        }
                    }
                    
                    self.nativeAd_LoadDone = {
                        isNewLoad()
                    }
                    
                }
                else {
                    self.nativeAd_LoadDone = {
                        
                        //Remove Loader View
                        switch loaderType {
                        case .Shimmer:
                            parentView.removeShimmerViewForAdType()
                        case .AdsByDeveloper:
                            parentView.removeAdByDeveloperViewForAd()
                        case .Custom:
                            if let loader = customLoader {
                                loader.removeFromSuperview()
                            }
                        }
                        
                        if adType == .custom_Native {
                            parentView.setup_NativeCustomAdView(adView: nativeAdView!, starRatingHeight: starRatingHeight,starRatingTintColor: starRatingColor) {
                                isAdShown(true)
                            }
                        }
                        else {
                            parentView.setup_NativeAdView(adType: adType, adColor: nativeAdColors) {
                                isAdShown(true)
                            }
                        }
                    }
                }
                self.nativeAd_Reload = {
                    isClick()
                }
            }
        }
        else{
            isAdShown(false)
        }
    }
}

// MARK: - Network Reachability
extension GoogleAd_Manager
{
    private func checkForNetworkReachability()
    {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening( onUpdatePerforming: { [self] _ in
            if let isNetworkReachable = reachabilityManager?.isReachable,
               isNetworkReachable == true
            {
                if (bannerViewAd != nil && Banner_ID != "") {
                    load_BannerAd()
                }
                if (interstitialAd != nil && Int_ID != "") {
                    load_InterstitialAd()
                }
                if (native_Ad != nil && Native_ID != "") {
                    load_NativeAd()
                }
                if (rewardedAd != nil && Rewarded_ID != ""){
                    load_RewardedAd()
                }
                if (rewardedIntAd != nil && RewardedInt_ID != "") {
                    load_RewardedIntAd()
                }
                if (appOpenAd != nil && AppOpen_ID != "") {
                    load_OpenAd()
                }
            }
        })
    }
}

// MARK: - GADBannerAd
extension GoogleAd_Manager
{
    private func load_BannerAd()
    {
        if Banner_ID == "" {
            fatalError("Vasundhara 🏢 - Google Ad : BannerAd Id Not Initialise Properly.")
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !Purchase_flag && !isBannerAdLoaded {
                bannerViewAd = GADBannerView()
                bannerViewAd.delegate = self
                bannerViewAd.adUnitID = Banner_ID
                bannerViewAd.rootViewController = funGetTopViewController()
                bannerViewAd.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
                bannerViewAd.load(GADRequest())
            }
        }
    }
}

//MARK: - Interstitial Ad
extension GoogleAd_Manager
{
    private func load_InterstitialAd()
    {
        if Int_ID == "" {
            fatalError("Vasundhara 🏢 - Google Ad : InterstitialAd Id Not Initialise Properly.")
        }
        
        interstitialAd = nil
        if !Purchase_flag && Reachability_Manager.isConnectedToNetwork() && !isRequeSendForLoad_IntAd
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
        if Rewarded_ID == "" {
            fatalError("Vasundhara 🏢 - Google Ad : RewardedAd Id Not Initialise Properly.")
        }
        
        rewardedAd = nil
        if !Purchase_flag && Reachability_Manager.isConnectedToNetwork() && !isRequeSendForLoad_RewardedAd
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
        if RewardedInt_ID == "" {
            fatalError("Vasundhara 🏢 - Google Ad : RewardedIntAd Id Not Initialise Properly.")
        }
        
        rewardedIntAd = nil
        if !Purchase_flag && Reachability_Manager.isConnectedToNetwork() && !isRequeSendForLoad_RewardedAd
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
        if AppOpen_ID == "" {
            fatalError("Vasundhara 🏢 - Google Ad : AppOpenAd Id Not Initialise Properly.")
        }
        
        appOpenAd = nil
        if !Purchase_flag && Reachability_Manager.isConnectedToNetwork() && !isRequeSendForLoad_AppOpenAd
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
            load_OpenAd()
        }
    }
}



//MARK: - GADBannerView Delegate
extension GoogleAd_Manager : GADBannerViewDelegate
{
    public func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        isAdClickedAndRedirected = true
    }
    
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        if !Purchase_flag {
            bannerViewAd = bannerView
            isBannerAdLoaded = true
            if bannerAd_present != nil {
                bannerAd_present!()
            }
        }
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        load_BannerAd()
    }
}

//MARK: - GADFullScreenContent Delegate
extension GoogleAd_Manager : GADFullScreenContentDelegate
{
    public func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        isAdClickedAndRedirected = true
    }
    
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
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
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
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
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
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


//MARK: - Native Ad
extension GoogleAd_Manager
{
    private func load_NativeAd()
    {
        if Native_ID == "" {
            fatalError("Vasundhara 🏢 - Google Ad : NativeAd Id Not Initialise Properly.")
        }
        
        if !Purchase_flag && Reachability_Manager.isConnectedToNetwork() && !isRequeSendForLoad_NativeAd {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isRequeSendForLoad_NativeAd = true
                let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
                multipleAdsOptions.numberOfAds = 1
                
                self.nativeAd_Loader = GADAdLoader(adUnitID: Native_ID, rootViewController: funGetTopViewController(),
                                              adTypes: [GADAdLoaderAdType.native],
                                              options: [multipleAdsOptions])
                self.nativeAd_Loader.delegate = self
                self.nativeAd_Loader.load(GADRequest())
            }
        }
        else {
            isRequeSendForLoad_NativeAd = false
        }
    }
}

//MARK: - GADNativeAdLoader Delegate
extension GoogleAd_Manager : GADNativeAdLoaderDelegate
{
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: any Error) {
        isLoadedNativeAd = false
        load_NativeAd()
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        isRequeSendForLoad_NativeAd = false
        native_Ad = nativeAd
        native_Ad.delegate = self
        
        isLoadedNativeAd = true
        if nativeAd_LoadDone != nil {
            nativeAd_LoadDone!()
        }
    }
}

//MARK: - GADNativeAd Delegate
extension GoogleAd_Manager : GADNativeAdDelegate
{
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            isAdClickedAndRedirected = true
            if let headLine = native_Ad.headline {
                if let tempVC = funGetTopViewController() {
                    tempVC.openAppStoreForNotClickableAd(headLine)
                }
            }
            if nativeAd_Reload != nil {
                nativeAd_Reload()
            }
            load_NativeAd()
        }
    }
}

//MARK: -
extension UIView
{
    fileprivate func setup_NativeAdView(adType : GADAdTYPE, adColor: NativeAdColors,_ isAdShown : (() -> Void))
    {
        let tempNIBName = adType == .banner_Native ? "NativeBannerAd" : "NativeAd"
        
        guard let nibObjects = Bundle.main.loadNibNamed(tempNIBName, owner: nil, options: nil),
              let adView = nibObjects.first as? GADNativeAdView else { return }
        
        self.subviews.forEach({if $0 is GADNativeAdView{$0.removeFromSuperview()}})
        self.addSubview(adView)
        
        adView.layer.cornerRadius = self.layer.cornerRadius
        adView.layer.masksToBounds = true
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary = ["_nativeAdView": adView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        if adType == .banner_Native {
            adView.set_NativeBanner(adColor: adColor)
            isAdShown()
        }
        else if adType == .full_Native {
            adView.set_NativeFull(adColor: adColor)
            isAdShown()
        }
    }
    
    fileprivate func setup_NativeCustomAdView(adView : GADNativeAdView, starRatingHeight: CGFloat = 0.0, starRatingTintColor: UIColor = .gray, _ isAdShown : (() -> Void))
    {
        let adView = adView
        
        self.subviews.forEach({if $0 is GADNativeAdView{$0.removeFromSuperview()}})
        self.addSubview(adView)
        
        adView.layer.cornerRadius = self.layer.cornerRadius
        adView.layer.masksToBounds = true
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary = ["_nativeAdView": adView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        adView.set_NativeFull(adColor: nil, starRatingHeight: starRatingHeight, starRatingTintColor: starRatingTintColor)
        isAdShown()
    }
}

//MARK: -
extension GADNativeAdView{
    
    fileprivate func set_NativeFull(adColor: NativeAdColors?, starRatingHeight: CGFloat = 0.0, starRatingTintColor: UIColor = .gray)
    {
        let nativeAd =  GoogleAd_Manager.shared.native_Ad!
        
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        self.mediaView?.mediaContent = nativeAd.mediaContent
        
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
        
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction?.uppercased(), for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        if let iconView = (self.iconView as? UIImageView) {
            setAdIcon_NativBanner(iconView, nativeAd.icon)
        }
        
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil
        
        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil
        
        (self.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating,starRatingHeight: starRatingHeight,starRatingTintColor: starRatingTintColor)
        self.starRatingView?.isHidden = nativeAd.starRating == nil
        
        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.callToActionView?.isUserInteractionEnabled = false
        
        if let colors = adColor {
            DispatchQueue.main.async {
                self.backgroundColor = hexStringToUIColor(hex: colors.background)
                (self.headlineView as? UILabel)?.textColor = hexStringToUIColor(hex: colors.headline)
                (self.bodyView as? UILabel)?.textColor = hexStringToUIColor(hex: colors.body)
                (self.storeView as? UILabel)?.textColor = hexStringToUIColor(hex: colors.body)
                (self.priceView as? UILabel)?.textColor = hexStringToUIColor(hex: colors.body)
                (self.advertiserView as? UILabel)?.textColor = hexStringToUIColor(hex: colors.body)
                
                (self.callToActionView as? UIButton)?.backgroundColor = hexStringToUIColor(hex: colors.theme)
                (self.callToActionView as? UIButton)?.setTitleColor(hexStringToUIColor(hex: colors.btnTitle), for: .normal)
                
                if let adView = self.viewWithTag(2000) {
                    adView.backgroundColor = hexStringToUIColor(hex: colors.theme)
                }
                if let lblAd = self.viewWithTag(2001) as? UILabel {
                    lblAd.textColor = hexStringToUIColor(hex: colors.btnTitle)
                }
            }
        }
        
        self.nativeAd = nativeAd
    }
    
    fileprivate func set_NativeBanner(adColor: NativeAdColors)
    {
        let nativeAd = GoogleAd_Manager.shared.native_Ad!
        
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        self.mediaView?.mediaContent = nativeAd.mediaContent
        
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
        
        if let callToActionView = self.callToActionView as? UIButton {
            setActionBtn_NativBanner(callToActionView,nativeAd.callToAction)
        }
        
        if let iconView = (self.iconView as? UIImageView) {
            setAdIcon_NativBanner(iconView,nativeAd.icon)
        }
        
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil
        
        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil
        
        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.callToActionView?.isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            self.backgroundColor = hexStringToUIColor(hex: adColor.background)
            (self.headlineView as? UILabel)?.textColor = hexStringToUIColor(hex: adColor.headline)
            (self.bodyView as? UILabel)?.textColor = hexStringToUIColor(hex: adColor.body)
            (self.storeView as? UILabel)?.textColor = hexStringToUIColor(hex: adColor.body)
            (self.priceView as? UILabel)?.textColor = hexStringToUIColor(hex: adColor.body)
            (self.advertiserView as? UILabel)?.textColor = hexStringToUIColor(hex: adColor.body)
            
            (self.callToActionView as? UIButton)?.backgroundColor = hexStringToUIColor(hex: adColor.theme)
            (self.callToActionView as? UIButton)?.setTitleColor(hexStringToUIColor(hex: adColor.btnTitle), for: .normal)
            
            if let adView = self.viewWithTag(2000) {
                adView.backgroundColor = hexStringToUIColor(hex: adColor.theme)
            }
            if let lblAd = self.viewWithTag(2001) as? UILabel {
                lblAd.textColor = hexStringToUIColor(hex: adColor.btnTitle)
            }
        }
        
        self.nativeAd = nativeAd
    }
    
    
    fileprivate func setAdIcon_NativBanner(_ view : UIView,_ adImg : GADNativeAdImage? = nil)
    {
        if adImg == nil {
            if let fIndex = view.constraints.firstIndex(where: {$0.identifier == "imgWidth"}) {
                view.constraints[fIndex].constant = 0
            }
            if let fIndex = view.superview!.constraints.firstIndex(where: {$0.identifier == "trailingImg"}) {
                view.superview!.constraints[fIndex].constant = 0
            }
        }
        else {
            (view as? UIImageView)?.image = adImg?.image
        }
    }
    
    fileprivate func setActionBtn_NativBanner(_ view : UIButton,_ btnTitle:String? = nil)
    {
        if let fIndex = view.constraints.firstIndex(where: {$0.identifier == "btnWidth"}) {
            if btnTitle == nil {
                view.isHidden = true
                view.constraints[fIndex].constant = 0
            }
            else {
                let tempBtnHeight : CGFloat = UIDevice.current.isiPhone ? 40 : 55
                let tempTitle = " \(btnTitle!) ".uppercased()
                let tempFont = view.titleLabel!.font!
                view.setTitle(tempTitle, for: .normal)
                let tempWidth = tempTitle.getWidthForString(withConstrainedHeight: tempBtnHeight, font: tempFont)
                view.constraints[fIndex].constant = tempWidth + CGFloat(UIDevice.current.isiPhone ? 15 : 20)
                view.titleLabel!.adjustsFontSizeToFitWidth = true
            }
        }
    }
    
    fileprivate func imageOfStars(from starRating: NSDecimalNumber?, starRatingHeight: CGFloat = 0.0, starRatingTintColor: UIColor = .gray) -> UIImage? {
        guard let rating = starRating else { return nil }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        
        // Set a fixed frame for stackView to ensure it has a size
        let starSize: CGFloat = starRatingHeight // Size of each star
        let width = starSize * CGFloat(5) + 4 * CGFloat(4) // 5 stars with spacing of 4
        let height: CGFloat = starRatingHeight // Height of a single row of stars
        
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        // Determine how many full, half, and empty stars
        let fullStars = Int(floor(rating.doubleValue))
        let halfStars = rating.doubleValue - Double(fullStars) >= 0.5 ? 1 : 0
        let emptyStars = 5 - fullStars - halfStars
        
        // Add full stars with tint color
        for _ in 0..<fullStars {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate))
            starImageView.tintColor = starRatingTintColor
            stackView.addArrangedSubview(starImageView)
        }
        
        // Add half star with tint color
        if halfStars == 1 {
            let halfStarImageView = UIImageView(image: UIImage(systemName: "star.leadinghalf.filled")?.withRenderingMode(.alwaysTemplate))
            halfStarImageView.tintColor = starRatingTintColor
            stackView.addArrangedSubview(halfStarImageView)
        }
        
        // Add empty stars with tint color
        for _ in 0..<emptyStars {
            let emptyStarImageView = UIImageView(image: UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate))
            emptyStarImageView.tintColor = starRatingTintColor
            stackView.addArrangedSubview(emptyStarImageView)
        }
        
        // Convert the UIStackView to an image
        return renderViewAsImage(view: stackView)
    }
    
    
    // Helper function to render the UIView as UIImage
    private func renderViewAsImage(view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { ctx in
            view.layer.render(in: ctx.cgContext)
        }
    }
}

