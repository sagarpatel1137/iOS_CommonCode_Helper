//
//  webVC.swift
//  VoiceChanger
//
//  Created by iOS on 22/08/23.
//

import UIKit
import WebKit
import Alamofire

public struct UICustomizationWebView {
    public var navBarBackgroundColor: UIColor?
    public var backButtonImage: UIImage?
    public var titleFont: UIFont?
    public var titleTextColor: UIColor?
    
    public init(navBarBackgroundColor: UIColor? = nil, backButtonImage: UIImage? = nil, titleFont: UIFont? = nil, titleTextColor: UIColor? = nil) {
        self.navBarBackgroundColor = navBarBackgroundColor ?? hexStringToUIColor(hex: "F3F6FF")
        self.backButtonImage = backButtonImage ?? UIImage(named: "ic_back")
        self.titleFont = titleFont ?? setCustomFont(name: .WorkSans_SemiBold, iPhoneSize: 20, iPadSize: 20)
        self.titleTextColor = titleTextColor ?? .black
    }
}

open class webVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var viewNavBar: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Public Properties
    public var titleStr: String = ""
    public var urlStr: String = ""
    var customization: UICustomizationWebView = UICustomizationWebView()
        
    // MARK: - Private Properties
    private let reachabilityManager = NetworkReachabilityManager()

    // MARK: - Status Bar Settings
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - View Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        loadURL()
        self.startLoader()
    }
    
    // MARK: - Update UI Method
    private func updateUI() {
        // Apply custom navbar background color
        viewNavBar.backgroundColor = customization.navBarBackgroundColor
        
        // Apply custom back button image
        if let backImage = customization.backButtonImage {
            btnBack.setImage(backImage, for: .normal)
        } else {
            btnBack.setImage(nil, for: .normal) // Remove image if nil
        }
        
        // Set custom navbar title
        lblTitle.text = self.titleStr.localized()
        lblTitle.font = customization.titleFont
        lblTitle.textColor = customization.titleTextColor
    }
    
    // MARK: - Load URL
    func loadURL() {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: self.urlStr) else { return }
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            webView.navigationDelegate = self
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        self.stopLoader()
        let alert = UIAlertController(title: "Check your internet connection".localized(), message:"", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let retry = UIAlertAction(title: "Retry".localized(), style: .cancel) { _ in
            self.startLoader()
            self.loadURL()
        }
        alert.addAction(cancel)
        alert.addAction(retry)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func btnBackClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension webVC: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView : Start Request")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView : Failed Request")
        showAlert()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView : Finished Request")
        self.stopLoader()
    }
}
