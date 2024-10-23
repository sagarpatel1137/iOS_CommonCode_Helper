//
//  PodBundleHelper.swift
//  iOS_CommonCode
//
//  Created by IOS on 23/10/24.
//

import Foundation

public class PodBundleHelper {

    // Example function to load a .json file
    public static func loadJSONFile(named fileName: String) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON file not found in bundle.")
            return nil
        }
        return url
    }
}
