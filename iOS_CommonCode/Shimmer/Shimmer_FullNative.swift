//
//  Shimmer_FullNative.swift
//  Vehicle_Information
//
//  Created by qa on 12/06/24.
//  Copyright © 2024 Vasundhara Vision. All rights reserved.
//

import UIKit
import Foundation

class Shimmer_FullNative:UIView{
    
    @IBOutlet var vwForShimmer: [CustomShimmer]!
    
    func startShimmer(color:UIColor = .systemBackground){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.vwForShimmer.forEach({
                $0.startShimmer(bgColor: color)
            })
        }
    }
    
    func stopShimmer(){
        vwForShimmer.forEach({
            $0.stopShimmer()
        })
    }
}
