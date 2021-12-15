//
//  STNotificationSettings.swift
//  Stocks App
//
//  Created by bhanuteja on 15/12/21.
//

import Foundation

class STNotificationSetting: NSObject {
    static let notificationKey = "ST_Notification_Key"
    
    static let shared = STNotificationSetting()
    
    private override init() {
        
    }
    
    private var setting: [String: Bool] {
        get {
            let key = STNotificationSetting.notificationKey
            if let setting = UserDefaults.standard.object(forKey: key) as? [String: Bool] {
                return setting
            }
            
            return [:]
        }
        set(newValue) {
            var setting: [String: Bool] = [:]
            
            for (k,v) in newValue {
                setting[k.uppercased()] = v
            }
            
            UserDefaults.standard.set(setting, forKey: STNotificationSetting.notificationKey)
        }
    }
    
    func enabled(for stock: String) -> Bool {
        if let stock = setting.first(where:  { $0.key == stock.uppercased() }) {
            return stock.value
        }
        return false
    }
    
    func saveNotification(for stock: String, enabled: Bool) {
        setting[stock.uppercased()] = enabled
    }
}
