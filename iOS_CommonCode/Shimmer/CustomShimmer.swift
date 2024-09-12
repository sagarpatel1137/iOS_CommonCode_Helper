//
//  CustomShimmer.swift
//  Vehicle_Information
//
//  Created by qa on 23/05/24.
//  Copyright © 2024 Vasundhara Vision. All rights reserved.
//

import Foundation
import UIView_Shimmer

public class CustomShimmer:UIView,ShimmeringViewProtocol{
    
    public var shimmeringAnimatedItems: [UIView] {
        [self]
    }

    public func startShimmer(bgColor:UIColor = .systemBackground){
        DispatchQueue.main.async {
            self.setTemplateWithSubviews(true, animate: true,viewBackgroundColor:bgColor)
        }
    }
    
    public func stopShimmer(){
        DispatchQueue.main.async {
            self.setTemplateWithSubviews(false)
        }
    }
}



