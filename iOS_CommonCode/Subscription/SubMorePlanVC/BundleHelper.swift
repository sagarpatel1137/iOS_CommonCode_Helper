//
//  BundleHelper.swift
//  iOS_CommonCode
//
//  Created by IOS on 28/10/24.
//

import Foundation

public class BundleHelper {
    public static let podFramework = Bundle(for: BundleHelper.self)
    public static let podBundlePath = BundleHelper.podFramework.path(
        forResource: "MyModule",
        ofType: "bundle"
    )
    public static let podBundle: Bundle? = {
        guard let podBundlePath = podBundlePath else {
            return nil
        }
        return Bundle(path: podBundlePath)
    }()
}
