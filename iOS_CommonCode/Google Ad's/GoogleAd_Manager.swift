//
//  GoogleAd_Manager.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import GoogleMobileAds
import Alamofire

public enum GADAdTYPE
{
    case banner_Native
    case full_Native
    case adptive_Banner
    case custom_Native
}

public class GoogleAd_Manager : NSObject {

    //MARK: - Public
    public static let shared = GoogleAd_Manager()
    
    public var isAdClickedAndRedirected = false
    
    //MARK: - Private
    private var Collapsible_Banner_ID = ""
    private var Banner_ID = ""
    private var Int_ID = ""
    private var Native_ID = ""
    private var Rewarded_ID = ""
    private var RewardedInt_ID = ""
    private var AppOpen_ID = ""
    
    //Collapsible BannerAd
    private var collapsibleBannerViewAd : GADBannerView!
    private var isRequeSendForLoad_CollapsibleBannerAd = false
    private var collapsibleBannerAd_present : (() -> Void)?
    private var isCollapsibleBannerAdLoaded = false
    
    //Adaptive BannerAd
    private var bannerViewAd : GADBannerView!
    private var bannerAd_present : (() -> Void)?
    private var isBannerAdLoaded = false
    
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
    
    //Native Ad
    public var native_Ad : GADNativeAd!
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
    public func initialiseGoogleAds(collapsibleBannerAd : String = "", bannerAd: String = "", intAd: String = "", nativeAd: String = "", rewardAd: String = "", rewardIntAd: String = "", appOpenAd: String = "", testDevices: [String] = []) {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDevices
        
        if collapsibleBannerAd != "" {
            Collapsible_Banner_ID = collapsibleBannerAd
            load_CollapsibleBannerAd()
        }
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
}

//MARK: - Ad Show
extension GoogleAd_Manager
{
    public func funShowCollapsibleBannerAd(parentView: UIView)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
            
