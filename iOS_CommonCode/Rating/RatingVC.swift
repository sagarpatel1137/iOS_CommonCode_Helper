//
//  RatingVC.swift
//  VoiceChanger
//
//  Created by iOS on 18/07/23.
//

import UIKit
import Foundation
import MarqueeLabel
import MessageUI

public enum RatingResponse {
    case Awesome
    case NeedImprovement
    case AskMeLater
    case MailFailed
}

public class RatingVC: UIViewController {

    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblLater: UILabel!
    
    public var rateURL = ""
    public var mailRecipientEmail = ""
    public var mailSubject = ""
    public var mailBody = ""
    public var completion: ((RatingResponse)->())?
    public var isOpenFrom = ""

    //MARK: -
    public override func viewDidLoad() {
        super.viewDidLoad()
        AddFirebaseEvent(eventName: .RatingShow, parameters: ["from": self.isOpenFrom])
        self.initalViewDidLoad()
    }
    
    private func initalViewDidLoad(){
        
        viewRate.layer.masksToBounds = false
        lblTitle.text = "Enjoying the app?".localized()
        lblSubTitle.text = "Let us know by leaving a 5 star rating".localized()
        lblLater.text = "Ask me latter!".localized()
    }
    
    @IBAction func btnAwesomeClick(_ sender: Any) {
        self.dismiss(animated: true) {
            if let rateUs = URL(string: self.rateURL) {
                self.completion?(RatingResponse.Awesome)
                AddFirebaseEvent(eventName: .RatingPositive, parameters: ["from": self.isOpenFrom])
                isUserGivenRating = true
                UIApplication.shared.open(rateUs, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func btnImprovementClick(_ sender: Any) {
        AddFirebaseEvent(eventName: .RatingNegative, parameters: ["from": self.isOpenFrom])
        self.completion?(RatingResponse.NeedImprovement)
        isUserGivenRating = true
        funSendMail()
    }
    
    @IBAction func btnLaterClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            AddFirebaseEvent(eventName: .RatingLater, parameters: ["from": self.isOpenFrom])
            self.completion?(RatingResponse.AskMeLater)
        })
    }
}

//MARK: - Mail
extension RatingVC: MFMailComposeViewControllerDelegate
{
    private func funSendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailRecipientEmail])
            mail.setSubject(mailSubject)
            mail.setMessageBody(mailBody, isHTML: false)
            present(mail, animated: true)
        } else if let emailUrl = createEmailUrl(to: mailRecipientEmail, subject: mailSubject, body: mailBody) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        }
        return defaultUrl
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        self.dismiss(animated: true, completion: {
            self.completion?(RatingResponse.MailFailed)
        })
    }
}
