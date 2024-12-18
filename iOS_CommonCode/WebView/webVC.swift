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
    public var navigationBarHeight : CGFloat?
    public var backButtonWidth : CGFloat?
    
    public init(navBarBackgroundColor: UIColor? = nil, backButtonImage: UIImage? = nil, titleFont: UIFont? = nil, titleTextColor: UIColor? = nil, navigationBarHeight: CGFloat? = nil, backButtonWidth: CGFloat? = nil) {
        self.navBarBackgroundColor = navBarBackgroundColor ?? hexStringToUIColor(hex: "F3F6FF")
        self.backButtonImage = backButtonImage ?? ImageHelper.image(named: "ic_back")
        self.titleFont = titleFont ?? setCustomFont_WithoutRatio(name: .WorkSans_SemiBold, iPhoneSize: 20, iPadSize: 20)
        self.navigationBarHeight = navigationBarHeight
        self.backButtonWidth = backButtonWidth
        self.titleTextColor = titleTextColor ?? .black
    }
}

public class webVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var viewNavBar: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var navigationBarHeightCon: NSLayoutConstraint!
    
    // MARK: - Public Properties
    public var titleStr: String = ""
    public var urlStr: String = ""
    var customization: UICustomizationWebView = UICustomizationWebView()
        
    // MARK: - Private Properties
    private let reachabilityManager = NetworkReachabilityManager()

    var completionBack: (()->())?

    // MARK: - Status Bar Settings
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        loadURL()
        self.Pod_startLoader()
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
        
        if let navigationBarHeight = customization.navigationBarHeight {
            navigationBarHeightCon.constant = navigationBarHeight
        }
        if let width = customization.backButtonWidth {
            backButtonWidth.constant = width
        }
    }
    
    // MARK: - Load URL
    func loadURL() {
        if Reachability_Manager.isConnectedToNetwork() {
            guard let url = URL(string: self.urlStr) else { return }
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            webView.navigationDelegate = self
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        self.Pod_stopLoader()
        let alert = UIAlertController(title: "Check your internet connection".localized(), message:"", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let retry = UIAlertAction(title: "Retry".localized(), style: .cancel) { _ in
            self.Pod_startLoader()
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
        completionBack?()
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
        self.Pod_stopLoader()
    }
}
