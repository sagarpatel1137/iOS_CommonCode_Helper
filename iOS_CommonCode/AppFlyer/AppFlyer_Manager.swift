//
//  AppFlyer_Manager.swift
//  CommonCode_iOS
//
//  Created by IOS on 14/06/24.
//

/*
import StoreKit
import AppsFlyerLib
import PurchaseConnector

class AppFlyer_Manager : NSObject {

    public static let shared = AppFlyer_Manager()

    public func initialize(withAppID appId: String, appsFlyerKey DevKey: String) {

        AppsFlyerLib.shared().appsFlyerDevKey = DevKey
        AppsFlyerLib.shared().appleAppID = appId
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().useReceiptValidationSandbox = true
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        PurchaseConnector.shared().purchaseRevenueDelegate = self
        PurchaseConnector.shared().purchaseRevenueDataSource = self
        PurchaseConnector.shared().autoLogPurchaseRevenue = .autoRenewableSubscriptions
    }
    
    // start AppsFlyer SDK
    @objc private func sendLaunch() {
        AppsFlyerLib.shared().start()
        PurchaseConnector.shared().startObservingTransactions()
    }
}

//MARK: - AppsFlyerLib Delegate
extension AppFlyer_Manager : AppsFlyerLibDelegate
{
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        //..
    }
    
    public func onConversionDataFail(_ error: Error) {
        //..
    }
}

//MARK: - PurchaseRevenue Delegate & DataSource
extension AppFlyer_Manager: PurchaseRevenueDataSource, PurchaseRevenueDelegate {
    
    // PurchaseRevenueDelegate method implementation
    public func didReceivePurchaseRevenueValidationInfo(_ validationInfo: [AnyHashable : Any]?, error: Error?) {
        print("PurchaseRevenueDelegate: \(validationInfo)")
        print("PurchaseRevenueDelegate: \(error)")
    }
    
    // PurchaseRevenueDataSource method implementation
    public func purchaseRevenueAdditionalParameters(for products: Set<SKProduct>, transactions: Set<SKPaymentTransaction>?) -> [AnyHashable : Any]? {
        return ["additionalParameters":["param1":"value1", "param2":"value2"]];
    }
}
*/
