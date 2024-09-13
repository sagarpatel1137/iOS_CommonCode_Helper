//
//  SplashVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit
import iOS_CommonCode_Helper

class SplashVC: UIViewController {

    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var viewBanner_Height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddFirebaseEvent(eventName: .SplashShow)
        
        viewBanner_Height.constant = GoogleAd_Manager.shared.funGetAdaptiveBannerHeight()
        GoogleAd_Manager.shared.funShowCollapsibleBannerAd(parentView: viewBanner)
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 10.0) { [self] in
            
            RevenueCat_Manager.shared.funCheckForPurchase {
                
                if AppLaungauge_Code == "" {
                    self.funOpenLanguageScreen()
                }
                else {
                    self.funOpenHomeScreen()
                }
            }
        }
    }

}

extension SplashVC
{
    func funOpenLanguageScreen() {
        let vc = LanaguageSelectVC()
        vc.modalPresentationStyle = .fullScreen
        vc.isFromInitial = true
        vc.completionLangSelected = {
            self.funOpenHomeScreen()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func funOpenHomeScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuideVC")
        let navController = UINavigationController(rootViewController: vc!)
        UIApplication.shared.windows.first?.rootViewController = navController
    }
}
