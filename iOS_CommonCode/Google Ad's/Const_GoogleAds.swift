//
//  Const_GoogleAds.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 16/09/24.
//

public enum LoaderType
{
    case Shimmer
    case AdsByDeveloper
    case Custom
}

public enum GADAdTYPE
{
    //For Native
    case banner_Native
    case full_Native
    case custom_Native
    
    //For Banner Ad
    case banner_Adaptive
}

public struct NativeAdColors {
    
    public var background : String
    public var theme : String
    public var body : String
    public var btnTitle : String
    
    public init(bgColor: String = GoogleAd_Manager.shared.nativeAdColors.background, themeColor: String = GoogleAd_Manager.shared.nativeAdColors.theme, bodyColor: String = GoogleAd_Manager.shared.nativeAdColors.body, btnTitleColor: String = GoogleAd_Manager.shared.nativeAdColors.btnTitle) {
        
        self.background = bgColor
        self.theme = themeColor
        self.body = bodyColor
        self.btnTitle = btnTitleColor
    }
}
