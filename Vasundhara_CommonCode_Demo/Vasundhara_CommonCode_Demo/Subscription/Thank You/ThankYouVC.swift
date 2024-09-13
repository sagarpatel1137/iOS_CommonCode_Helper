//
//  ThankYouVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 11/09/24.
//

import UIKit

class ThankYouVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnStart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddFirebaseEvent(eventName: EventsValues.SubThankYou)
        
        setUI()
        setText()
        setFont()
    }
    
    //MARK: -
    private func setUI() {
        btnStart.layer.cornerRadius = 15
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            let from = hexStringToUIColor(hex: "#00C6FB")
            let to = hexStringToUIColor(hex: "#005BEA")
            self.btnStart.addGradient(colors: [from, to])
        }
    }
    
    private func setText() {
        self.lblTitle.text = "Thank You For Subscription".localized()
        self.lblSubTitle.text = "Now you can enjoy the service!".localized()
        btnStart.setTitle("Get Started".localized(), for: .normal)
    }
    
    private func setFont() {
        
        self.lblTitle.font = setCustomFont(name: WorkSans_SemiBold, iPhoneSize: 22, iPadSize: 38)
        self.lblSubTitle.font = setCustomFont(name: WorkSans_Medium, iPhoneSize: 12, iPadSize: 21)
        btnStart.titleLabel?.font = setCustomFont(name: WorkSans_SemiBold, iPhoneSize: 18, iPadSize: 27)
        
        if AppLaungauge_Code == "ur" {
            self.lblTitle.font = UIFont(name: lblTitle.font.fontName, size: lblTitle.font.pointSize-2)
            self.lblSubTitle.font = UIFont(name: lblSubTitle.font.fontName, size: lblSubTitle.font.pointSize-2)
            btnStart.titleLabel?.font = UIFont(name: btnStart.titleLabel!.font.fontName, size: btnStart.titleLabel!.font.pointSize-2)
        }
    }
    
    //MARK: -
    
    
    //MARK: - Actions
    @IBAction func btnGetStartedAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
