//
//  AppDelegate.swift
//  Stocks App
//
//  Created by bhanuteja on 15/12/21.
//

import UIKit
import PushNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        pushNotifications.start(instanceId: AppConstants.BEAMS_INSTANCE_ID)
        pushNotifications.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
                pushNotifications.registerDeviceToken(deviceToken)
            }


}

