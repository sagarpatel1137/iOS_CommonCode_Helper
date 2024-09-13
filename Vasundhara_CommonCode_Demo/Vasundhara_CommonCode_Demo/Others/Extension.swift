//
//  Extension.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit
import MBProgressHUD

extension String {
    
    func localized() -> String
    {
        var defaultLanguage = AppLaungauge_Code
        if defaultLanguage.count == 0{
            defaultLanguage = "en"
        }
        if let path = Bundle.main.path(forResource: defaultLanguage, ofType: "strings")
        {
            if FileManager.default.fileExists(atPath: path) {
                let dicoLocalisation = NSDictionary(contentsOfFile: path)
                return dicoLocalisation?.value(forKey: self) as? String ?? self
            }
        }
        return self
    }
}
