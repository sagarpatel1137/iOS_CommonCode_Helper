//
//  FeedbackVC.swift
//  GPS Map Camera
//
//  Created by iOS on 05/08/24.
//

import UIKit

public struct UICustomizationFeedback {
    public var navigationBarBackground: UIColor?
    public var isShowNavigationBarShadow: Bool?
    public var titleText: String?
    public var titleTextFont: UIFont?
    public var titleTextColor: UIColor?
    public var backButtonImage: UIImage?
    public var placeholderButtonImage: UIImage?
    public var shareExperienceText: String?
    public var shareExperienceFont: UIFont?
    public var shareExperienceTextColor: UIColor?
    public var whyUseText: String?
    public var whyUsePlaceholderText: String?
    public var whyUseTextFont: UIFont?
    public var whyUseTextFontTextfield: UIFont?
    public var whyUseTextColor: UIColor?
    public var suggestionText: String?
    public var suggestionPlaceholderText: String?
    public var suggestionTextFont: UIFont?
    public var suggestionTextFontTextfield: UIFont?
    public var suggestionTextColor: UIColor?
    public var limitTextFont: UIFont?
    public var limitTextColor: UIColor?
    public var submitText: String?
    public var submitTextFont: UIFont?
    public var submitTextColor: UIColor?
    public var submitButtonImage: UIImage?
    
    public init(navigationBarBackground: UIColor? = nil, isShowNavigationBarShadow: Bool? = nil, titleText: String? = nil, titleTextFont: UIFont? = nil, titleTextColor: UIColor? = nil, backButtonImage: UIImage? = nil, placeholderButtonImage: UIImage? = nil, shareExperienceText: String? = nil, shareExperienceFont: UIFont? = nil, shareExperienceTextColor: UIColor? = nil, whyUseText: String? = nil, whyUsePlaceholderText: String? = nil, whyUseTextFont: UIFont? = nil, whyUseTextFontTextfield: UIFont? = nil, whyUseTextColor: UIColor? = nil, suggestionText: String? = nil, suggestionPlaceholderText: String? = nil, suggestionTextFont: UIFont? = nil, suggestionTextFontTextfield: UIFont? = nil, suggestionTextColor: UIColor? = nil, limitTextFont: UIFont? = nil, limitTextColor: UIColor? = nil, submitText: String? = nil, submitTextFont: UIFont? = nil, submitTextColor: UIColor? = nil, submitButtonImage: UIImage? = nil) {
        self.navigationBarBackground = navigationBarBackground ?? hexStringToUIColor(hex: "F3F6FF")
        self.isShowNavigationBarShadow = isShowNavigationBarShadow ?? true
        self.titleText = titleText ?? "Feedback"
        self.titleTextFont = titleTextFont ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 17, iPadSize: 22)
        self.titleTextColor = titleTextColor ?? hexStringToUIColor(hex: "1B79FF")
        self.backButtonImage = backButtonImage ?? ImageHelper.image(named: "ic_back")
        self.placeholderButtonImage = placeholderButtonImage ?? ImageHelper.image(named: "ic_feedback_poster")
        self.shareExperienceText = shareExperienceText ?? "Share your experience with us"
        self.shareExperienceFont = shareExperienceFont ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 13, iPadSize: 19)
        self.shareExperienceTextColor = shareExperienceTextColor ?? hexStringToUIColor(hex: "898989")
        self.whyUseText = whyUseText ?? "What is your Profession?"
        self.whyUsePlaceholderText = whyUsePlaceholderText ?? "Write Here..."
        self.whyUseTextFont = whyUseTextFont ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 13, iPadSize: 19)
        self.whyUseTextFontTextfield = whyUseTextFontTextfield ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 12, iPadSize: 16)
        self.whyUseTextColor = whyUseTextColor ?? .black
        self.suggestionText = suggestionText ?? "Write your Suggestions"
        self.suggestionPlaceholderText = suggestionPlaceholderText ?? "Write Here your suggestion/Feedback..."
        self.suggestionTextFont = suggestionTextFont ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 13, iPadSize: 19)
        self.suggestionTextFontTextfield = suggestionTextFontTextfield ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 12, iPadSize: 16)
        self.suggestionTextColor = suggestionTextColor ?? .black
        self.limitTextFont = limitTextFont ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Medium, iPhoneSize: 13, iPadSize: 18)
        self.limitTextColor = limitTextColor ?? hexStringToUIColor(hex: "898989")
        self.submitText = submitText ?? "Submit"
        self.submitTextFont = submitTextFont ?? setCustomFont_WithoutRatio(name: .PlusJakartaSans_Bold, iPhoneSize: 15, iPadSize: 20)
        self.submitTextColor = submitTextColor ?? .white
        self.submitButtonImage = submitButtonImage ?? ImageHelper.image(named: "ic_btn_bg")
    }
}

