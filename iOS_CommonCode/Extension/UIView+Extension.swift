//
//  UIView+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import UIKit
    
//MARK: - Shimmer
extension UIView
{
    public func addShimmerViewForAdType(adType : GADAdTYPE){
        
        var tempNIBName = "Shimmer_Adptiv_Banner"
        
        switch adType {
        case .full_Native:
            tempNIBName = "Shimmer_FullNative"
        case .banner_Native:
            tempNIBName = "Shimmer_NativeBannerAd"
        case .banner_Adaptive:
            tempNIBName = "Shimmer_Adptiv_Banner"
        case .custom_Native:
            break
        }
        
        guard let nibObjects = Bundle.main.loadNibNamed(tempNIBName, owner: nil, options: nil),
              let adShimmerView = nibObjects.first as? Shimmer_View else { return }
        
        adShimmerView.layer.cornerRadius = self.layer.cornerRadius
        adShimmerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        adShimmerView.tag = 5050
        
        removeShimmerViewForAdType()
        
        addSubview(adShimmerView)
        adShimmerView.startShimmer()
    }
    
    public func addCustomShimmerViewForAd(adShimmerView : Shimmer_View){
        
        adShimmerView.layer.cornerRadius = self.layer.cornerRadius
        adShimmerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        adShimmerView.tag = 5050
        
        removeShimmerViewForAdType()
        
        addSubview(adShimmerView)
        adShimmerView.startShimmer()
    }
    
    public func removeShimmerViewForAdType(){
        RemoveAllSubviewWithTAG(tag: 5050)
    }
    
    fileprivate func GetSubviewExistWithTag(tag:Int) -> UIView?{
        return subviews.first(where: {$0.tag == tag})
    }
    
    fileprivate func RemoveAllSubviewWithTAG(tag:Int? = nil){
        subviews.forEach { vw in
            if tag == nil || vw.tag == (tag ?? 0){
                vw.removeFromSuperview()
            }
        }
    }
    
    fileprivate func RemoveAllSubviewExceptGivenTag(arrTag:[Int]){
        subviews.forEach { vw in
            if !arrTag.contains(vw.tag){
                vw.removeFromSuperview()
            }
        }
    }
}

extension UIView
{
    public func addAdByDeveloperViewForAd(isForBannerAd : Bool, textColor : UIColor){
        
        let view = UIView(frame: self.bounds)
        view.tag = 4040
        view.layer.masksToBounds = true
        if !isForBannerAd {
            view.layer.cornerRadius = UIDevice.current.isiPhone ? 10:15
        }
        let lbl = UILabel(frame: view.bounds)
        lbl.textAlignment = .center
        lbl.text = "Ads by developer"
        lbl.backgroundColor = hexStringToUIColor(hex: "DDDDDD", alpha: isForBannerAd ? 0.3 : 0.1)
        lbl.textColor = textColor
        
        removeAdByDeveloperViewForAd()
        
        view.addSubview(lbl)
        addSubview(view)
    }
    
    public func removeAdByDeveloperViewForAd(){
        RemoveAllSubviewWithTAG(tag: 4040)
    }
}
