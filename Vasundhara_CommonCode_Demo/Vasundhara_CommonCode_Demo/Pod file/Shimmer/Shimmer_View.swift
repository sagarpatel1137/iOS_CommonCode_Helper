//
//  Shimmer_View.swift
//  Vehicle_Information
//
//  Created by qa on 12/06/24.
//  Copyright © 2024 Vasundhara Vision. All rights reserved.
//

import UIKit
import Foundation

public class Shimmer_View:UIView{
    
    @IBOutlet public var vwForShimmer: [CustomShimmer]!
    
    public func startShimmer(color:UIColor = .systemBackground){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.vwForShimmer.forEach({
                $0.startShimmer(bgColor: color)
            })
        }
    }
    
    public func stopShimmer(){
        vwForShimmer.forEach({
            $0.stopShimmer()
        })
    }
}