public class FeedbackVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var viewNavBar: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareExperienceLbl: UILabel!
    @IBOutlet weak var whyUseAppLbl: UILabel!
    @IBOutlet weak var whyUseView: UIView!
    @IBOutlet weak var whyUseTextField: UITextField!
    @IBOutlet weak var suggetionLbl: UILabel!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var suggetionTextView: PlaceholderTextView!
    @IBOutlet weak var charCountLbl: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private let maxCharacterCount = 500
    
    // MARK: - Public Properties
    
    public var customization = UICustomizationFeedback()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func setUpUI() {
        
        submitButton.layer.cornerRadius = UIDevice.current.isiPhone ? 10 : 12
        submitButton.layer.masksToBounds = true
        
        whyUseTextField.semanticContentAttribute = .forceLeftToRight
        whyUseTextField.textAlignment = .left
        suggetionTextView.delegate = self
        suggetionTextView.placeholderStr = customization.suggestionPlaceholderText?.localized()
        
        charCountLbl.text = "0/\(maxCharacterCount)"
        
        if customization.isShowNavigationBarShadow ?? true {
            DispatchQueue.main.async {
                self.viewNavBar.addBottomViewShadow()
            }
        }
    }
    
    private func updateUI() {
        
        setUpUI()
        
        // Update Navigation Bar
        viewNavBar.backgroundColor = customization.navigationBarBackground
        
        // Update Back Button Image
        btnBack.setImage(customization.backButtonImage, for: .normal)
        
        // Update Placeholder Image
        imgPlaceholder.image = customization.placeholderButtonImage
        
        // Update Title Label
        titleLabel.text = customization.titleText?.localized()
        titleLabel.font = customization.titleTextFont
        titleLabel.textColor = customization.titleTextColor
        
        // Update Share Experience Label
        shareExperienceLbl.text = customization.shareExperienceText?.localized()
        shareExperienceLbl.font = customization.shareExperienceFont
        shareExperienceLbl.textColor = customization.shareExperienceTextColor
        
        // Update Why Use App Label
        whyUseAppLbl.text = customization.whyUseText?.localized()
        whyUseAppLbl.font = customization.whyUseTextFont
        whyUseTextField.font = customization.whyUseTextFontTextfield
        whyUseAppLbl.textColor = customization.whyUseTextColor
        whyUseTextField.placeholder = customization.whyUsePlaceholderText?.localized()
        
        // Update Suggestion Label
        suggetionLbl.text = customization.suggestionText?.localized()
        suggetionLbl.font = customization.suggestionTextFont
        suggetionTextView.font = customization.suggestionTextFontTextfield
        suggetionLbl.textColor = customization.suggestionTextColor
        
        // Update Char Count Label
        charCountLbl.font = customization.limitTextFont
        charCountLbl.textColor = customization.limitTextColor
        
        // Update Submit Button
        submitButton.setTitle(customization.submitText?.localized(), for: .normal)
        submitButton.titleLabel?.font = customization.submitTextFont
        submitButton.setTitleColor(customization.submitTextColor, for: .normal)
        if let buttonImage = customization.submitButtonImage {
            submitButton.setBackgroundImage(buttonImage, for: .normal)
        }
    }
}

//MARK: - Button Actions.
extension FeedbackVC {
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        if (whyUseTextField.text?.trimmed().isEmpty ?? false) {
            self.view.makeToast("Please enter text".localized(), position: .center)
        } else if (suggetionTextView.text.trimmed().isEmpty) {
            self.view.makeToast("Please enter your suggestions".localized(), position: .center)
        } else {
            if Reachability_Manager.isConnectedToNetwork() {

                self.startLoader()

                sendAppReview(review: suggetionTextView.text.trimmed(), subscriptionReview: "", useOfApp: self.whyUseTextField.text?.trimmed() ?? "") { success in
                    
                    self.stopLoader()

                    if success {
                        DispatchQueue.main.async {
                            self.view.makeToast("Feedback sent successfully".localized(), position: .center)
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                self.dismiss(animated: true)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.makeToast("Something went wrong!".localized(), position: .center)
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "Check your internet connection".localized(), message:"", preferredStyle: .alert)
                let retry = UIAlertAction(title: "Retry".localized(), style: .default) { _ in
                    self.submitButtonClicked(UIButton())
                }
                let ok = UIAlertAction(title: "OK".localized(), style: .cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension FeedbackVC: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        suggetionTextView.textDidChange()
        let currentText = textView.text ?? ""
        if currentText.count > maxCharacterCount {
            textView.text = String(currentText.prefix(maxCharacterCount))
        }
        
        let currentCount = textView.text?.count ?? 0
        charCountLbl.text = "\(currentCount)/\(maxCharacterCount)"
    }
}