            if !Purchase_flag {
                
                if isCollapsibleBannerAdLoaded {
                    if collapsibleBannerAd_present != nil {
                        collapsibleBannerAd_present!()
                    }
                    parentView.addSubview(collapsibleBannerViewAd)
                }
                else {
                    load_CollapsibleBannerAd()
                    parentView.addSubview(collapsibleBannerViewAd)
                }
            }
        }
    }

    public func funShowBannerAd(parentView: UIView)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
            
            if !Purchase_flag {
                
                parentView.addShimmerViewForAdType(adType: .adptive_Banner)
                if isBannerAdLoaded {
                    if bannerAd_present != nil {
                        parentView.removeShimmerViewForAdType()
                        bannerAd_present!()
                    }
                    parentView.addSubview(bannerViewAd)
                }
                else {
                    load_BannerAd()
                    bannerAd_present = {
                        parentView.removeShimmerViewForAdType()
                    }
                    parentView.addSubview(bannerViewAd)
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
    
    public func funShowNativeAd(adType : GADAdTYPE, parentView: UIView, shimerView : Shimmer_View? = nil, nativeAdView: GADNativeAdView? = nil, isAdShown : @escaping ((Bool) -> Void), isClick : @escaping (() -> Void), isNewLoad : @escaping (() -> Void))
    {
        var adtype = adType
        
        if adtype == .custom_Native && (shimerView == nil && nativeAdView == nil) {
            adtype = .full_Native
        }
        
        if adtype != .custom_Native {
            parentView.backgroundColor = .clear
            parentView.layer.shadowColor = UIColor.darkGray.cgColor
            parentView.layer.shadowRadius = 3
            parentView.layer.shadowOpacity = 0.3
            parentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            parentView.layer.masksToBounds = false
            parentView.layer.cornerRadius = UIDevice.current.isiPhone ? 10:15
            parentView.addShimmerViewForAdType(adType: adtype)
        }
        else {
            parentView.addCustomShimmerViewForAd(adShimmerView: shimerView!)
        }
        
        if Reachability.isConnectedToNetwork()
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){[self] in
                if self.isLoadedNativeAd {
                    if adtype == .custom_Native {
                        parentView.setup_NativeCustomAdView(adView: nativeAdView!) {
                            isAdShown(true)
                        }
                    }
                    else {
                        parentView.setup_NativeAdView(adType: adtype) {
                            isAdShown(true)
                        }
                    }
                    
                }
                else {
                    self.nativeAd_LoadDone = {
                        if adtype == .custom_Native {
                            parentView.setup_NativeCustomAdView(adView: nativeAdView!) {
                                isAdShown(true)
                            }
                        }
                        else {
                            parentView.setup_NativeAdView(adType: adtype) {
                                isAdShown(true)
                            }
                        }
                    }
                }
                self.nativeAd_Reload = {
                    isClick()
                }
                self.nativeAd_LoadDone = {
                    isNewLoad()
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
                if (collapsibleBannerViewAd != nil && Collapsible_Banner_ID != "") {
                    load_CollapsibleBannerAd()
                }
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
    private func load_CollapsibleBannerAd()
    {
        if !Purchase_flag && !isCollapsibleBannerAdLoaded && !isRequeSendForLoad_CollapsibleBannerAd {
            
            isRequeSendForLoad_CollapsibleBannerAd = true
            collapsibleBannerViewAd = GADBannerView()
            collapsibleBannerViewAd.delegate = self
            collapsibleBannerViewAd.adUnitID = Collapsible_Banner_ID
            collapsibleBannerViewAd.rootViewController = funGetTopViewController()
            collapsibleBannerViewAd.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
            
            let request = GADRequest()
            let extras = GADExtras()
            extras.additionalParameters = ["collapsible" : "bottom"]
            request.register(extras)
            
            collapsibleBannerViewAd.load(request)
        }
    }
    
    private func load_BannerAd()
    {
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
            if bannerView.isCollapsible {
                isRequeSendForLoad_CollapsibleBannerAd = false
                collapsibleBannerViewAd = bannerView
                isCollapsibleBannerAdLoaded = true
                if collapsibleBannerAd_present != nil {
                    collapsibleBannerAd_present!()
                }
            }
            else {
                bannerViewAd = bannerView
                isBannerAdLoaded = true
                if bannerAd_present != nil {
                    bannerAd_present!()
                }
            }
        }
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        if bannerView.isCollapsible {
            isRequeSendForLoad_CollapsibleBannerAd = false
            load_CollapsibleBannerAd()
        } else {
            load_BannerAd()
        }
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
        if !Purchase_flag && Reachability.isConnectedToNetwork() && !isRequeSendForLoad_NativeAd {
            
            isRequeSendForLoad_NativeAd = true
            let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
            multipleAdsOptions.numberOfAds = 1
            
            nativeAd_Loader = GADAdLoader(adUnitID: Native_ID, rootViewController: UIViewController(),
                                   adTypes: [GADAdLoaderAdType.native],
                                   options: [multipleAdsOptions])
            nativeAd_Loader.delegate = self
            nativeAd_Loader.load(GADRequest())
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

//MARK: -
extension UIView
{
    fileprivate func setup_NativeAdView(adType : GADAdTYPE,_ isAdShown : (() -> Void))
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
            adView.set_NativeBanner()
            isAdShown()
        }
        else if adType == .full_Native {
            adView.set_NativeFull()
            isAdShown()
        }
        self.removeShimmerViewForAdType()
    }
    
    fileprivate func setup_NativeCustomAdView(adView : GADNativeAdView,_ isAdShown : (() -> Void))
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
        adView.set_NativeFull()
        isAdShown()
        self.removeShimmerViewForAdType()
    }
}

//MARK: -
extension GADNativeAdView{
    
    fileprivate func set_NativeFull()
    {
        let nativeAd =  GoogleAd_Manager.shared.native_Ad!
        
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        self.mediaView?.mediaContent = nativeAd.mediaContent
        
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
        
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction?.uppercased(), for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        setAdIcon_NativBanner((self.iconView as! UIImageView),nativeAd.icon)
        
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil
        
        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil
        
        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.callToActionView?.isUserInteractionEnabled = false
        
        self.nativeAd = nativeAd
    }
    
    fileprivate func set_NativeBanner()
    {
        let nativeAd = GoogleAd_Manager.shared.native_Ad!
                
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        self.mediaView?.mediaContent = nativeAd.mediaContent
       
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
        
        setActionBtn_NativBanner(self.callToActionView as! UIButton,nativeAd.callToAction)
        
        setAdIcon_NativBanner((self.iconView as! UIImageView),nativeAd.icon)
        
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil
        
        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil
        
        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.callToActionView?.isUserInteractionEnabled = false
        
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
}
