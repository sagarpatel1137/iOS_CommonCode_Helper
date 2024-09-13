//
//  GuideVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit
import iOS_CommonCode_Helper

class GuideVC: UIViewController {

    @IBOutlet weak var btn_GoogleAds: UIButton!
    @IBOutlet weak var btn_Subscription_Timeline: UIButton!
    @IBOutlet weak var btn_Subscription_AllPlan: UIButton!
    @IBOutlet weak var btn_Subscription_Discount: UIButton!
    @IBOutlet weak var btn_FeedBack: UIButton!
    @IBOutlet weak var btn_Rating: UIButton!
    @IBOutlet weak var btn_WebView: UIButton!
    @IBOutlet weak var btn_Language: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        btn_GoogleAds.titleLabel?.numberOfLines = 0
        btn_Subscription_Timeline.titleLabel?.numberOfLines = 0
        btn_Subscription_AllPlan.titleLabel?.numberOfLines = 0
        btn_Subscription_Discount.titleLabel?.numberOfLines = 0
        btn_FeedBack.titleLabel?.numberOfLines = 0
        btn_Rating.titleLabel?.numberOfLines = 0
        btn_WebView.titleLabel?.numberOfLines = 0
        btn_Language.titleLabel?.numberOfLines = 0
        
        btn_GoogleAds.titleLabel?.textAlignment = .center
        btn_Subscription_Timeline.titleLabel?.textAlignment = .center
        btn_Subscription_AllPlan.titleLabel?.textAlignment = .center
        btn_Subscription_Discount.titleLabel?.textAlignment = .center
        btn_FeedBack.titleLabel?.textAlignment = .center
        btn_Rating.titleLabel?.textAlignment = .center
        btn_WebView.titleLabel?.textAlignment = .center
        btn_Language.titleLabel?.textAlignment = .center
    }
    
    @IBAction func btn_GoogleAds_Click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoogleAdsVC") as! GoogleAdsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Subscription_Timeline_Click(_ sender: Any)
    {
        if isSubPriceAvailable(isShowToast: false) {
            
            let vc = SubTimelineVC()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionTimeline = { result in
                if result == "close" {
                }
                else if result == "success" {
                    let thankVC = ThankYouVC()
                    thankVC.modalPresentationStyle = .overFullScreen
                    thankVC.modalTransitionStyle = .crossDissolve
                    self.present(thankVC, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btn_Subscription_AllPlan_Click(_ sender: Any) 
    {
        if isSubPriceAvailable() {
            
            let vc = SubAllPlanVC()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionMorePlan = { result in
                if result == "close" {
                }
                else if result == "success" {
                    let thankVC = ThankYouVC()
                    thankVC.modalPresentationStyle = .overFullScreen
                    thankVC.modalTransitionStyle = .crossDissolve
                    self.present(thankVC, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btn_Subscription_Discount_Click(_ sender: Any)
    {
        if isSubPriceAvailable() && isSubDiscountAvailable() {
            
            let vc = SubDiscountVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionDiscount = { result in
                if result == "close" {
                }
                else if result == "success" {
                    let thankVC = ThankYouVC()
                    thankVC.modalPresentationStyle = .overFullScreen
                    thankVC.modalTransitionStyle = .crossDissolve
                    self.present(thankVC, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        else {
            self.view.makeToast("Discount offer is not Available - need to remove this toast while production")
        }
    }
    
    @IBAction func btn_FeedBack_Click(_ sender: Any) 
    {
        let vc = FeedbackVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_Rating_Click(_ sender: Any) 
    {
        let vc = RatingVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.completionAskMeLater = { result in
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_WebView_Click(_ sender: Any)
    {
        let vc = webVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.titleStr = "WebView"
        vc.urlStr = "https://www.google.com/search?q="
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_Language_Click(_ sender: Any)
    {
        let vc = LanaguageSelectVC()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - Add
extension UIViewController
{
    public func isSubPriceAvailable(isShowToast: Bool = true) -> Bool {
        
        if Purchase_flag {
            if isShowToast {
                self.view.makeToast("Already Purchased".localized())
            }
            return true
        }
        else {
            if SubscriptionConst.isGet {
                return true
            }
            else {
                if isShowToast {
                    if Reachability.isConnectedToNetwork() {
                        self.view.makeToast("The billing client is not ready".localized())
                    } else {
                        self.view.makeToast("Check your internet connection".localized())
                    }
                }
                return true
            }
        }
    }
    
    public func isSubDiscountAvailable() -> Bool {
        
        let monthPlan = SubscriptionConst.ActivePlans.one_Month
        if (!Purchase_flag && SubscriptionConst.isGet && !monthPlan.plan_Free_Trail.isFreeTrail && !monthPlan.plan_Promotional_Offer.isPromotionalOffer) {
            return true
        } else {
            return false
        }
    }
    
    
    public func systemAlert(title: String?, message: String?, actionDestructive: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: actionDestructive, style: .destructive, handler: nil)
        alertVC.addAction(action1)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension NSString {
    
    func setAttributeToString(font1: UIFont, font2: UIFont, color1: UIColor, color2: UIColor, text: String) -> NSAttributedString {
        
        let substring1 = self as String

        let attributes1 = [NSMutableAttributedString.Key.font: font1, NSMutableAttributedString.Key.foregroundColor : color1]
        let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)

        let attributes2 = [NSMutableAttributedString.Key.font: font2, NSMutableAttributedString.Key.foregroundColor : color2]

        let range = self.range(of: text)
        attrString1.addAttributes(attributes2, range: range)
        return attrString1
    }
}
