//
//  FeedbackVC.swift
//  GPS Map Camera
//
//  Created by iOS on 05/08/24.
//

import UIKit
import Toast_Swift
import iOS_CommonCode_Helper

class FeedbackVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setText()
        setFont()
    }
    
    private func setUpUI() {
        
        submitButton.layer.cornerRadius = UIDevice.current.isiPhone ? 10*fontRatio : 12*fontRatio
        submitButton.layer.masksToBounds = true
        
        whyUseTextField.semanticContentAttribute = .forceLeftToRight
        whyUseTextField.textAlignment = .left
        suggetionTextView.delegate = self
        
        charCountLbl.text = "0/\(maxCharacterCount)"
    }
    
    private func setText() {
        titleLabel.text = "Feedback".localized()
        shareExperienceLbl.text = "Share your experience with us".localized()
        whyUseAppLbl.text = "What is your Profession?".localized()
        suggetionLbl.text = "Write your Suggestions".localized()
        submitButton.setTitle("Submit".localized(), for: .normal)
        whyUseTextField.placeholder = "Write Here...".localized()
        suggetionTextView.placeholderStr = "Write Here your suggestion/Feedback...".localized()
    }
    
    private func setFont() {
        
        titleLabel.font = setCustomFont(name: WorkSans_SemiBold, iPhoneSize: 15, iPadSize: 21)
        shareExperienceLbl.font = setCustomFont(name: WorkSans_Medium, iPhoneSize: 13, iPadSize: 19)
        whyUseAppLbl.font = setCustomFont(name: WorkSans_Medium, iPhoneSize: 13, iPadSize: 19)
        suggetionLbl.font = setCustomFont(name: WorkSans_Medium, iPhoneSize: 13, iPadSize: 1)
        submitButton.titleLabel?.font = setCustomFont(name: WorkSans_SemiBold, iPhoneSize: 15, iPadSize: 20)
    }
}

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
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
            if Reachability.isConnectedToNetwork() {
                self.view.startLoader()
                sendAppReview(packageName: "com.voiceeffectchanger", review: suggetionTextView.text.trimmed(), subscriptionReview: "", useOfApp: self.whyUseTextField.text?.trimmed() ?? "") { success in
                    if success {
                        DispatchQueue.main.async {
                            self.view.stopLoader()
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
    func textViewDidChange(_ textView: UITextView) {
        suggetionTextView.textDidChange()
        let currentText = textView.text ?? ""
        if currentText.count > maxCharacterCount {
            textView.text = String(currentText.prefix(maxCharacterCount))
        }
        
        let currentCount = textView.text?.count ?? 0
        charCountLbl.text = "\(currentCount)/\(maxCharacterCount)"
    }
}
