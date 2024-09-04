//
//  AppMetrica_Manager.swift
//  CommonCode_iOS
//
//  Created by IOS on 15/06/24.
//

import AppMetricaCore

public class AppMetrica_Manager {
    
    public static func initialize(withID appMetricaId: String){
        
        let configuration = AppMetricaConfiguration(apiKey: appMetricaId)
        AppMetrica.activate(with: configuration!)
    }
}

public class AppMetrica_Event {
    
    public static func AddAppMetricaEvent(eventName: String) {
        AppMetrica.reportEvent(name: eventName)
    }
}
