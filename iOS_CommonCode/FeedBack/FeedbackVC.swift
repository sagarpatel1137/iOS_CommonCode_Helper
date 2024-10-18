//
//  FeedbackVC.swift
//  GPS Map Camera
//
//  Created by iOS on 05/08/24.
//

import UIKit

public struct UICustomizationFeedback {
    var navigationBarBackground: UIColor? = hexStringToUIColor(hex: "F3F6FF")
    var isShowNavigationBarShadow: Bool = true
    var titleText: String? = "Feedback"
    var titleTextFont: UIFont? = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 17, iPadSize: 22)
    var titleTextColor: UIColor? = hexStringToUIColor(hex: "1B79FF")
    var backButtonImage: UIImage? = UIImage(named: "ic_back")
    var placeholderButtonImage: UIImage? = UIImage(named: "ic_feedback_poster")
    var shareExperienceText: String? = "Share your experience with us"
    var shareExperienceFont: UIFont? = setCustomFont(name: .PlusJakartaSans_Medium, iPhoneSize: 13, iPadSize: 19)
    var shareExperienceTextColor: UIColor? = hexStringToUIColor(hex: "898989")
    var whyUseText: String? = "What is your Profession?"
    var whyUsePlaceholderText: String? = "Write Here..."
    var whyUseTextFont: UIFont? = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 13, iPadSize: 19)
    var whyUseTextColor: UIColor? = .black
    var suggestionText: String? = "Write your Suggestions"
    var suggestionPlaceholderText: String? = "Write Here your suggestion/Feedback..."
    var suggestionTextFont: UIFont? = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 13, iPadSize: 19)
    var suggestionTextColor: UIColor? = .black
    var limitTextFont: UIFont? = setCustomFont(name: .PlusJakartaSans_Medium, iPhoneSize: 13, iPadSize: 19)
    var limitTextColor: UIColor? = hexStringToUIColor(hex: "898989")
    var submitText: String? = "Submit"
    var submitTextFont: UIFont? = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 15, iPadSize: 20)
    var submitTextColor: UIColor? = .white
    var submitButtonImage: UIImage? = UIImage(named: "ic_btn_bg")
}

class FeedbackVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUpUI() {
        
        submitButton.layer.cornerRadius = UIDevice.current.isiPhone ? 10 : 12
        submitButton.layer.masksToBounds = true
        
        whyUseTextField.semanticContentAttribute = .forceLeftToRight
        whyUseTextField.textAlignment = .left
        suggetionTextView.delegate = self
        suggetionTextView.placeholderStr = customization.suggestionPlaceholderText?.localized()
        
        charCountLbl.text = "0/\(maxCharacterCount)"
        
        if customization.isShowNavigationBarShadow {
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
        titleLabel.text = customization.titleText
        titleLabel.font = customization.titleTextFont
        titleLabel.textColor = customization.titleTextColor
        
        // Update Share Experience Label
        shareExperienceLbl.text = customization.shareExperienceText
        shareExperienceLbl.font = customization.shareExperienceFont
        shareExperienceLbl.textColor = customization.shareExperienceTextColor
        
        // Update Why Use App Label
        whyUseAppLbl.text = customization.whyUseText
        whyUseAppLbl.font = customization.whyUseTextFont
        whyUseAppLbl.textColor = customization.whyUseTextColor
        whyUseTextField.placeholder = customization.whyUsePlaceholderText?.localized()
        
        // Update Suggestion Label
        suggetionLbl.text = customization.suggestionText
        suggetionLbl.font = customization.suggestionTextFont
        suggetionLbl.textColor = customization.suggestionTextColor
        
        // Update Char Count Label
        charCountLbl.font = customization.limitTextFont
        charCountLbl.textColor = customization.limitTextColor
        
        // Update Submit Button
        submitButton.setTitle(customization.submitText, for: .normal)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        if (whyUseTextField.text?.trimmed().isEmpty ?? false) {
            self.view.makeToast("Please enter text".localized(), position: .center)
        } else if (suggetionTextView.text.trimmed().isEmpty) {
            self.view.makeToast("Please enter your suggestions".localized(), position: .center)
        } else {
            if Reachability.isConnectedToNetwork() {

                self.startLoader()

                sendAppReview(review: suggetionTextView.text.trimmed(), subscriptionReview: "", useOfApp: self.whyUseTextField.text?.trimmed() ?? "") { success in
                    
                    self.stopLoader()

                    if success {
                        DispatchQueue.main.async {
                            self.view.makeToast("Feedback sent successfully".localized(), position: .center)
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                self.navigationController?.popViewController(animated: true)
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
