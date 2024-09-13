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

class RatingVC: UIViewController {

    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblLater: UILabel!
    
    var completionAskMeLater: ((String)->())?
    
    let rateURL = "https://apps.apple.com/us/app/id1659583821?action=write-review"
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        AddFirebaseEvent(eventName: EventsValues.RatingShow)
        self.initalViewDidLoad()
    }
    
    func initalViewDidLoad(){
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        viewRate.layer.masksToBounds = false
        lblTitle.text = "Enjoying the app?".localized()
        lblSubTitle.text = "Let us know by leaving a 5 star rating".localized()
        lblLater.text = "Ask me latter!".localized()
    }
    
    @IBAction func btnAwesomeClick(_ sender: Any) {
        self.dismiss(animated: true) {
            if let rateUs = URL(string: self.rateURL) {
                AddFirebaseEvent(eventName: EventsValues.RatingAwesome)
                isAppRedirected = true
                isUserGivenRating = true
                UIApplication.shared.open(rateUs, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func btnImprovementClick(_ sender: Any) {
        AddFirebaseEvent(eventName: EventsValues.RatingImprovement)
        isUserGivenRating = true
        funSendMail()
    }
    
    @IBAction func btnLaterClick(_ sender: Any) {
        AddFirebaseEvent(eventName: EventsValues.RatingLater)
        self.dismiss(animated: true, completion: {
            self.completionAskMeLater?("close")
        })
    }
}

//MARK: - Mail
extension RatingVC: MFMailComposeViewControllerDelegate
{
    func funSendMail() {
        let recipientEmail = "vvinfotech19@gmail.com"
        let subject = "AI Voice Changer - Prank Sound"
        let body = ""

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        self.dismiss(animated: true, completion: {
            self.completionAskMeLater?("close")
        })
    }
}
