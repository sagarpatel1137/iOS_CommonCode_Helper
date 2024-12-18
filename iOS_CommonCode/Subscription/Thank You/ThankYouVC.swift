//
//  ThankYouVC.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 11/09/24.
//

import UIKit

//MARK: Cusmization
public struct UICustomizationSubThankYouTheme {
    public var mainViewColor: UIColor?
    public var textColor: UIColor?
    public var btnGetStartedTextColor: UIColor?
    public var btnGetStartedFromColor: UIColor?
    public var btnGetStartedToColor: UIColor?
    public var imgPlaceholder: UIImage?
    
    public init(mainViewColor: UIColor? = nil, textColor: UIColor? = nil, btnGetStartedTextColor: UIColor? = nil, btnGetStartedFromColor: UIColor? = nil, btnGetStartedToColor: UIColor? = nil, imgPlaceholder: UIImage? = nil) {
        self.mainViewColor = mainViewColor ?? .white
        self.textColor = textColor ?? .black
        self.btnGetStartedTextColor = btnGetStartedTextColor ?? .white
        self.btnGetStartedFromColor = btnGetStartedFromColor ?? hexStringToUIColor(hex: "00C6FB")
        self.btnGetStartedToColor = btnGetStartedToColor ?? hexStringToUIColor(hex: "005BEA")
        self.imgPlaceholder = imgPlaceholder ?? ImageHelper.image(named: "sub_thankyou_Bg")
    }
}

public struct UICustomizationSubThankYouData {
    public var titleText: String?
    public var descriptionText: String?
    public var getStartedText: String?
    
    public init(titleText: String? = nil, descriptionText: String? = nil, getStartedText: String? = nil) {
        self.titleText = titleText ?? "Thank You For Subscription".localized()
        self.descriptionText = descriptionText ?? "Now you can enjoy the service!".localized()
        self.getStartedText = getStartedText ?? "Get Started".localized()
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
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    var completionGetStart: (()->())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.subCloseCompletionBlock == .restoreSuccess {
            AddFirebaseEvent(eventName: .SubThankYouShow, parameters: [
                "sku" : "RESTORE",
                "type" : "RESTORE"
            ])
        } else if self.subCloseCompletionBlock == .purchaseSuccess, let param = self.param {
            AddFirebaseEvent(eventName: .SubThankYouShow, parameters: [
                "sku" : param["sku"] ?? "",
                "type" : param["type"] ?? ""
            ])
        } else if self.subCloseCompletionBlock == .trialSuccess, let param = self.param {
            AddFirebaseEvent(eventName: .SubThankYouShow, parameters: [
                "sku" : param["sku"] ?? "",
                "type" : param["type"] ?? ""
            ])
        }
        
        setFont()
        updateUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUI()
    }
    
    //MARK: -
    private func setUI() {
        btnStart.layer.cornerRadius = 15
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            let from = self.customizationSubThankYouTheme.btnGetStartedFromColor ?? hexStringToUIColor(hex: "00C6FB")
            let to = self.customizationSubThankYouTheme.btnGetStartedToColor ?? hexStringToUIColor(hex: "005BEA")
            self.btnStart.addGradient(colors: [from, to])
        }
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
        completionGetStart?()
    }
}

extension ThankYouVC {
    private func updateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.view.backgroundColor = self.customizationSubThankYouTheme.mainViewColor ?? .white
            self.lblTitle.textColor = self.customizationSubThankYouTheme.textColor ?? .white
            let from = self.customizationSubThankYouTheme.btnGetStartedFromColor ?? hexStringToUIColor(hex: "00C6FB")
            let to = self.customizationSubThankYouTheme.btnGetStartedToColor ?? hexStringToUIColor(hex: "005BEA")
            self.btnStart.addGradient(colors: [from, to])
            self.imgPlaceholder.image = self.customizationSubThankYouTheme.imgPlaceholder
            self.btnStart.setTitleColor(self.customizationSubThankYouTheme.btnGetStartedTextColor, for: .normal)
            self.lblTitle.textColor = self.customizationSubThankYouTheme.textColor
            self.lblSubTitle.textColor = self.customizationSubThankYouTheme.textColor
        }
        
        self.lblTitle.text = self.customizationSubThankYouData.titleText
        self.lblSubTitle.text = self.customizationSubThankYouData.descriptionText
        self.btnStart.setTitle(self.customizationSubThankYouData.getStartedText, for: .normal)
    }
}
