//
//  AppDelegate.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseCrashlytics
import NetworkPlatform


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var didLunchedFromNotification: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !UserDefaults.standard.bool(forKey:"isAppOpenedBefore"){
            UserDefaults.standard.set(true, forKey: "isAppOpenedBefore")
            AuthorizationInfo.clearAuth()
        }
        
        
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        if FirebaseApp.app() == nil {
            FirebaseConfiguration.shared.setLoggerLevel(.min)
            FirebaseApp.configure()
        }
        Messaging.messaging().delegate = self
        
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            didLunchedFromNotification  = true
        }
        
        if !UserDefaults.standard.bool(forKey:"isAppOpenedBefore"){
            UserDefaults.standard.set(true, forKey: "isAppOpenedBefore")
            FirebaseTrackerManager.shared.sendEvent(eventName: FirebaseTrackerManager.FirebaseMain.appInstalled.rawValue)
            
        }
        
        FirebaseTrackerManager.shared.sendEvent(eventName: FirebaseTrackerManager.FirebaseMain.appOpened.rawValue)
        
        
        // Enable Logger
        Logger()
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                Logger.debugLog("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                Logger.debugLog("Remote instance ID token: \(result.token)")
                self.saveFirebaseToken(result.token)
            }
        }
        
        setupApplication()
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SoketManager.shared.closeConnection()
    }
    
    fileprivate func saveFirebaseToken(_ deviceToken: String) {
        let storage = UserDefaultsFirebasePushNotificationTokenStorage()
        storage.saveNewToken(deviceToken)
    }
    
    private func setupApplication() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.configureMainInterface(window)
        self.window = window
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        let isGooglePlusURL = GIDSignIn.sharedInstance().handle(url)
        return isGooglePlusURL
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DispatchQueue.main.async {
            if (url.scheme == "linkedinCallbackURI"){
                print("Im here!!!")
            }
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
        
        bgTask = application.beginBackgroundTask(withName:"backgroundTask", expirationHandler: {() -> Void in
            //print("The task has started")
            application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        })
        
        application.setMinimumBackgroundFetchInterval(60 * 2)
        
        FirebaseTrackerManager.shared.sendEvent(eventName: FirebaseTrackerManager.FirebaseMain.appClosed.rawValue)
        
        
    }
    
    
}

extension AppDelegate {
    
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
