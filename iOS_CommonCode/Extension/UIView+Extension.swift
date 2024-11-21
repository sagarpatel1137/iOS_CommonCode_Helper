//
//  UIView+Extension.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/09/24.
//

import UIKit

extension UIView {
    @IBInspectable var CRadiusBottom: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = newValue > 0
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
            layer.cornerRadius =  UIDevice.current.isiPhone ? newValue : (newValue*1.5)
        }
    }
    
    @IBInspectable var CRadiusTop: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = newValue > 0
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
            layer.cornerRadius =  UIDevice.current.isiPhone ? newValue : (newValue*1.5)
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
    
    func addBottomViewShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.35
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = hexStringToUIColor(hex: "474747").withAlphaComponent(0.15).cgColor
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
    
    public func addGradient(colors: [UIColor], locations: [NSNumber] = [0.0, 1.0], startPt: CGPoint = CGPoint(x: 0.0, y: 1.0), endPt: CGPoint = CGPoint(x: 1.0, y: 1.0), cornerRadius: CGFloat? = nil, isRounded: Bool? = nil) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map{ $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        if let cornerRadius = cornerRadius {
            gradientLayer.cornerRadius = cornerRadius
        }
        if let isRounded = isRounded, isRounded == true {
            gradientLayer.cornerRadius = self.bounds.height/2
        }
        if let _ = self.layer.sublayers?.first as? CAGradientLayer {
            layer.sublayers?[0] = gradientLayer
        } else {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
