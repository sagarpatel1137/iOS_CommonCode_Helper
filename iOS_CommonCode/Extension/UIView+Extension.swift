//
//  UIView+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import UIKit

extension UIView
{
    func addShimmerViewForADType(adType : GADAdTYPE){
        
        var tempNIBName = ""
        
        switch adType {
        case .full_Nativ:
            tempNIBName = "Shimmer_FullNative"
        case .banner_Nativ:
            tempNIBName = "Shimmer_NativeBannerAd"
        case .adptive_Banner:
            tempNIBName = "Shimmer_Adptiv_Banner"
        }
        
        guard let nibObjects = Bundle.main.loadNibNamed(tempNIBName, owner: nil, options: nil),
              let adShimmerView = nibObjects.first as? Shimmer_FullNative else { return }
        
        adShimmerView.layer.cornerRadius = self.layer.cornerRadius
        adShimmerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        adShimmerView.tag = 5050
        
        removeShimmerViewForADType()
        
        addSubview(adShimmerView)
        adShimmerView.startShimmer()
    }
    
    func removeShimmerViewForADType(){
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
