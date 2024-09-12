//
//  UIView+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import UIKit
import MBProgressHUD

//MARK: - Loader
extension UIView
{
    func startLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self, animated: true)
        }
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
}

//MARK: - Gradient
extension UIView
{
    public func addGradient(colors: [UIColor], locations: [NSNumber] = [0.0, 1.0], startPt: CGPoint = CGPoint(x: 0.0, y: 1.0), endPt: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map{ $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        if let _ = self.layer.sublayers?.first as? CAGradientLayer {
            layer.sublayers?[0] = gradientLayer
        } else {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
    
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
        case .adptive_Banner:
            tempNIBName = "Shimmer_Adptiv_Banner"
        }
        
        guard let nibObjects = Bundle.main.loadNibNamed(tempNIBName, owner: nil, options: nil),
              let adShimmerView = nibObjects.first as? Shimmer_FullNative else { return }
        
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
