//
//  ThankYouVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 11/09/24.
//

import UIKit

//MARK: Cusmization
public struct UICustomizationSubThankYouTheme {
    public var textColor: UIColor?
    public var btnGetStartedTextColor: UIColor?
    public var btnGetStartedFromColor: UIColor?
    public var btnGetStartedToColor: UIColor?
    public var imgPlaceholder: UIImage?
    
    public init(textColor: UIColor? = nil, btnGetStartedTextColor: UIColor? = nil, btnGetStartedFromColor: UIColor? = nil, btnGetStartedToColor: UIColor? = nil, imgPlaceholder: UIImage? = nil) {
        self.textColor = textColor ?? .black
        self.btnGetStartedTextColor = btnGetStartedTextColor ?? .white
        self.btnGetStartedFromColor = btnGetStartedFromColor ?? hexStringToUIColor(hex: "00C6FB")
        self.btnGetStartedToColor = btnGetStartedToColor ?? hexStringToUIColor(hex: "005BEA")
        self.imgPlaceholder = imgPlaceholder ?? ImageHelper.image(named: "sub_thankyou_Bg")
    }
}

public struct UICustomizationSubThankYouData {
    public var titleTextColor: String?
    public var descriptionTextColor: String?
    public var getStartedTextColor: String?
    
    public init(titleTextColor: String? = nil, descriptionTextColor: String? = nil, getStartedTextColor: String? = nil) {
        self.titleTextColor = titleTextColor ?? "Thank You For Subscription"
        self.descriptionTextColor = descriptionTextColor ?? "Now you can enjoy the service!"
        self.getStartedTextColor = getStartedTextColor ?? "Get Started"
    }
}

public class ThankYouVC: UIViewController {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnStart: UIButton!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    
    public var customizationSubThankYouTheme = UICustomizationSubThankYouTheme()
    public var customizationSubThankYouData = UICustomizationSubThankYouData()
    public var subCloseCompletionBlock:SubCloseCompletionBlock = .unknown
    public var param: [String: String]?
    public var isOpenFrom = ""
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        if self.subCloseCompletionBlock == .restoreSuccess {
            AddFirebaseEvent(eventName: .SubThankYouShow, parameters: [
                "from": self.isOpenFrom,
                "sku" : "RESTORE",
                "type" : "RESTORE"
            ])
        } else if self.subCloseCompletionBlock == .purchaseSuccess, let param = self.param {
            AddFirebaseEvent(eventName: .SubThankYouShow, parameters: [
                "from": self.isOpenFrom,
                "sku" : param["sku"] ?? "",
                "type" : param["type"] ?? ""
            ])
        }
        
        setUI()
        setText()
        setFont()
        updateUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
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
        self.lblTitle.font = setCustomFont(name: .WorkSans_SemiBold, iPhoneSize: 22, iPadSize: 38)
        self.lblSubTitle.font = setCustomFont(name: .WorkSans_Medium, iPhoneSize: 12, iPadSize: 21)
        btnStart.titleLabel?.font = setCustomFont(name: .WorkSans_SemiBold, iPhoneSize: 18, iPadSize: 27)
        
        if Pod_AppLaungauge_Code == "ur" {
            self.lblTitle.font = UIFont(name: lblTitle.font.fontName, size: lblTitle.font.pointSize-2)
            self.lblSubTitle.font = UIFont(name: lblSubTitle.font.fontName, size: lblSubTitle.font.pointSize-2)
            btnStart.titleLabel?.font = UIFont(name: btnStart.titleLabel!.font.fontName, size: btnStart.titleLabel!.font.pointSize-2)
        }
    }
    
    //MARK: - Actions
    @IBAction func btnGetStartedAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension ThankYouVC {
    private func updateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            let from = self.customizationSubThankYouTheme.btnGetStartedFromColor ?? hexStringToUIColor(hex: "00C6FB")
            let to = self.customizationSubThankYouTheme.btnGetStartedToColor ?? hexStringToUIColor(hex: "005BEA")
            self.btnStart.addGradient(colors: [from, to])
            self.imgPlaceholder.image = self.customizationSubThankYouTheme.imgPlaceholder
            self.btnStart.setTitleColor(self.customizationSubThankYouTheme.btnGetStartedToColor, for: .normal)
            self.lblTitle.textColor = self.customizationSubThankYouTheme.textColor
            self.lblSubTitle.textColor = self.customizationSubThankYouTheme.textColor
        }
        
        self.lblTitle.text = self.customizationSubThankYouData.titleTextColor?.localized()
        self.lblSubTitle.text = self.customizationSubThankYouData.descriptionTextColor?.localized()
        self.btnStart.setTitle(self.customizationSubThankYouData.getStartedTextColor?.localized().localized(), for: .normal)
    }
}
