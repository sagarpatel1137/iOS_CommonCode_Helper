//
//  webVC.swift
//  VoiceChanger
//
//  Created by iOS on 22/08/23.
//

import UIKit
import WebKit
import Alamofire
import iOS_CommonCode_Helper

class webVC: UIViewController {

    //MARK: -
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: -
    let reachabilityManager = NetworkReachabilityManager()
    var titleStr = ""
    var urlStr = ""
    var isUrlLoadDone = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = titleStr.localized()
        
        loadURL()
        DispatchQueue.main.async {
            self.view.startLoader()
        }
    }
    
    //MARK: -
    func loadURL() {
        if Reachability.isConnectedToNetwork() {
            let url = URL(string: urlStr)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            webView.navigationDelegate = self
        }
        else {
            showAlert()
        }
    }
    
    func showAlert() {
        self.view.stopLoader()
        let alert = UIAlertController(title: "Check your internet connection".localized(), message:"", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let retry = UIAlertAction(title: "Retry".localized(), style: .cancel) { _ in
            self.view.startLoader()
            self.loadURL()
        }
        alert.addAction(cancel)
        alert.addAction(retry)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: -
    @IBAction func btnBackClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension webVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView : Start Request")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView : Failed Request")
        showAlert()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView : Finished Request")
        self.view.stopLoader()
    }
}
