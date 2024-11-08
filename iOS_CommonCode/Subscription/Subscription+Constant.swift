//
//  Subscription+Constant.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/10/24.
//

import UIKit

/// sendAppReview
/// - Parameters:
///   - reviewModel: appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
public func sendAppReview(review: String, subscriptionReview: String, useOfApp: String, completion: @escaping (Bool) -> Void) {
    
    if let url = URL(string: "https://appreview.vasundharaapps.com/api/app_review_ios") {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "package_name": Pod_AppPackageName,
            "review": review,
            "subscription_review": subscriptionReview,
            "use_of_app": useOfApp,
            "version_code": Pod_AppVersionCode
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Failed to create JSON body: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responseCode = json["ResponseCode"] as? Int,
                   responseCode == 200 {
                    print(json)
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print("Failed to parse JSON response: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        task.resume()
    }
}

public func presentSubAlertSheet(on viewController: UIViewController, completion: @escaping (String) -> Void) {
    if !isFeedbackSheetShown {
        if !Purchase_flag {
            if UIDevice.current.isiPhone {
                let lblNotIntrested = "Not interested?".localized()
                let pleaseshareLbl = "Please share why".localized()
                
                let alertController = UIAlertController(title: lblNotIntrested, message: pleaseshareLbl, preferredStyle: .actionSheet)
                
                let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
                let attributedTitle = NSMutableAttributedString(string: lblNotIntrested, attributes: titleFont)
                let subtitleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
                let attributedMessage = NSMutableAttributedString(string: "\n" + pleaseshareLbl, attributes: subtitleFont)
                
                alertController.setValue(attributedTitle, forKey: "attributedTitle")
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
                
                let options = [
                    "Don't know what it is",
                    "Too expensive",
                    "I don't pay for apps",
                    "I need to try it first"
                ]
                
                for option in options {
                    let action = UIAlertAction(title: option.localized(), style: .default) { feedback in
                        sendAppReview(review: "", subscriptionReview: option, useOfApp: "") { _ in }
                        completion(option)
                    }
                    alertController.addAction(action)
                }
                
                alertController.modalPresentationStyle = .popover
                if let popoverPresentationController = alertController.popoverPresentationController {
                    popoverPresentationController.permittedArrowDirections = []
                    popoverPresentationController.passthroughViews = nil
                    popoverPresentationController.sourceView = viewController.view
                    popoverPresentationController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
                }
                
                viewController.present(alertController, animated: true, completion: nil)
            } else {
                /*
                presentCustomActionSheet(on: viewController) { item in
                    completion(item)
                }
                 */
                completion("")
            }
        } else {
            completion("")
        }
        isFeedbackSheetShown = true
    } else {
        completion("")
    }
}

func presentCustomActionSheet(on viewController: UIViewController, completion: @escaping (String) -> Void) {
    
    let backgroundView = UIView(frame: viewController.view.bounds)
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    backgroundView.isUserInteractionEnabled = true
    viewController.view.addSubview(backgroundView)
    
    let customActionSheet = CustomActionSheetView(
        title: "Not interested?",
        message: "Please share why",
        options: [
            "Don't know what it is",
            "Too expensive",
            "I don't pay for apps",
            "I need to try it first"
        ]
    )
    
    customActionSheet.completion = { selectedOption in
        sendAppReview(review: "", subscriptionReview: selectedOption, useOfApp: "") { _ in }
        completion(selectedOption)
    }
    
    customActionSheet.translatesAutoresizingMaskIntoConstraints = false
    viewController.view.addSubview(customActionSheet)
    
    // Set constraints for customActionSheet to center it on the screen
    NSLayoutConstraint.activate([
        customActionSheet.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
        customActionSheet.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
        customActionSheet.widthAnchor.constraint(equalToConstant: 300),
        customActionSheet.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
    ])
    
    // Add animation for appearance
    customActionSheet.alpha = 0
    UIView.animate(withDuration: 0.3) {
        customActionSheet.alpha = 1
    }
}
