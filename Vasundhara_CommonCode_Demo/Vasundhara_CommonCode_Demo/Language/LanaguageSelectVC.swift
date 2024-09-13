//
//  LanaguageSelectVC.swift
//  VoiceChanger
//
//  Created by IOS on 27/08/24.
//

import UIKit
import MarqueeLabel
import iOS_CommonCode_Helper

class LanaguageSelectVC: UIViewController {

    //MARK: -
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var viewBannerAd: UIView!
    @IBOutlet weak var viewBannerAd_Height: NSLayoutConstraint!
    @IBOutlet weak var viewPadding: UIView!
    
    //MARK: -
    struct LanguageDetails {
        var lang_code : String
        var lang_name : String
        var lang_name_loc : String
        
        init(lang_code: String, lang_name: String, lang_name_loc: String) {
            self.lang_code = lang_code
            self.lang_name = lang_name
            self.lang_name_loc = lang_name_loc
        }
    }
    
    var arrayItems: [Any] = [
        LanguageDetails(lang_code: "en", lang_name: "English", lang_name_loc: "English"),
        LanguageDetails(lang_code: "pt-PT", lang_name: "Portuguese", lang_name_loc: "Português"),
        LanguageDetails(lang_code: "da", lang_name: "Danish", lang_name_loc: "dansk"),
        LanguageDetails(lang_code: "zh-Hans", lang_name: "Chinese", lang_name_loc: "中国人"),
        LanguageDetails(lang_code: "es", lang_name: "Spanish", lang_name_loc: "Española"),
        LanguageDetails(lang_code: "fr", lang_name: "French", lang_name_loc: "Français"),
        LanguageDetails(lang_code: "it", lang_name: "Italian", lang_name_loc: "Italiano"),
        LanguageDetails(lang_code: "ar", lang_name: "Arabic", lang_name_loc: "عربي"),
        LanguageDetails(lang_code: "ja", lang_name: "Japanese", lang_name_loc: "日本語"),
        LanguageDetails(lang_code: "ko", lang_name: "Korean", lang_name_loc: "한국인"),
        LanguageDetails(lang_code: "fil", lang_name: "Filipino", lang_name_loc: "Filipino"),
        LanguageDetails(lang_code: "af", lang_name: "Afrikaans", lang_name_loc: "Afrikaans"),
        LanguageDetails(lang_code: "th", lang_name: "Thai", lang_name_loc: "แบบไทย"),
        LanguageDetails(lang_code: "ur", lang_name: "Urdu", lang_name_loc: "اردو"),
        LanguageDetails(lang_code: "ru", lang_name: "Russian", lang_name_loc: "Русский")
    ]
    
    var isFromInitial = false
    var tempSelLang = "en"
    var completionLangSelected: (()->())?
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpText()
        funCheckForBannerAd()
    }

    //MARK: -
    func setUpUI()
    {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        tblView.showsVerticalScrollIndicator = false
        tblView.showsHorizontalScrollIndicator = false
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: LanagSelCell.identifier, bundle: nil), forCellReuseIdentifier: LanagSelCell.identifier)
        
        lblTitle.font = UIFont(name: WorkSans_SemiBold, size: UIDevice.current.isiPad == true ? 25.0 : 18.0)
        
        if isFromInitial {
            btnBack.isHidden = true
        } else {
            btnDone.isHidden = true
        }
    }
    
    func setUpText() {
        lblTitle.text = "Change Language".localized()
    }
    
    //MARK: - Actions
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        AppLaungauge_Code = tempSelLang
        self.navigationController?.popViewController(animated: false)
        self.completionLangSelected?()
    }
}

extension LanaguageSelectVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanagSelCell.identifier) as! LanagSelCell
        if let items = arrayItems[indexPath.row] as? LanguageDetails {
            cell.lblName.text = items.lang_name_loc
            cell.lblLocDetail.text = items.lang_name
            if isFromInitial {
                cell.funSet(isSelected: items.lang_code == tempSelLang)
            } else {
                cell.funSet(isSelected: items.lang_code == AppLaungauge_Code)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.isiPhone ? 72 : 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let items = arrayItems[indexPath.row] as? LanguageDetails {
            if isFromInitial {
                tempSelLang = items.lang_code
            } else {
                AppLaungauge_Code = items.lang_code
            }
            tableView.reloadData()
            self.setUpText()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UIDevice.current.isiPhone ? 8 : 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// -------------------------------------------------
// MARK: - Adaptive Banner AD
// -------------------------------------------------
extension LanaguageSelectVC
{
    func funCheckForBannerAd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            if Purchase_flag {
                funHideBannerAd()
            } else {
                funShowBannerAd()
            }
        }
    }
    
    func funShowBannerAd() {
        viewBannerAd_Height.constant = GoogleAd_Manager.shared.funGetAdaptiveBannerHeight()
        GoogleAd_Manager.shared.funShowBannerAd(parentView: viewBannerAd)
    }
    
    func funHideBannerAd() {
        self.viewBannerAd.isHidden = true
        self.viewBannerAd_Height.constant = 0
        self.viewPadding.isHidden = true
    }
}

