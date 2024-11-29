//
//  CustomShadowView.swift
//  iOS_CommonCode
//
//  Created by IOS on 29/11/24.
//

import UIKit

@IBDesignable
class CustomShadowView: UIView {
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    @IBInspectable var shadowOpacity: Float = 0.35
    @IBInspectable var shadowRadius: CGFloat = 3.0
    @IBInspectable var shadowColor: UIColor = hexStringToUIColor(hex: "474747").withAlphaComponent(0.15)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
    }
    
    func applyShadow() {
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
    }
}
