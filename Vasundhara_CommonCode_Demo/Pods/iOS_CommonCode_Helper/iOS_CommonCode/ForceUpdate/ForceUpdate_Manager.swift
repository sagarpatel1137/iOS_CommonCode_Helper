//
//  ForceUpdate_Manager.swift
//  Vasundhara iOS
//
//  Created by IOS on 27/07/24.
//

import UIKit
import Foundation

public struct AlertForceUpdate {
    var alertTitle = "Update Required"
    var alertMessage = "We've noticed that you've been using the deprecated application version for a long time. Please update to the latest version and enjoy the app."
    var alertActionUpdate = "Update"
    var alertActionCancel = "Cancel"
}

public final class ForceUpdate_Manager: NSObject {
 
    private static let shared = ForceUpdate_Manager()
    private var applicationId = ""
    private var alert = AlertForceUpdate()
    private let timeoutInterval :TimeInterval = 120
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    public var isAppNeedForceUpdate = false
    
    public static func configure(withAppID appId: Int) {
        shared.applicationId = "id\(appId)"
        shared.checkForForceUpdate()
        shared.addNotification()
    }
    
    public static func configureForceUpdateAlert(title: String, message: String, actionBtn: String, cancelBtn: String) {
        shared.alert.alertTitle = title
        shared.alert.alertMessage = message
        shared.alert.alertActionUpdate = actionBtn
        shared.alert.alertActionCancel = cancelBtn
    }
}

//MARK: - API Call
extension ForceUpdate_Manager
{
    private func checkForForceUpdate() {
        
        if Reachability.isConnectedToNetwork() {
            
            guard let url = URL(string: "https://fourceupdate.vasundharaapps.com/api/ApkVersionIos") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let parameters: [String: String] = [
                "package_name": applicationId,
                "version_code": appVersion
            ]
            
            let boundary = UUID().uuidString
            var body = ""
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
            body.append("--\(boundary)--\r\n")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = body.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Response: \(jsonResponse)")
                        if let status_bool = jsonResponse["status"] as? Bool {
                            if status_bool {
                                if let isNeed = jsonResponse["is_need_to_update"] as? Bool {
                                    if isNeed {
                                        self.isAppNeedForceUpdate = true
                                        self.showForceAlert()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

//MARK: - Alert
extension ForceUpdate_Manager
{
    private func showForceAlert()
    {
        DispatchQueue.main.async { [self] in
            
            let alertController = UIAlertController(title: alert.alertTitle, message: alert.alertMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: alert.alertActionUpdate, style: UIAlertAction.Style.default) {
                UIAlertAction in
                if let url = URL(string: "itms-apps://apple.com/app/\(self.applicationId)") {
                    UIApplication.shared.open(url)
                }
            }
            let cancelAction = UIAlertAction(title: alert.alertActionCancel, style: UIAlertAction.Style.default) {
                UIAlertAction in
                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: - Notification
extension ForceUpdate_Manager {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        if self.isAppNeedForceUpdate {
            self.showForceAlert()
        }
    }
}

